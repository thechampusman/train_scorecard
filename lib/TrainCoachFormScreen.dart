import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'Provider/ScoreProvider.dart';

class TrainCoachFormScreen extends StatefulWidget {
  const TrainCoachFormScreen({Key? key}) : super(key: key);

  @override
  State<TrainCoachFormScreen> createState() => _TrainCoachFormScreenState();
}

class _TrainCoachFormScreenState extends State<TrainCoachFormScreen> {
  int selectedCoachIndex = 0;
  final coachList = List.generate(13, (index) => 'C${index + 1}');

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        if (ModalRoute.of(context) is Listenable) ModalRoute.of(context) as Listenable,
      ]),
      builder: (context, child) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(seconds: 8),
          curve: Curves.easeInOut,
          builder: (context, t, _) {
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
                  title: Text(
                    'Coach Inspection',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800],
                      fontSize: 22,
                      letterSpacing: 1.2,
                    ),
                  ),
                  centerTitle: true,
                ),
                body: Column(
                  children: [
                    // Glassy Coach Selector
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8), // Less vertical space
                      child: SizedBox(
                        height: 44, // Less height
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: coachList.length,
                          itemBuilder: (context, index) {
                            final isSelected = selectedCoachIndex == index;
                            return GestureDetector(
                              onTap: () => setState(() => selectedCoachIndex = index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: const EdgeInsets.symmetric(horizontal: 4), // Less margin
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6), // Less padding
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white.withOpacity(0.38)
                                      : Colors.white.withOpacity(0.14),
                                  borderRadius: BorderRadius.circular(16), // Less radius
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.blueAccent.withOpacity(0.5)
                                        : Colors.blueGrey.withOpacity(0.08),
                                    width: 1.2,
                                  ),
                                  boxShadow: [
                                    if (isSelected)
                                      BoxShadow(
                                        color: Colors.blueAccent.withOpacity(0.10),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.train,
                                        size: 18,
                                        color: isSelected
                                            ? Colors.blueAccent
                                            : Colors.blueGrey[400]),
                                    const SizedBox(width: 4),
                                    Text(
                                      coachList[index],
                                      style: GoogleFonts.poppins(
                                        color: isSelected
                                            ? Colors.blueAccent
                                            : Colors.blueGrey[700],
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14, // Smaller font
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // Glassmorphic Coach Form
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        child: CoachForm(
                          coachNo: coachList[selectedCoachIndex],
                          key: ValueKey(coachList[selectedCoachIndex]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// --- CoachForm with glassmorphism card for each area ---
class CoachForm extends StatelessWidget {
  final String coachNo;
  const CoachForm({required this.coachNo, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scoreProvider = Provider.of<ScoreProvider>(context);
    final areaList = ['T1', 'T2', 'T3', 'T4', 'D1', 'D2', 'B1', 'B2'];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        key: PageStorageKey(coachNo),
        children: [
          Text(
            '🛠️ Inspection for Coach $coachNo',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.blueAccent[700],
            ),
          ),
          const SizedBox(height: 12),
          ...areaList.map(
            (area) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.38),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: Colors.blueAccent.withOpacity(0.18),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.07),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$area Score (0–10)',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.blueAccent[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          DropdownButtonFormField<int>(
                            value: scoreProvider.getCoachReview(coachNo)['scores'][area],
                            items: List.generate(
                              11,
                              (i) => DropdownMenuItem(
                                value: i,
                                child: Text(i.toString()),
                              ),
                            ),
                            onChanged: (val) {
                              if (val != null) {
                                scoreProvider.setScore(coachNo, area, val);
                              }
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                    color: Colors.blueAccent.withOpacity(0.18)),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            initialValue: scoreProvider.getCoachReview(coachNo)['remarks'][area],
                            decoration: InputDecoration(
                              labelText: 'Remarks for $area',
                              labelStyle: GoogleFonts.poppins(color: Colors.blueAccent[400]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                    color: Colors.blueAccent.withOpacity(0.18)),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.5),
                            ),
                            onChanged: (val) =>
                                scoreProvider.setRemarks(coachNo, area, val),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
