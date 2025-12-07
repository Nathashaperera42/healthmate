import 'package:flutter/material.dart';
import 'package:healthmate/core/theme/app_theme.dart';
import 'package:healthmate/data/models/health_record.dart';
import 'package:healthmate/features/health_records/presentation/providers/health_record_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddRecordPage extends StatefulWidget {
  const AddRecordPage({super.key, this.record, this.isEditMode = false});

  final HealthRecord? record;
  final bool isEditMode;

  @override
  State<AddRecordPage> createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> {
  final _formKey = GlobalKey<FormState>();
  final _stepsController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _waterController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.record != null) {
      _stepsController.text = widget.record!.steps.toString();
      _caloriesController.text = widget.record!.calories.toString();
      _waterController.text = widget.record!.water.toString();
      _selectedDate = DateTime.parse(widget.record!.date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          widget.record == null ? 'Add Health Record' : 'Edit Health Record',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildDateCard(),
              
              const SizedBox(height: 20),
              
            
              _buildInputCard(
                'Steps Walked',
                'Enter your daily steps',
                Icons.directions_walk,
                AppTheme.stepsColor,
                _stepsController,
                'steps',
              ),
              
              const SizedBox(height: 16),
              
              _buildInputCard(
                'Calories Burned',
                'Enter calories burned',
                Icons.local_fire_department,
                AppTheme.caloriesColor,
                _caloriesController,
                'calories',
              ),
              
              const SizedBox(height: 16),
              
              _buildInputCard(
                'Water Intake',
                'Enter water in ml',
                Icons.water_drop,
                AppTheme.waterColor,
                _waterController,
                'water',
              ),
              
              const SizedBox(height: 30),
              
              // Submit Button
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    widget.record == null ? 'Add Record' : 'Update Record',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.calendar_today,
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
                Text(
                  DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          
          if (widget.record == null)
            IconButton(
              onPressed: _selectDate,
              icon: Icon(
                Icons.edit,
                color: AppTheme.primaryColor,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInputCard(
    String title,
    String hint,
    IconData icon,
    Color color,
    TextEditingController controller,
    String field,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppTheme.backgroundLight,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            keyboardType: TextInputType.number,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $field';
              }
              if (int.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final record = HealthRecord(
        id: widget.record?.id,
        date: DateFormat('yyyy-MM-dd').format(_selectedDate),
        steps: int.parse(_stepsController.text),
        calories: int.parse(_caloriesController.text),
        water: int.parse(_waterController.text),
      );

      final provider = Provider.of<HealthRecordProvider>(context, listen: false);
      
      if (widget.record == null) {
        
        provider.addRecord(record);
      } else {
     
        provider.updateRecord(record);
      }

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _stepsController.dispose();
    _caloriesController.dispose();
    _waterController.dispose();
    super.dispose();
  }
}