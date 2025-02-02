import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ChallengeDetailScreen extends StatefulWidget {
  final String challengeTitle;
  final int totalDays;
  double progress; // Make progress mutable so it updates

  ChallengeDetailScreen({
    required this.challengeTitle,
    required this.totalDays,
    required this.progress,
  });

  @override
  _ChallengeDetailScreenState createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  late List<bool> dailyProgress; // Stores checkboxes states
  late double progressPerDay; // How much each day contributes to 100%

  @override
  void initState() {
    super.initState();
    progressPerDay = 100 / widget.totalDays; // Each day contributes this much progress
    dailyProgress = List.filled(widget.totalDays, false);
    _initializeProgress(); // Setup checked days based on initial progress
  }

  // **Pre-check days based on progress from Home Screen**
  void _initializeProgress() {
    int completedDays = (widget.progress / progressPerDay).toInt(); // Find how many days should be checked
    for (int i = 0; i < completedDays; i++) {
      dailyProgress[i] = true;
    }
  }

  // **Update progress when a checkbox is clicked**
  void toggleDayCompletion(int index) {
    setState(() {
      dailyProgress[index] = !dailyProgress[index]; // Toggle checkbox

      int completedDays = dailyProgress.where((day) => day).length; // Count checked days
      widget.progress = completedDays * progressPerDay; // Update progress bar
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.challengeTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // **Challenge Title**
            Text(widget.challengeTitle, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),

            // **Circular Progress Indicator**
            Center(
              child: CircularPercentIndicator(
                radius: 80.0,
                lineWidth: 10.0,
                percent: widget.progress / 100, // Use progress value
                center: Text("${widget.progress.toInt()}%"),
                progressColor: Colors.blue,
                backgroundColor: Colors.grey[300]!,
                animation: true,
                animationDuration: 500,
              ),
            ),
            SizedBox(height: 20),

            // **Daily Progress Checklist**
            Expanded(
              child: ListView.builder(
                itemCount: widget.totalDays,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text("Day ${index + 1}"),
                    value: dailyProgress[index],
                    onChanged: (bool? value) {
                      toggleDayCompletion(index); // Toggle checkbox & update progress
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}