import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.russoOneTextTheme(),
      ),
      home: const GamePage(),
    );
  }
}


class GamePage extends StatefulWidget{
  const GamePage({super.key});
  @override
  State createState() => _GamePageState();
}

class _GamePageState extends State {
  final diceList = [
    'images/d1.png',
    'images/d2.png',
    'images/d3.png',
    'images/d4.png',
    'images/d5.png',
    'images/d6.png',
  ];

  int index1 = 0, index2 = 0;int diceSum = 0,  target = 0;
  bool shouldShowBoard = false;
  final random = Random.secure();
  String result = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MEGAROLL'),
      ),
      body: Center(

        child: shouldShowBoard ?
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(diceList[index1],width: 100,height: 100,),
                  const SizedBox(width: 10,),
                  Image.asset(diceList[index2],width: 100,height: 100,),
                ],
              ),
              Text('Dice Sum: $diceSum',style: const TextStyle(fontSize: 22,height: 2),),
              if(target > 0)
                Text('Your target: $target\n keep rolling',style: const TextStyle(fontSize: 14,height: 2),),
              Text('$result',style: TextStyle(fontSize: 30),),
            ElevatedButton(onPressed: () => rollTheDice(), child: const Text('ROLL')),
            ElevatedButton(onPressed: () => reset(), child: const Text('RESET'))
          ],
        ) : CoverPage(onStart: StartGame,),
      ),
    );
  }

  rollTheDice() {
    setState(() {
      index1 = random.nextInt(6);
      index2 = random.nextInt(6);
      diceSum = index1+index2+2;
      if(target > 0){
        checkTarget();
      }else{
        checkFirstRoll();
      }

    });
  }

  void checkFirstRoll() {
    if(diceSum == 7 || diceSum == 11){
      result = 'You win';
    }else if(diceSum == 2 || diceSum == 3 || diceSum == 12){
      result = 'You Loose';
    }else{
      result = '';
      target = diceSum;
    }
  }

  reset() {
    setState(() {
      index1 = 0;
      index2 = 0;
      diceSum = 0;
      target = 0;
      result = '';
      shouldShowBoard = false;

    });
  }

  void checkTarget() {
    if(diceSum == target){
      result = 'You win';
    }else if(diceSum == 7){
      result = 'You lost';
    }
  }


  void StartGame() {
    setState(() {
      shouldShowBoard = true;
    });
  }
}



class CoverPage extends StatelessWidget {
  final VoidCallback onStart;

  const CoverPage({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return
      Center(
        child: Column(
          children: [
            Image.asset('images/dicelogo.png', width: 200, height: 200),
            RichText(text: TextSpan(
              text: 'MEGA',
              style: GoogleFonts.russoOne().copyWith(
                color: Colors.red,
                fontSize: 40,
              ),
            ),
            ),

            const Spacer(),
            DiceButton(label: 'START', onPressed: onStart,),
            SizedBox(width: double.infinity, height: 10,),
            DiceButton(label: 'HOW TO PLAY', onPressed: () => showInstruction(context),),
            SizedBox(width: double.infinity, height: 10,),
          ],
        ),
      );
  }
}



showInstruction(BuildContext context) {
  showDialog(context: context, builder: (context) => const AlertDialog(
    title: Text('INSTRUCTION'),
    content: Text(gameRules),
    actions: [
      TextButton(
          onPressed:null,
          child: Text('CLOSE')
      )
    ],

  ));
}



class DiceButton extends StatelessWidget {
  const DiceButton({super.key, required this.label, required this.onPressed});
  @override
  final String label;
  final VoidCallback onPressed;

  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label,style: const TextStyle(fontSize: 20,color: Colors.white),),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
        ),
      ),
    );
  }
}


const gameRules = '* AT THE FIRST ROLL, ''IF THE DICE SUM IS 7 OR 11, YOU WIN! '
    '* AT THE FIRST ROLL, IF THE DICE SUM IS 2, 3 OR 12, YOU LOST!! '
    '* AT THE FIRST ROLL, IF THE DICE SUM IS 4, 5, 6, 8, 9, 10, THEN THIS DICE SUM * IF THE DICE SUM MATCHES YOUR TARGET POINT, YOU WIN! * IF THE DICE SUM IS 7, YOU LOST!!';




