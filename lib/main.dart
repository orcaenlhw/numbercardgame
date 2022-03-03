import 'package:flutter/material.dart';
import 'package:numbercardgame/components/image_btn.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Choose the Number',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: SelectNumber(),
    );
  }
}

class SelectNumber extends StatefulWidget {
  SelectNumber({Key? key}) : super(key: key);

  @override
  State<SelectNumber> createState() => _SelectNumberState();
}

class _SelectNumberState extends State<SelectNumber> {
  List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  int correctAnswer = 0;
  int score = 0;
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    loadScore();
  }

  saveScore(int newScore) async {
    // obtain shared preferences
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      await prefs?.setInt("score", newScore);
    }
  }

  loadScore() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      var myscore = prefs?.getInt("score");
      if (myscore != null) {
        setState(() {
          score = myscore;
        });
      }
    }
  }

  Widget imageList(List<int> images) => Column(
      children: images
          .map((val) => ImageButton(
              correctAnswer: correctAnswer,
              val: val,
              onTap: (ans) {
                setState(() {
                  score += ans;
                  saveScore(score);
                });
              }))
          .toList());

  @override
  Widget build(BuildContext context) {
    numbers.shuffle();
    List<int> images = numbers.sublist(0, 3);
    correctAnswer = images[0];
    images.shuffle();

    return Scaffold(
      appBar: AppBar(title: const Text("Select Number")),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
      ),
    )
  }
}
