import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Dadu Flutter 🎲',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: const DiceGamePage(),
    );
  }
}

class DiceGamePage extends StatefulWidget {
  const DiceGamePage({super.key});

  @override
  State<DiceGamePage> createState() => _DiceGamePageState();
}

class _DiceGamePageState extends State<DiceGamePage> {
  int step = 0; // 0 = jumlah pemain, 1 = input nama, 2 = main game
  int playerCount = 0;
  List<String> playerNames = [];
  List<TextEditingController> controllers = [];

  int diceLeft = 1;
  int diceRight = 1;
  int currentPlayerIndex = 0;

  final TextEditingController countController = TextEditingController();

  void nextStep() {
    if (step == 0) {
      final count = int.tryParse(countController.text);
      if (count != null && count > 0) {
        setState(() {
          playerCount = count;
          controllers = List.generate(count, (_) => TextEditingController());
          step = 1;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Masukkan jumlah pemain yang valid!')),
        );
      }
    } else if (step == 1) {
      final names = controllers
          .map((c) => c.text.trim())
          .where((n) => n.isNotEmpty)
          .toList();
      if (names.length == playerCount) {
        setState(() {
          playerNames = names;
          step = 2;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lengkapi semua nama pemain!')),
        );
      }
    }
  }

  void rollDice() {
    setState(() {
      diceLeft = Random().nextInt(6) + 1;
      diceRight = Random().nextInt(6) + 1;
      currentPlayerIndex = (currentPlayerIndex + 1) % playerNames.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game Dadu Flutter 🎲')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: step == 0
              ? buildPlayerCountInput()
              : step == 1
              ? buildPlayerNameInput()
              : buildDiceGame(),
        ),
      ),
    );
  }

  // STEP 0 - Input jumlah pemain
  Widget buildPlayerCountInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Berapa orang yang akan bermain?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: countController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Contoh: 3',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: const Icon(Icons.people),
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: nextStep,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Next', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }

  // STEP 1 - Input nama-nama pemain
  Widget buildPlayerNameInput() {
    return Column(
      children: [
        const Text(
          'Masukkan Nama Pemain',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: playerCount,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  controller: controllers[index],
                  decoration: InputDecoration(
                    labelText: 'Pemain ${index + 1}',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: nextStep,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Mulai Main 🎲', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }

  // STEP 2 - Game Dadu
  Widget buildDiceGame() {
    final currentPlayer = playerNames[currentPlayerIndex];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Giliran: $currentPlayer',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 30),
        Image.network(
          'https://e7.pngegg.com/pngimages/1015/998/png-clipart-white-and-blue-dice-world-of-goo-tic-tac-toe-video-game-computer-icons-board-games-icon-miscellaneous-game.png',
          height: 100,
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/dice$diceLeft.png', width: 120),
            const SizedBox(width: 30),
            Image.asset('assets/images/dice$diceRight.png', width: 120),
          ],
        ),
        const SizedBox(height: 30),
        Text(
          'Total: ${diceLeft + diceRight}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton.icon(
          onPressed: rollDice,
          icon: const Icon(Icons.casino),
          label: const Text('Kocok Dadu 🎲'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }
}
