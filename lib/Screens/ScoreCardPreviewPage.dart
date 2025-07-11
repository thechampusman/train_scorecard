import 'dart:ui';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:untitled5/Services/offline_submission.dart';

import '../Provider/ScoreProvider.dart';

class ScoreCardPreviewPage extends StatelessWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onSubmit;

  const ScoreCardPreviewPage({
    Key? key,
    required this.formData,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scoreProvider = Provider.of<ScoreProvider>(context, listen: false);
    final coachList = List.generate(13, (index) => 'C${index + 1}');
    final areaList = ['T1', 'T2', 'T3', 'T4', 'D1', 'D2', 'B1', 'B2'];

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(seconds: 8),
      curve: Curves.easeInOut,
      builder: (context, t, child) {
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
              title: Text('Preview Score Card', style: GoogleFonts.poppins()),
              centerTitle: true,
            ),
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Section 1: Main Form Data Table
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Table(
                        columnWidths: const {
                          0: IntrinsicColumnWidth(),
                          1: FlexColumnWidth(),
                        },
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        children: formData.entries.map((entry) {
                          return TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: Text(
                                  entry.key,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: Colors.blueGrey[800],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: Text(
                                  entry.value?.toString() ?? '',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.blueGrey[900],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Section 2: Coach Scores Matrix Table
                    Text(
                      'Coach Scores',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(Colors.blue[50]?.withOpacity(0.3)),
                        dataRowMinHeight: 28,
                        headingRowHeight: 32,
                        columnSpacing: 16,
                        horizontalMargin: 8,
                        columns: [
                          const DataColumn(
                            label: Text('Area', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          ),
                          ...coachList.map((coach) => DataColumn(
                                label: Text(coach, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                              )),
                        ],
                        rows: areaList.map((area) {
                          return DataRow(
                            cells: [
                              DataCell(Text(area, style: const TextStyle(fontSize: 12))),
                              ...coachList.map((coach) {
                                final review = scoreProvider.getCoachReview(coach);
                                final score = review['scores'][area]?.toString() ?? '-';
                                return DataCell(
                                  Text(
                                    score,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                );
                              }),
                            ],
                          );
                        }).toList(),
                      ),
                    ),

                    // Section 3: Remarks List
                    const SizedBox(height: 24),
                    Text(
                      'Remarks',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...coachList.expand((coach) {
                      final review = scoreProvider.getCoachReview(coach);
                      return areaList
                          .where((area) => (review['remarks'][area] ?? '').toString().trim().isNotEmpty)
                          .map((area) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.22),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                  child: RichText(
                                    text: TextSpan(
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.blueGrey[900],
                                      ),
                                      children: [
                                        TextSpan(
                                          text: '$coach - $area: ',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: review['remarks'][area],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                    }).toList(),

                    const SizedBox(height: 28),
                   ElevatedButton(

onPressed: () async {
  final scoreProvider = Provider.of<ScoreProvider>(context, listen: false);
  final coachList = List.generate(13, (index) => 'C${index + 1}');
  final areaList = ['T1', 'T2', 'T3', 'T4', 'D1', 'D2', 'B1', 'B2'];
  final coachData = {
    for (var coach in coachList)
      coach: {
        'scores': scoreProvider.getCoachReview(coach)['scores'],
        'remarks': scoreProvider.getCoachReview(coach)['remarks'],
      }
  };

  final submissionData = {
    'form': formData,
    'coaches': coachData,
  };

  final webhookUrl = 'https://webhook.site/5b2896ee-1ad2-453c-947b-95ab4ceaf68a';

  try {
    final response = await http.post(
      Uri.parse(webhookUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(submissionData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submitted to webhook.site!')),
      );
      Provider.of<ScoreProvider>(context, listen: false).clearSaved();
      onSubmit();
    } else {
      // Save for later upload
      await savePendingSubmission(submissionData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Offline: Will upload when online.')),
      );
    }
  } catch (e) {
    // Network error or offline: Save for later upload
    await savePendingSubmission(submissionData);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Offline: Will upload when online.')),
    );
  }
},  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue[700],
    foregroundColor: Colors.white,
    elevation: 0,
    textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),
    padding: const EdgeInsets.symmetric(vertical: 16),
  ),
  child: Text(
    'Submit',
    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
  ),
),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}