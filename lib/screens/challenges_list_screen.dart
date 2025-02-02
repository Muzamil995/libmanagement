import 'dart:math'; // Import Random package
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengesListScreen extends StatefulWidget {
  @override
  _ChallengesListScreenState createState() => _ChallengesListScreenState();
}

class _ChallengesListScreenState extends State<ChallengesListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Random _random = Random(); // Instance of Random

  // Sample List of Available Challenges
  final List<Map<String, String>> challenges = [
    {"title": "30-Day Running", "description": "Run every day for 30 minutes."},
    {"title": "Push-up Challenge", "description": "Increase push-ups daily."},
    {"title": "Plank Challenge", "description": "Hold a plank for longer each day."},
    {"title": "Yoga Challenge", "description": "Practice yoga for 15 minutes daily."},
  ];

  // Function to Join a Challenge and Store in Firebase with Random Progress
  Future<void> joinChallenge(String title, String description) async {
    try {
      double randomProgress = _random.nextDouble(); // Generate random progress (0.0 - 1.0)

      await _firestore.collection("joined_challenges").add({
        "title": title,
        "description": description,
        "progress": randomProgress, // Send Random Progress
        "timestamp": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Joined: $title with ${(randomProgress * 100).toInt()}% progress")),
      );

      // Navigate back with the selected challenge
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
      appBar: AppBar(title: Text("Available Challenges")),
      body: ListView.builder(
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          final challenge = challenges[index];
          return Card(
            child: ListTile(
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
