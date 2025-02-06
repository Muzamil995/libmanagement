import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './challenge_detail_screen.dart';
import './challenges_list_screen.dart';





class HomeScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Random _random = Random();


  Stream<List<String>> fetchMotivationalQuotes() {
    return _firestore.collection("motivational_quotes").snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc["quote"] as String).toList(),
    );
  }


  Stream<List<Map<String, dynamic>>> fetchJoinedChallenges() {
    return _firestore.collection("joined_challenges").snapshots().map(
          (snapshot) => snapshot.docs.map((doc) {
        return {
          "id": doc.id,
          "title": doc["title"],
          "progress": doc["progress"],
        };
      }).toList(),
    );
  }


  Future<void> joinChallenge(String title, String description,BuildContext context) async {
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
      appBar: AppBar(title: Text("Fitness Dashboard",
          style:TextStyle(
        color:Color(0xffd0ecfa),
      )),
          centerTitle: true,
          backgroundColor: Color(0xff396877),),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            StreamBuilder<List<String>>(
              stream: fetchMotivationalQuotes(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final quotes = snapshot.data!;
                final randomQuote = quotes.isNotEmpty ? quotes[Random().nextInt(quotes.length)] : "Stay motivated!";
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xff4c1edb),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    randomQuote,
                    style: TextStyle(fontSize: 18, color: Color(0xffd0ecfa)),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
            SizedBox(height: 20),


            Text("Your Challenges", style: TextStyle(fontSize: 20,
                color:Color(0xffd0ecfa),
                fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: fetchJoinedChallenges(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                  final activeChallenges = snapshot.data!;

                  if (activeChallenges.isEmpty) {
                    return Center(child: Text("No active challenges"));
                  }

                  return ListView.builder(
                    itemCount: activeChallenges.length,
                    itemBuilder: (context, index) {
                      final challenge = activeChallenges[index];
                      return Card(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  ChallengeDetailScreen(
                                  challengeTitle: challenge["title"],
                                  totalDays: 30,
                                  progress: challenge["progress"],
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            tileColor: Color(0xffd0ecfa),
                            title: Text(challenge["title"],style: TextStyle(
                              color: Color(0xff7a296f)
                            ),),
                            subtitle: LinearProgressIndicator(
                              value: challenge["progress"] / 100,
                              backgroundColor: Colors.grey[300],
                              color: Colors.blue,
                            ),
                            trailing: Text("${challenge["progress"].toStringAsFixed(3)}%"),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            SizedBox(height: 10),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                ElevatedButton(

                  onPressed: () async {
                    final selectedChallenge = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChallengesListScreen()),
                    );
                    if (selectedChallenge != null) {
                      print("User joined: $selectedChallenge");
                    }
                  },
                  child: Text("Join a New Challenge",style: TextStyle(
                    color: Colors.black)
                  ),),
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}
