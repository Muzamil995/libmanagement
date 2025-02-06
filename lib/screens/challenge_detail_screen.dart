import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ChallengeDetailScreen extends StatefulWidget {
  final String challengeTitle;
  final int totalDays;
  double progress;  

  ChallengeDetailScreen({
    required this.challengeTitle,
    required this.totalDays,
    required this.progress,
  });

  @override
  _ChallengeDetailScreenState createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  late List<bool> dailyProgress; 
  late double progressPerDay;  

  @override
  void initState() {
    super.initState();
    progressPerDay = 100 / widget.totalDays;  
    dailyProgress = List.filled(widget.totalDays, false);
    _initializeProgress();  
  }

 
  void _initializeProgress() {
    int completedDays = (widget.progress / progressPerDay).toInt();  
    for (int i = 0; i < completedDays; i++) {
      dailyProgress[i] = true;
    }
  }

  
  void toggleDayCompletion(int index) {
    setState(() {
      dailyProgress[index] = !dailyProgress[index];  

      int completedDays = dailyProgress.where((day) => day).length;  
      widget.progress = completedDays * progressPerDay;  
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Color(0xff396877),
      appBar: AppBar(title: Text(widget.challengeTitle,   style:TextStyle(
        color:Color(0xffd0ecfa),
      ),),
       backgroundColor: Color(0xff396877),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            Text(widget.challengeTitle, 
            style: TextStyle(fontSize: 22,
            color:Color(0xffd0ecfa),
             fontWeight: FontWeight.bold)),
            SizedBox(height: 20),

           
            Center(
              child: CircularPercentIndicator(
                radius: 80.0,
                lineWidth: 10.0,
                percent: widget.progress / 100,  
                center: Text("${widget.progress.toInt()}%",
                style: TextStyle(color:Color(0xffd0ecfa) ),),
                progressColor: Color(0xff7a296f),
                backgroundColor: Colors.grey[300]!,
                animation: true,
                animationDuration: 500,
              ),
            ),
            SizedBox(height: 20),

            
            Expanded(
              child: ListView.builder(
                itemCount: widget.totalDays,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text("Day ${index + 1}",
                    style: TextStyle(color:Color(0xffd0ecfa) ),),
                    value: dailyProgress[index],
                    activeColor: Color(0xff396877),
                    onChanged: (bool? value) {
                      toggleDayCompletion(index);  
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