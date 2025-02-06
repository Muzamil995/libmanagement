import 'dart:math'; // Import Random package
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengesListScreen extends StatefulWidget {
  @override
  _ChallengesListScreenState createState() => _ChallengesListScreenState();
}

class _ChallengesListScreenState extends State<ChallengesListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Random _random = Random();  

   
  final List<Map<String, String>> challenges = [
    {"title": "30-Day Running", "description": "Run every day for 30 minutes."},
    {"title": "Push-up Challenge", "description": "Increase push-ups daily."},
    {"title": "Plank Challenge", "description": "Hold a plank for longer each day."},
    {"title": "Yoga Challenge", "description": "Practice yoga for 15 minutes daily."},
  ];

   Future<void> joinChallenge(String title, String description) async {
    try {
      double randomProgress = _random.nextDouble(); 

      await _firestore.collection("joined_challenges").add({
        "title": title,
        "description": description,
        "progress": randomProgress,  
        "timestamp": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Joined: $title with ${(randomProgress * 100).toInt()}% progress")),
      );

       Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context, title);
      });
    } catch (e) {
      print("Error joining challenge: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         backgroundColor: Color(0xff396877),
      appBar: AppBar(title: Text("Available Challenges",style:TextStyle(
        color:Color(0xffd0ecfa),)),
         backgroundColor: Color(0xff396877),),
      body: ListView.builder(
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          final challenge = challenges[index];
          return Card(
            child: ListTile(
              tileColor: Color(0xffd0ecfa),
              title: Text(challenge["title"]!),
              subtitle: Text(challenge["description"]!),
              trailing: ElevatedButton(
                onPressed: () => joinChallenge(challenge["title"]!, challenge["description"]!),
                child: Text("Join"),
              ),
            ),
          );
        },
      ),
    );
  }
}
