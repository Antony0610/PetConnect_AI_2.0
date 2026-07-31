import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/repositories/pets_repository.dart';
import '../domain/pet_entity.dart';

class AddPetScreen extends StatefulWidget {
  final PetEntity? petToEdit;

  const AddPetScreen({super.key, this.petToEdit});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _petsRepository = PetsRepository();

  late TextEditingController _nameController;
  late TextEditingController _breedController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _colorController;
  late TextEditingController _medicalNotesController;
  late TextEditingController _emergencyNameController;
  late TextEditingController _emergencyPhoneController;

  String _species = 'Dog';
  String _gender = 'Male';
  String _vaccinationStatus = 'Up-to-Date';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final p = widget.petToEdit;
    _nameController = TextEditingController(text: p?.name ?? '');
    _breedController = TextEditingController(text: p?.breed ?? '');
    _ageController = TextEditingController(text: p != null ? p.ageYears.toString() : '');
    _weightController = TextEditingController(text: p != null ? p.weightKg.toString() : '');
    _colorController = TextEditingController(text: p?.color ?? '');
    _medicalNotesController = TextEditingController(text: p?.medicalNotes ?? '');
    _emergencyNameController = TextEditingController(text: p?.emergencyContactName ?? 'Dr. Sarah Jenkins');
    _emergencyPhoneController = TextEditingController(text: p?.emergencyContactPhone ?? '+1 (800) 555-PETS');

    if (p != null) {
      _species = p.species;
      _gender = p.gender;
      _vaccinationStatus = p.vaccinationStatus;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _colorController.dispose();
    _medicalNotesController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  void _savePet() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final newPet = PetEntity(
      id: widget.petToEdit?.id ?? 'pet_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      species: _species,
      breed: _breedController.text.trim(),
      ageYears: double.tryParse(_ageController.text.trim()) ?? 1.0,
      gender: _gender,
      weightKg: double.tryParse(_weightController.text.trim()) ?? 10.0,
      color: _colorController.text.trim().isEmpty ? 'Golden' : _colorController.text.trim(),
      vaccinationStatus: _vaccinationStatus,
      medicalNotes: _medicalNotesController.text.trim().isEmpty
          ? 'No known medical issues.'
          : _medicalNotesController.text.trim(),
      emergencyContactName: _emergencyNameController.text.trim(),
      emergencyContactPhone: _emergencyPhoneController.text.trim(),
      ownerName: 'Pet Owner',
      photoUrl: widget.petToEdit?.photoUrl ?? '',
      galleryPhotos: widget.petToEdit?.galleryPhotos ?? [],
      vitals: widget.petToEdit?.vitals ??
          CollarTelemetry(
            dailySteps: 8420,
            sleepHours: 9.2,
            activeMinutes: 145,
            batteryLevel: 94,
            gpsStatus: 'GPS Locked',
            lastUpdated: DateTime.now(),
          ),
    );

    await _petsRepository.savePet(newPet);

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${newPet.name}\'s profile saved successfully!')),
    );

    context.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.petToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Pet Profile' : 'Add New Pet'),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: AppColors.primaryTeal.withOpacity(0.15),
                      child: const Icon(Icons.pets, size: 48, color: AppColors.primaryTeal),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.primaryTeal,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Image picker triggered. Photo selected.')),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.gapLg,
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Pet Name *',
                  prefixIcon: Icon(Icons.pets, color: AppColors.primaryTeal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Pet name is required' : null,
              ),
              AppSpacing.gapMd,
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _species,
                      decoration: const InputDecoration(
                        labelText: 'Species',
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Dog', child: Text('Dog')),
                        DropdownMenuItem(value: 'Cat', child: Text('Cat')),
                        DropdownMenuItem(value: 'Bird', child: Text('Bird')),
                        DropdownMenuItem(value: 'Other', child: Text('Other')),
                      ],
                      onChanged: (v) {
                        if (v != null) setState(() => _species = v);
                      },
                    ),
                  ),
                  AppSpacing.gapMd,
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _gender,
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Male', child: Text('Male')),
                        DropdownMenuItem(value: 'Female', child: Text('Female')),
                      ],
                      onChanged: (v) {
                        if (v != null) setState(() => _gender = v);
                      },
                    ),
                  ),
                ],
              ),
              AppSpacing.gapMd,
              TextFormField(
                controller: _breedController,
                decoration: const InputDecoration(
                  labelText: 'Breed *',
                  prefixIcon: Icon(Icons.category_outlined, color: AppColors.primaryTeal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Breed is required' : null,
              ),
              AppSpacing.gapMd,
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Age (Years)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Age is required' : null,
                    ),
                  ),
                  AppSpacing.gapMd,
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Weight (kg)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Weight is required' : null,
                    ),
                  ),
                ],
              ),
              AppSpacing.gapMd,
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(
                  labelText: 'Color / Markings',
                  prefixIcon: Icon(Icons.palette_outlined, color: AppColors.primaryTeal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
              AppSpacing.gapMd,
              DropdownButtonFormField<String>(
                value: _vaccinationStatus,
                decoration: const InputDecoration(
                  labelText: 'Vaccination Status',
                  prefixIcon: Icon(Icons.verified_outlined, color: AppColors.primaryTeal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
                items: const [
                  DropdownMenuItem(value: 'Up-to-Date', child: Text('Up-to-Date')),
                  DropdownMenuItem(value: 'Pending Booster', child: Text('Pending Booster')),
                  DropdownMenuItem(value: 'Overdue', child: Text('Overdue')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _vaccinationStatus = v);
                },
              ),
              AppSpacing.gapMd,
              TextFormField(
                controller: _medicalNotesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Medical Notes & Allergies',
                  prefixIcon: Icon(Icons.description_outlined, color: AppColors.primaryTeal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
              AppSpacing.gapMd,
              TextFormField(
                controller: _emergencyNameController,
                decoration: const InputDecoration(
                  labelText: 'Emergency Vet Contact Name',
                  prefixIcon: Icon(Icons.contact_phone_outlined, color: AppColors.primaryTeal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
              AppSpacing.gapMd,
              TextFormField(
                controller: _emergencyPhoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Emergency Contact Phone Number',
                  prefixIcon: Icon(Icons.phone, color: AppColors.primaryTeal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
              AppSpacing.gapLg,
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _isLoading ? null : _savePet,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(isEditing ? 'Save Changes' : 'Register Pet', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
