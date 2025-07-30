import 'package:flutter/material.dart';
import 'package:vguard/core/app_constants.dart';

class DiseaseDetailsPage extends StatelessWidget {
  final String diseaseName;
  final String affectedCrop;
  final String severity;
  final String cause;
  final List<String> symptoms;
  final String treatment;
  final String prevention;

  const DiseaseDetailsPage({
    super.key,
    this.diseaseName = 'Leaf Blight',
    this.affectedCrop = 'Rice',
    this.severity = 'High',
    this.cause = 'Fungal infection due to high humidity',
    this.symptoms = const ['Yellow spots', 'Brown edges', 'Wilting'],
    this.treatment = 'Copper fungicide spray',
    this.prevention = 'Proper drainage, avoid overhead watering',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        elevation: AppSizes.cardElevation,
        automaticallyImplyLeading: true,
        title: Image.asset(
          'assets/images/logo.png',
          height: 150,
          width: 150,
          fit: BoxFit.contain,
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              diseaseName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),

            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _buildDiseaseInformationCard()),
                  SizedBox(width: 16),
                  Expanded(child: _buildTreatmentPreventionCard(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseInformationCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.grey200),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: AppColors.grey100)],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Disease Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
              ],
            ),
            Divider(height: 20, thickness: 1),
            _buildInfoRow(
              'Affected Crop:',
              affectedCrop,
              valueColor: Colors.green,
            ),
            _buildInfoRow('Severity:', severity, valueColor: Colors.red),
            _buildInfoRow('Cause:', cause),
            SizedBox(height: 10),
            Text(
              'Symptoms:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 5),
            ...symptoms.map((symptom) => _buildBulletPoint(symptom)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[800],
            height: 1.5, // Line spacing
          ),
          children: [
            TextSpan(
              text: label,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text: ' $value',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: valueColor ?? Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 16, color: Colors.black87)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentPreventionCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.grey200),

        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: AppColors.grey100)],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shield_outlined, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Treatment & Prevention',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
              ],
            ),
            Divider(height: 20, thickness: 1),
            _buildSectionContainer(
              label: 'Treatment:',
              content: treatment,
              backgroundColor: Colors.green.withOpacity(0.1),
            ),
            SizedBox(height: 15),
            _buildSectionContainer(
              label: 'Prevention:',
              content: prevention,
              backgroundColor: Colors.orange.withOpacity(0.1),
            ),
            Spacer(),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Saved to My Notes!')));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF388E3C),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0), // Rounded button
                  ),
                ),

                child: Text(
                  'Save to My Notes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionContainer({
    required String label,
    required String content,
    required Color backgroundColor,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: Colors.grey[900], height: 1.4),
          children: [
            TextSpan(
              text: label,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: ' \n\n$content'),
          ],
        ),
      ),
    );
  }
}
