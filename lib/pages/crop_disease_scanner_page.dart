import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vguard/core/app_constants.dart';
import 'package:vguard/models/disease_info.dart';
import 'package:vguard/models/medicine.dart';
import 'package:vguard/models/prediction_response.dart';
import 'package:vguard/services/disease_scan_service.dart';

class CropDiseaseScannerPage extends StatefulWidget {
  const CropDiseaseScannerPage({super.key});

  @override
  State<CropDiseaseScannerPage> createState() => _CropDiseaseScannerPageState();
}

class _CropDiseaseScannerPageState extends State<CropDiseaseScannerPage> {
  File? _selectedImageFile; // For mobile/desktop
  Uint8List? _selectedImageBytes; // For web
  final ImagePicker _picker = ImagePicker();
  final DiseaseScanService _diseaseScanService = DiseaseScanService();

  PredictionResponse? _predictionResult;
  DiseaseInfo? _diseaseInfo;
  MedicineResponse? _medicineResponse;
  bool _isLoading = false;
  String? _errorMessage;
  bool _showResults = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      if (kIsWeb) {
        // For web, read as bytes
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
          _selectedImageFile = null; // Clear file for web
          _predictionResult = null;
          _diseaseInfo = null;
          _medicineResponse = null;
          _errorMessage = null;
          _showResults = false;
        });
      } else {
        // For mobile/desktop, use File
        setState(() {
          _selectedImageFile = File(pickedFile.path);
          _selectedImageBytes = null; // Clear bytes for mobile/desktop
          _predictionResult = null;
          _diseaseInfo = null;
          _medicineResponse = null;
          _errorMessage = null;
          _showResults = false;
        });
      }
      _analyzeCrop();
    }
  }

  Future<void> _analyzeCrop() async {
    if (_selectedImageFile == null && _selectedImageBytes == null) {
      setState(() {
        _errorMessage = "Please select an image to scan.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _showResults = false;
    });

    try {
      // Pass either File or bytes, the service should handle it
      final prediction = await _diseaseScanService.predictDisease(
        kIsWeb ? _selectedImageBytes! : _selectedImageFile!,
      );
      _predictionResult = prediction;

      if (prediction.predictedClass != "normal" &&
          prediction.predictedClass.isNotEmpty) {
        _diseaseInfo = await _diseaseScanService.getDiseaseInfo(
          prediction.predictedClass,
        );
        _medicineResponse = await _diseaseScanService.getRecommendedMedicines(
          prediction.predictedClass,
        );
      } else {
        _diseaseInfo = null;
        _medicineResponse = null;
      }

      setState(() {
        _showResults = true;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to analyze crop: ${e.toString()}';
        _showResults = false;
      });
      print('API Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearSelection() {
    setState(() {
      _selectedImageFile = null;
      _selectedImageBytes = null;
      _predictionResult = null;
      _diseaseInfo = null;
      _medicineResponse = null;
      _showResults = false;
      _errorMessage = null;
    });
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.paddingMedium),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.darkGreen,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        elevation: AppSizes.cardElevation,
        automaticallyImplyLeading: false,
        title: Image.asset(
          'assets/images/logo.png',
          height: 150,
          width: 150,
          fit: BoxFit.contain,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: AppColors.lightGreenBackground,
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingLarge,
              vertical: AppSizes.paddingMedium,
            ),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                  label: Text('Back'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSizes.borderRadiusMedium,
                      ),
                      side: BorderSide(color: AppColors.grey300),
                    ),
                    elevation: AppSizes.cardElevation,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingMedium,
                      vertical: AppSizes.paddingSmall + 4,
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.horizontalSpacing),
                Text(
                  'Crop Disease Scanner',
                  style: AppTextStyles.pageHeaderTitle,
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 1000),
                padding: EdgeInsets.all(AppSizes.paddingLarge),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 600) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCaptureUploadCard(),
                          SizedBox(height: AppSizes.verticalSpacing),
                          Expanded(child: _buildAnalysisResultsCard()),
                        ],
                      );
                    } else {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildCaptureUploadCard()),
                          SizedBox(width: AppSizes.horizontalSpacing),
                          Expanded(child: _buildAnalysisResultsCard()),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptureUploadCard() {
    return Card(
      elevation: AppSizes.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
        side: BorderSide(color: AppColors.grey300, style: BorderStyle.solid),
      ),
      color: AppColors.white,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.paddingXLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.black87,
                  size: AppSizes.iconSizeLarge,
                ),
                SizedBox(width: AppSizes.paddingSmall),
                Text(
                  'Capture or Upload Image',
                  style: AppTextStyles.featureCardTitle,
                ),
              ],
            ),
            SizedBox(height: AppSizes.paddingXLarge),
            // Image Preview Area
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(
                  AppSizes.borderRadiusMedium,
                ),
                border: Border.all(
                  color: AppColors.grey200,
                  style: BorderStyle.solid,
                ),
              ),
              child:
                  (_selectedImageFile != null || _selectedImageBytes != null)
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppSizes.borderRadiusMedium,
                        ),
                        child:
                            kIsWeb && _selectedImageBytes != null
                                ? Image.memory(
                                  _selectedImageBytes!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder:
                                      (context, error, stackTrace) => Center(
                                        child: Text(
                                          'Error loading image: $error',
                                        ),
                                      ),
                                )
                                : Image.file(
                                  _selectedImageFile!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder:
                                      (context, error, stackTrace) => Center(
                                        child: Text(
                                          'Error loading image: $error',
                                        ),
                                      ),
                                ),
                      )
                      : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            color: AppColors.grey400,
                            size: AppSizes.iconSizeHero,
                          ),
                          SizedBox(height: AppSizes.paddingSmall),
                          Text(
                            'Take a photo or upload an image of your\ncrop',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.grey600),
                          ),
                        ],
                      ),
            ),
            SizedBox(height: AppSizes.paddingXLarge),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: Icon(Icons.camera_alt_outlined),
                label: Text('Take Photo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: AppColors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: AppSizes.paddingMedium,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppSizes.borderRadiusMedium,
                    ),
                  ),
                  elevation: AppSizes.cardElevation,
                ),
              ),
            ),
            SizedBox(height: AppSizes.paddingSmall + 4),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: Icon(Icons.photo_library_outlined),
                label: Text('Upload Image'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.black87,
                  padding: EdgeInsets.symmetric(
                    vertical: AppSizes.paddingMedium,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppSizes.borderRadiusMedium,
                    ),
                    side: BorderSide(color: AppColors.grey300),
                  ),
                  elevation: AppSizes.cardElevation,
                ),
              ),
            ),
            if (_selectedImageFile != null || _selectedImageBytes != null) ...[
              SizedBox(height: AppSizes.paddingSmall + 4),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _clearSelection,
                  icon: Icon(Icons.clear),
                  label: Text('Clear Selection'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.red,
                    side: BorderSide(color: AppColors.red),
                    padding: EdgeInsets.symmetric(
                      vertical: AppSizes.paddingMedium,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSizes.borderRadiusMedium,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisResultsCard() {
    return Card(
      elevation: AppSizes.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
        side: BorderSide(color: AppColors.grey300),
      ),
      color: AppColors.white,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.paddingXLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Analysis Results', style: AppTextStyles.featureCardTitle),
            SizedBox(height: AppSizes.paddingXLarge),
            if (_isLoading)
              Center(
                child: LoadingAnimationWidget.threeRotatingDots(
                  color: AppColors.primaryGreen,
                  size: 50,
                ),
              )
            else if (_errorMessage != null)
              Expanded(
                child: Center(
                  child: Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.red,
                      fontSize: AppSizes.paddingMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            else if (_showResults && _predictionResult != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Prediction'),
                      Text(
                        'Predicted Class: ${_predictionResult!.predictedClass.toUpperCase()}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                        ),
                      ),
                      SizedBox(height: AppSizes.paddingSmall),
                      Text(
                        'Confidence: ${(_predictionResult!.confidence * 100).toStringAsFixed(2)}%',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: AppSizes.paddingMedium),
                      Text(
                        'All Confidences:',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ..._predictionResult!.allConfidences.entries.map(
                        (entry) => Padding(
                          padding: EdgeInsets.only(
                            left: AppSizes.paddingSmall,
                            top: AppSizes.paddingSmall * 0.5,
                          ),
                          child: Text(
                            '${entry.key.replaceAll('_', ' ').toUpperCase()}: ${(entry.value * 100).toStringAsFixed(2)}%',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),

                      if (_predictionResult!.predictedClass == "normal")
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: AppSizes.paddingLarge,
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  size: 80,
                                  color: AppColors.primaryGreen,
                                ),
                                SizedBox(height: AppSizes.paddingMedium),
                                Text(
                                  'Your crop appears healthy!',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(color: AppColors.primaryGreen),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: AppSizes.paddingSmall),
                                Text(
                                  'Keep up the good work.',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (_diseaseInfo != null) ...[
                        _buildSectionTitle('Disease Information'),
                        Text(
                          _diseaseInfo!.diseaseName,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreen,
                          ),
                        ),
                        SizedBox(height: AppSizes.paddingSmall),
                        Text(
                          'Caused By: ${_diseaseInfo!.causedBy}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: AppSizes.paddingSmall),
                        Text(
                          _diseaseInfo!.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SizedBox(height: AppSizes.paddingMedium),
                        _buildSectionTitle('Symptoms'),
                        ..._diseaseInfo!.symptoms.map(
                          (symptom) => Padding(
                            padding: EdgeInsets.only(
                              left: AppSizes.paddingSmall,
                              bottom: AppSizes.paddingSmall * 0.5,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: AppColors.primaryGreen,
                                ),
                                SizedBox(width: AppSizes.paddingSmall),
                                Expanded(
                                  child: Text(
                                    symptom,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: AppSizes.paddingMedium),
                        _buildSectionTitle('Factors'),
                        ..._diseaseInfo!.factors.map(
                          (factor) => Padding(
                            padding: EdgeInsets.only(
                              left: AppSizes.paddingSmall,
                              bottom: AppSizes.paddingSmall * 0.5,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: AppColors.primaryGreen,
                                ),
                                SizedBox(width: AppSizes.paddingSmall),
                                Expanded(
                                  child: Text(
                                    factor,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: AppSizes.paddingMedium),
                        _buildSectionTitle('Prevention'),
                        ..._diseaseInfo!.prevention.map(
                          (prevention) => Padding(
                            padding: EdgeInsets.only(
                              left: AppSizes.paddingSmall,
                              bottom: AppSizes.paddingSmall * 0.5,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: AppColors.primaryGreen,
                                ),
                                SizedBox(width: AppSizes.paddingSmall),
                                Expanded(
                                  child: Text(
                                    prevention,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: AppSizes.paddingMedium),
                        _buildSectionTitle('Treatment'),
                        Text(
                          _diseaseInfo!.treatment,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        if (_diseaseInfo!.note.isNotEmpty) ...[
                          SizedBox(height: AppSizes.paddingMedium),
                          _buildSectionTitle('Note'),
                          Text(
                            _diseaseInfo!.note,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontStyle: FontStyle.italic),
                          ),
                        ],

                        if (_medicineResponse != null &&
                            _medicineResponse!
                                .recommendedMedicines
                                .isNotEmpty) ...[
                          _buildSectionTitle('Recommended Medicines'),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount:
                                _medicineResponse!.recommendedMedicines.length,
                            itemBuilder: (context, index) {
                              final medicine =
                                  _medicineResponse!
                                      .recommendedMedicines[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: AppSizes.paddingMedium,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${medicine.name} (${medicine.brand})',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryGreen,
                                      ),
                                    ),
                                    SizedBox(
                                      height: AppSizes.paddingSmall * 0.5,
                                    ),
                                    if (medicine.imageUrl.isNotEmpty)
                                      Image.network(
                                        medicine.imageUrl,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(
                                                  Icons.broken_image,
                                                  color: AppColors.grey100,
                                                ),
                                      ),
                                    SizedBox(
                                      height: AppSizes.paddingSmall * 0.5,
                                    ),
                                    Text('Type: ${medicine.type}'),
                                    Text(
                                      'Active Ingredient: ${medicine.activeIngredient}',
                                    ),
                                    Text('Pack Size: ${medicine.packSize}'),
                                    Text('Price: ${medicine.price}'),
                                    Text(
                                      'Application Rate: ${medicine.applicationRate}',
                                    ),
                                    Text('Method: ${medicine.method}'),
                                    Text('Frequency: ${medicine.frequency}'),
                                    Text(
                                      'Availability: ${medicine.availability}',
                                    ),
                                    if (medicine.note.isNotEmpty)
                                      Text(
                                        'Note: ${medicine.note}',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall?.copyWith(
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: Center(
                  child: Text(
                    'Upload an image to see analysis results',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.grey600,
                      fontSize: AppSizes.paddingMedium,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
