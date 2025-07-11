import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:untitled5/Provider/ScoreProvider.dart';
import 'package:untitled5/Screens/ScoreCardPreviewPage.dart';
import 'package:untitled5/Services/offline_submission.dart';
import 'package:untitled5/TrainCoachFormScreen.dart';

class ScoreCardIntroPage extends StatefulWidget {
  const ScoreCardIntroPage({Key? key}) : super(key: key);

  @override
  State<ScoreCardIntroPage> createState() => _ScoreCardIntroPageState();
}

class _ScoreCardIntroPageState extends State<ScoreCardIntroPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  DateTime? inspectionDate;
  final TextEditingController woNoController = TextEditingController();
  final TextEditingController nameOfWorkController = TextEditingController();
  final TextEditingController nameOfContractorController = TextEditingController();
  final TextEditingController nameOfSupervisorController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController trainNoController = TextEditingController();
  final TextEditingController arrivalTimeController = TextEditingController();
  final TextEditingController departureTimeController = TextEditingController();
  final TextEditingController coachesAttendedController = TextEditingController();
  final TextEditingController totalCoachesController = TextEditingController();
  final TextEditingController totalScoreController = TextEditingController();
  final TextEditingController inaccessibleAreasController = TextEditingController();

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
 Provider.of<ScoreProvider>(context, listen: false).restoreFromPrefs().then((_) {
      final scoreProvider = Provider.of<ScoreProvider>(context, listen: false);
      final formData = scoreProvider.formData;
      woNoController.text = formData['W.O. No.'] ?? '';
      nameOfWorkController.text = formData['Name of Work'] ?? '';
      nameOfContractorController.text = formData['Name of Contractor'] ?? '';
      nameOfSupervisorController.text = formData['Name of Supervisor'] ?? '';
      designationController.text = formData['Designation'] ?? '';
      trainNoController.text = formData['Train No.'] ?? '';
      arrivalTimeController.text = formData['Arrival Time'] ?? '';
      departureTimeController.text = formData['Departure Time'] ?? '';
      coachesAttendedController.text = formData['Coaches Attended'] ?? '';
      totalCoachesController.text = formData['Total Coaches'] ?? '';
      totalScoreController.text = formData['Total Score Obtained (%)'] ?? '';
      inaccessibleAreasController.text = formData['Inaccessible Areas Count'] ?? '';
      // Optionally restore inspectionDate if you save it as a string
      setState(() {});
    });
    Provider.of<ScoreProvider>(context, listen: false).restoreFromPrefs();
