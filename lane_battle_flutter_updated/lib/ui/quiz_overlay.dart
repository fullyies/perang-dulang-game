import 'package:flutter/material.dart';
import '../game/battle_game.dart';

class QuizOverlay extends StatefulWidget {
  final BattleGame game;
  const QuizOverlay({super.key, required this.game});

  @override
  State<QuizOverlay> createState() => _QuizOverlayState();
}

class _QuizOverlayState extends State<QuizOverlay> {
  int correctAnswers = 0;
  int currentQuestion = 0;

  final Map<int, List<Map<String, dynamic>>> stageQuizzes = {
    1: [
      {
        'q': 'Ibukota Indonesia adalah?',
        'options': ['Jakarta', 'Bandung', 'Surabaya', 'Medan'],
        'answer': 'Jakarta',
      },
      {
        'q': 'Planet terbesar di tata surya?',
        'options': ['Bumi', 'Mars', 'Jupiter', 'Saturnus'],
        'answer': 'Jupiter',
      },
      {
        'q': 'Gunung tertinggi di dunia?',
        'options': ['Kilimanjaro', 'Everest', 'Fuji', 'Andes'],
        'answer': 'Everest',
      },
      {
        'q': 'Lambang unsur kimia O adalah?',
        'options': ['Oksigen', 'Osmium', 'Oganesson', 'Oksida'],
        'answer': 'Oksigen',
      },
      {
        'q': 'Benua terbesar di dunia?',
        'options': ['Afrika', 'Asia', 'Amerika', 'Australia'],
        'answer': 'Asia',
      },
    ],
    2: [
      {
        'q': 'Hewan tercepat di darat?',
        'options': ['Kuda', 'Cheetah', 'Harimau', 'Rusa'],
        'answer': 'Cheetah',
      },
      {
        'q': 'Negara dengan populasi terbanyak?',
        'options': ['India', 'China', 'Amerika', 'Indonesia'],
        'answer': 'China',
      },
      {
        'q': 'Laut terluas di dunia?',
        'options': ['Atlantik', 'Pasifik', 'Hindia', 'Arktik'],
        'answer': 'Pasifik',
      },
      {
        'q': 'Penemu lampu pijar?',
        'options': ['Newton', 'Einstein', 'Edison', 'Tesla'],
        'answer': 'Edison',
      },
      {
        'q': 'Ibukota Jepang?',
        'options': ['Tokyo', 'Kyoto', 'Osaka', 'Nagoya'],
        'answer': 'Tokyo',
      },
    ],
    3: [
      {
        'q': 'Unsur kimia dengan simbol Fe?',
        'options': ['Fluor', 'Fosfor', 'Ferum (Besi)', 'Francium'],
        'answer': 'Ferum (Besi)',
      },
      {
        'q': 'Gunung berapi aktif di Indonesia?',
        'options': ['Fuji', 'Merapi', 'Etna', 'Krakatau'],
        'answer': 'Merapi',
      },
      {
        'q': 'Sungai terpanjang di dunia?',
        'options': ['Nil', 'Amazon', 'Yangtze', 'Mississippi'],
        'answer': 'Nil',
      },
      {
        'q': 'Bahasa resmi PBB?',
        'options': ['Inggris', 'Spanyol', 'Arab', 'Semua benar'],
        'answer': 'Semua benar',
      },
      {
        'q': 'Planet terdekat dengan Matahari?',
        'options': ['Merkurius', 'Venus', 'Bumi', 'Mars'],
        'answer': 'Merkurius',
      },
    ],
  };

  late List<Map<String, dynamic>> questions;

  @override
  void initState() {
    super.initState();
    questions = stageQuizzes[widget.game.stage.value]!;
  }

  void checkAnswer(String selected) {
    final q = questions[currentQuestion];
    if (selected == q['answer'] as String) {
      correctAnswers++;
    }

    if (currentQuestion < questions.length - 1) {
      setState(() => currentQuestion++);
    } else {
      // selesai quiz → panggil finishQuiz
      finishQuiz();
    }
  }

  void finishQuiz() {
    widget.game.quizScoreTotal += correctAnswers;

   if (widget.game.quizScoreTotal > widget.game.highScore) {
  widget.game.highScore = widget.game.quizScoreTotal;
}



    if (widget.game.stage.value < 3) {
      widget.game.stage.value++;
      widget.game.resetBattleState();
      widget.game.resumeEngine();
      widget.game.overlays.remove('QuizStage');
      widget.game.overlays.add('Hud');
    } else {
      widget.game.overlays.remove('QuizStage');
      widget.game.overlays.add('Victory');
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[currentQuestion];
    final options = q['options'] as List<String>;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.black.withOpacity(0.7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Stage ${widget.game.stage.value} - Soal ${currentQuestion + 1}/${questions.length}',
              style: const TextStyle(color: Colors.yellow, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              q['q'] as String,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 12),
            ...options.map((opt) => ElevatedButton(
                  onPressed: () => checkAnswer(opt),
                  child: Text(opt),
                )),
          ],
        ),
      ),
    );
  }
}
// Overlay skor akhir 
class FinalScoreOverlay extends StatelessWidget { 
  final BattleGame game; const FinalScoreOverlay({super.key, required this.game}); 
  @override Widget build(BuildContext context) { 
    return Center( 
      child: Container( 
        padding: const EdgeInsets.all(20), 
        color: Colors.black.withOpacity(0.7), 
        child: Column( mainAxisSize: MainAxisSize.min, 
        children: [ const Text( 'Permainan Selesai!', 
        style: TextStyle(color: Colors.white, 
        fontSize: 22, 
        fontWeight: FontWeight.bold), 
        ), 
        const SizedBox(height: 12), 
        Text( 'Skor Pengetahuan: ${game.quizScoreTotal}', 
        style: const TextStyle(
          color: Colors.yellow, 
          fontSize: 18), ), 
          const SizedBox(height: 20), 
          ElevatedButton( onPressed: () { // restart game atau kembali ke menu
           game.overlays.remove('FinalScore'); 
           game.overlays.add('Victory'); }, 
           child: const Text('Kembali'), 
           ),
            ],
             ),
              ),
               );
                } 
                }