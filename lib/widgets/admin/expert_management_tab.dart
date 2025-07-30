import 'package:flutter/material.dart';
import 'package:vguard/core/app_constants.dart';
import 'package:vguard/models/expert.dart';
import 'package:vguard/services/admin_data_service.dart';

class ExpertManagementTab extends StatefulWidget {
  const ExpertManagementTab({super.key});

  @override
  State<ExpertManagementTab> createState() => _ExpertManagementTabState();
}

class _ExpertManagementTabState extends State<ExpertManagementTab> {
  final AdminDataService _adminDataService = AdminDataService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _specialtyController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _languagesController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();

  void _addExpert() async {
    if (_nameController.text.isEmpty ||
        _specialtyController.text.isEmpty ||
        _experienceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill all required fields (Name, Specialty, Experience).',
          ),
        ),
      );
      return;
    }

    final newExpert = Expert(
      name: _nameController.text.trim(),
      specialty: _specialtyController.text.trim(),
      experience: _experienceController.text.trim(),
      languages:
          _languagesController.text
              .trim()
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList(),
      rating: double.tryParse(_ratingController.text.trim()) ?? 0.0,
    );

    try {
      await _adminDataService.addExpert(newExpert);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Expert added successfully!')));
        // Clear fields
        _nameController.clear();
        _specialtyController.clear();
        _experienceController.clear();
        _languagesController.clear();
        _ratingController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to add expert: $e')));
      }
    }
  }

  void _deleteExpert(String id) async {
    try {
      await _adminDataService.deleteExpert(id);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Expert deleted successfully!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete expert: $e')));
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    _experienceController.dispose();
    _languagesController.dispose();
    _ratingController.dispose();
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
            '+ Add New Expert',
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
              hintText: 'Enter expert name',
              labelText: 'Name',
            ),
          ),
          SizedBox(height: AppSizes.paddingMedium),
          TextField(
            controller: _specialtyController,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: AppColors.grey100,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryGreen),
              ),
              hintText: 'e.g., Agronomy, Pest Control',
              labelText: 'Specialty',
            ),
          ),
          SizedBox(height: AppSizes.paddingMedium),
          TextField(
            controller: _experienceController,
            maxLines: 2,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: AppColors.grey100,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryGreen),
              ),
              hintText: 'Enter years of experience or brief background',
              labelText: 'Experience',
            ),
          ),
          SizedBox(height: AppSizes.paddingMedium),
          TextField(
            controller: _languagesController,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: AppColors.grey100,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryGreen),
              ),
              hintText: 'e.g., English, Sinhala (comma-separated)',
              labelText: 'Languages',
            ),
          ),
          SizedBox(height: AppSizes.paddingMedium),
          TextField(
            controller: _ratingController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: AppColors.grey100,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryGreen),
              ),
              hintText: 'Enter rating (e.g., 4.5)',
              labelText: 'Rating',
            ),
          ),
          SizedBox(height: AppSizes.paddingXLarge * 2),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _addExpert,
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
                'Add Expert',
                style: TextStyle(fontSize: 16, color: AppColors.white),
              ),
            ),
          ),
          SizedBox(height: AppSizes.paddingXLarge),

          SizedBox(height: AppSizes.paddingMedium),
          StreamBuilder<List<Expert>>(
            stream: _adminDataService.getExperts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No experts added yet.'));
              } else {
                final experts = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: experts.length,
                  itemBuilder: (context, index) {
                    final expert = experts[index];
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    expert.name,
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Specialty: ${expert.specialty}',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.grey600,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Experience: ${expert.experience}',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.grey600,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  if (expert.languages.isNotEmpty)
                                    Wrap(
                                      spacing: AppSizes.paddingSmall * 0.6,
                                      children:
                                          expert.languages
                                              .map(
                                                (lang) => Chip(
                                                  label: Text(
                                                    lang,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                  backgroundColor:
                                                      AppColors
                                                          .lightGreenBackground,
                                                ),
                                              )
                                              .toList(),
                                    ),
                                  SizedBox(height: 2),
                                  if (expert.rating > 0)
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: AppColors.amber,
                                          size: 16,
                                        ),
                                        SizedBox(
                                          width: AppSizes.paddingSmall * 0.6,
                                        ),
                                        Text('${expert.rating}'),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: AppColors.red),
                              onPressed: () => _deleteExpert(expert.id!),
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