setupConnectivityListener();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scoreProvider = Provider.of<ScoreProvider>(context);
    bool allCoachFormsFilled() {
      final coachList = List.generate(13, (index) => 'C${index + 1}');
      final areaList = ['T1', 'T2', 'T3', 'T4', 'D1', 'D2', 'B1', 'B2'];
      for (final coach in coachList) {
        final review = scoreProvider.getCoachReview(coach);
        final scores = review['scores'] as Map<String, int>;
        if (scores.length != areaList.length ||
            scores.values.any((v) => v == null)) {
          return false;
        }
      }
      return true;
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        // Animate gradient stops for a liquid effect
        final t = _animationController.value;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.lerp(const Color(0xFFe0eafc), const Color(0xFFcfdef3), t)!,
                Color.lerp(const Color(0xFFcfdef3), const Color(0xFFf9fafc), t)!,
                Color.lerp(const Color(0xFFf9fafc), const Color(0xFFe3e6f3), t)!,
                Color.lerp(const Color(0xFFe3e6f3), const Color(0xFFe0eafc), t)!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                0.0,
                0.4 + 0.1 * t,
                0.7 - 0.1 * t,
                1.0,
              ],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.train, color: Colors.blue[700], size: 28),
                  const SizedBox(width: 8),
                  Text(
                    'SCORE CARD',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8), // Less padding
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18), // Less border radius
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16), // Less blur
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.50),
                            Colors.white.withOpacity(0.18),
                            Colors.blue[50]!.withOpacity(0.10),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          width: 1.2,
                          color: Colors.white.withOpacity(0.25),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey.withOpacity(0.08),
                            blurRadius: 18,
                            spreadRadius: 1,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8), // Less padding
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildTextField('W.O. No.', woNoController),
                            _buildDatePicker(),
                            _buildTextField('Name of Work', nameOfWorkController),
                            _buildTextField('Name of Contractor', nameOfContractorController),
                            _buildTextField('Name of Supervisor', nameOfSupervisorController),
                            _buildTextField('Designation', designationController),
                            _buildTextField('Train No.', trainNoController),
                            _buildTimePickerField('Arrival Time', arrivalTimeController),
                            _buildTimePickerField('Departure Time', departureTimeController),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    'Coaches Attended',
                                    coachesAttendedController,
                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextField(
                                    'Total Coaches',
                                    totalCoachesController,
                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Card(
                              elevation: 0,
                              color: Colors.white.withOpacity(0.18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                                side: BorderSide(
                                  color: Colors.blue[100]!.withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '📊 Summary',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue[700],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    _buildTextField('Total Score Obtained (%)', totalScoreController),
                                    _buildTextField('Inaccessible Areas Count', inaccessibleAreasController),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                      
                            if (allCoachFormsFilled()) ...[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20, top: 4),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        icon: Icon(Icons.edit, color: Colors.blue[700]),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white.withOpacity(0.7),
                                          foregroundColor: Colors.blue[700],
                                          elevation: 0,
                                          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), // Increased horizontal padding
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TrainCoachFormScreen(),
                                            ),
                                          );
                                        },
                                        label: Text('Edit Coach Forms'),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        icon: Icon(Icons.visibility, color: Colors.white),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue[700],
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), // Increased horizontal padding
                                        ),
                                        onPressed: () {
                                          if (_formKey.currentState!.validate()) {
                                            final formData = {
                                              'W.O. No.': woNoController.text,
                                              'Date of Inspection': inspectionDate != null
                                                  ? '${inspectionDate!.day}/${inspectionDate!.month}/${inspectionDate!.year}'
                                                  : '',
                                              'Name of Work': nameOfWorkController.text,
                                              'Name of Contractor': nameOfContractorController.text,
                                              'Name of Supervisor': nameOfSupervisorController.text,
                                              'Designation': designationController.text,
                                              'Train No.': trainNoController.text,
                                              'Arrival Time': arrivalTimeController.text,
                                              'Departure Time': departureTimeController.text,
                                              'Coaches Attended': coachesAttendedController.text,
                                              'Total Coaches': totalCoachesController.text,
                                              'Total Score Obtained (%)': totalScoreController.text,
                                              'Inaccessible Areas Count': inaccessibleAreasController.text,
                                            };
                                            if (formData.values.any((v) => v == null || v.toString().isEmpty)) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Please fill all fields before submitting.')),
                                              );
                                              return;
                                            }
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ScoreCardPreviewPage(
                                                  formData: formData,
                                                  onSubmit: () {
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text('Form submitted!')),
                                                    );
                                                  },
                                                ),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Please fill all required fields.')),
                                            );
                                          }
                                        },
                                        label: Text('Preview & Submit'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ] else ...[
                            Padding(
                              padding:  EdgeInsets.only(bottom: 20),
                              child: SizedBox(
                                  width: double.infinity, // Makes the button as wide as possible
                                  child: ElevatedButton.icon(
                                    icon: Icon(Icons.train, color: Colors.blue[700]),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white.withOpacity(0.7),
                                      foregroundColor: Colors.blue[700],
                                      elevation: 0,
                                      textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 18), // Taller for easier tap
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TrainCoachFormScreen(),
                                        ),
                                      );
                                    },
                                    label: Text('Next'),
                                  ),
                                ),
                            ),

],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

 Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(fontSize: 16, color: Colors.blue[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[100]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
        ),
        fillColor: Colors.white.withOpacity(0.5),
        filled: true,
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Required field' : null,
      onChanged: (_) {
        _saveFormToProvider();
      },
    ),
  );
}
  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime(2030),
          );
          if (picked != null) {
            setState(() => inspectionDate = picked);
              _saveFormToProvider();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue[100]!),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white.withOpacity(0.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.blue[700]),
                  const SizedBox(width: 8),
                  Text(
                    inspectionDate == null
                        ? 'Select Date'
                        : '${inspectionDate!.day}/${inspectionDate!.month}/${inspectionDate!.year}',
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.blue[700]),
                  ),
                ],
              ),
              Icon(Icons.arrow_drop_down, color: Colors.blue[700]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimePickerField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: () async {
          final picked = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (picked != null) {
            controller.text = picked.format(context);
              _saveFormToProvider();
            setState(() {});
          }
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: GoogleFonts.poppins(fontSize: 16, color: Colors.blue[700]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue[100]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
              ),
              suffixIcon: Icon(Icons.access_time, color: Colors.blue[700]),
              fillColor: Colors.white.withOpacity(0.5),
              filled: true,
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Required field' : null,
          ),
        ),
      ),
    );
  }
  
void _saveFormToProvider() {
  final scoreProvider = Provider.of<ScoreProvider>(context, listen: false);
  scoreProvider.saveFormData({
    'W.O. No.': woNoController.text,
    'Date of Inspection': inspectionDate != null
        ? '${inspectionDate!.day}/${inspectionDate!.month}/${inspectionDate!.year}'
        : '',
    'Name of Work': nameOfWorkController.text,
    'Name of Contractor': nameOfContractorController.text,
    'Name of Supervisor': nameOfSupervisorController.text,
    'Designation': designationController.text,
    'Train No.': trainNoController.text,
    'Arrival Time': arrivalTimeController.text,
    'Departure Time': departureTimeController.text,
    'Coaches Attended': coachesAttendedController.text,
    'Total Coaches': totalCoachesController.text,
    'Total Score Obtained (%)': totalScoreController.text,
    'Inaccessible Areas Count': inaccessibleAreasController.text,
  });
}
}
