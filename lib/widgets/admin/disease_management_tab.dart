import 'package:flutter/material.dart';
import 'package:vguard/core/app_constants.dart';
import 'package:vguard/models/disease.dart';
import 'package:vguard/services/admin_data_service.dart';

class DiseaseManagementTab extends StatefulWidget {
  const DiseaseManagementTab({super.key});

  @override
  State<DiseaseManagementTab> createState() => _DiseaseManagementTabState();
}

class _DiseaseManagementTabState extends State<DiseaseManagementTab> {
  final AdminDataService _adminDataService = AdminDataService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();
  final TextEditingController _treatmentController = TextEditingController();
  final TextEditingController _preventionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  void _addDisease() async {
    if (_nameController.text.isEmpty ||
        _symptomsController.text.isEmpty ||
        _treatmentController.text.isEmpty ||
        _preventionController.text.isEmpty ||
        _categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill all required fields (Name, Symptoms, Treatment, Prevention, Category).',
          ),
        ),
      );
      return;
    }

    final newDisease = Disease(
      name: _nameController.text.trim(),
      symptoms: _symptomsController.text.trim(),
      treatment: _treatmentController.text.trim(),
      prevention: _preventionController.text.trim(),
      category: _categoryController.text.trim(),
      imageUrl:
          _imageUrlController.text.trim().isEmpty
              ? null
              : _imageUrlController.text.trim(),
    );

    try {
      await _adminDataService.addDisease(newDisease);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Disease added successfully!')));
        // Clear fields
        _nameController.clear();
        _symptomsController.clear();
        _treatmentController.clear();
        _preventionController.clear();
        _categoryController.clear();
        _imageUrlController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to add disease: $e')));
      }
    }
  }

  void _deleteDisease(String id) async {
    try {
      await _adminDataService.deleteDisease(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Disease deleted successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete disease: $e')));
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _symptomsController.dispose();
    _treatmentController.dispose();
    _preventionController.dispose();
    _categoryController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSizes.paddingXLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '+ Add New Disease',
            style: AppTextStyles.heading2.copyWith(
              color: AppColors.black87,
              fontSize: 20,
            ),
          ),
          SizedBox(height: AppSizes.paddingMedium),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: AppColors.grey100,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryGreen),
              ),
              hintText: 'Enter disease name',
              labelText: 'Disease Name',
            ),
          ),
          SizedBox(height: AppSizes.paddingMedium),
          TextField(
            controller: _categoryController,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: AppColors.grey100,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryGreen),
              ),
              hintText: 'e.g., Fungal, Bacterial, Viral',
              labelText: 'Category',
            ),
          ),
          SizedBox(height: AppSizes.paddingMedium),
          TextField(
            controller: _symptomsController,
            maxLines: 3,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: AppColors.grey100,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryGreen),
              ),
              hintText: 'Describe symptoms',
              labelText: 'Symptoms',
            ),
          ),
          SizedBox(height: AppSizes.paddingMedium),
          TextField(
            controller: _treatmentController,
            maxLines: 3,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: AppColors.grey100,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryGreen),
              ),
              hintText: 'Describe treatment options',
              labelText: 'Treatment',
            ),
          ),
          SizedBox(height: AppSizes.paddingMedium),
          TextField(
            controller: _preventionController,
            maxLines: 3,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: AppColors.grey100,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryGreen),
              ),
              hintText: 'Describe prevention methods',
              labelText: 'Prevention',
            ),
          ),
          SizedBox(height: AppSizes.paddingMedium),
          TextField(
            controller: _imageUrlController,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: AppColors.grey100,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryGreen),
              ),
              hintText: 'Optional: Enter image URL',
              labelText: 'Image URL',
            ),
            keyboardType: TextInputType.url,
          ),
          SizedBox(height: AppSizes.paddingXLarge * 2),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _addDisease,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppSizes.borderRadiusMedium,
                  ),
                ),
              ),
              icon: Icon(Icons.add, color: AppColors.white),
              autofocus: true,
              label: Text(
                'Add Disease',
                style: TextStyle(fontSize: 16, color: AppColors.white),
              ),
            ),
          ),
          SizedBox(height: AppSizes.paddingXLarge),

          SizedBox(height: AppSizes.paddingMedium),
          StreamBuilder<List<Disease>>(
            stream: _adminDataService.getDiseases(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No diseases added yet.'));
              } else {
                final diseases = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: diseases.length,
                  itemBuilder: (context, index) {
                    final disease = diseases[index];
                    return Card(
                      color: AppColors.grey50,
                      margin: EdgeInsets.symmetric(
                        vertical: AppSizes.paddingSmall,
                      ),
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: AppColors.grey200),
                        borderRadius: BorderRadius.circular(
                          AppSizes.borderRadiusMedium,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(AppSizes.paddingMedium),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (disease.imageUrl != null &&
                                disease.imageUrl!.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(
                                  right: AppSizes.paddingMedium,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.borderRadiusSmall,
                                  ),
                                  child: Image.network(
                                    disease.imageUrl!,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                          Icons.broken_image,
                                          size: 80,
                                          color: AppColors.grey400,
                                        ),
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    disease.name,
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: AppSizes.paddingSmall),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: AppSizes.paddingSmall,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryGreen.withOpacity(
                                        0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.borderRadiusSmall,
                                      ),
                                    ),
                                    child: Text(
                                      disease.category,
                                      style: TextStyle(
                                        color: AppColors.primaryGreen,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: AppSizes.paddingSmall),
                                  Text(
                                    'Symptoms: ${disease.symptoms}',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.grey600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Treatment: ${disease.treatment}',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.grey600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Prevention: ${disease.prevention}',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.grey600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: AppColors.red),
                              onPressed: () => _deleteDisease(disease.id!),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
