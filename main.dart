import 'package:flutter/material.dart';

void main() => runApp(const QuizApp());

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF1E5BD8),
      ),
      home: const QuizScreen(),
    );
  }
}

// ---------------------------------------------------------------------------
// Question data
// ---------------------------------------------------------------------------
class Question {
  final String text;
  final List<String> options;
  final int correctIndex;

  const Question({
    required this.text,
    required this.options,
    required this.correctIndex,
  });
}

const List<Question> questions = [
  Question(
    text: 'Which programming language is used to build Flutter apps?',
    options: ['Java', 'Dart', 'Kotlin', 'Swift'],
    correctIndex: 1,
  ),
  Question(
    text: 'Who developed Flutter?',
    options: ['Facebook', 'Microsoft', 'Google', 'Apple'],
    correctIndex: 2,
  ),
  Question(
    text: 'What is the entry point of a Dart application?',
    options: ['start()', 'run()', 'init()', 'main()'],
    correctIndex: 3,
  ),
  Question(
    text: 'Which widget is used to show a scrollable list of items?',
    options: ['ListView', 'Container', 'Stack', 'Row'],
    correctIndex: 0,
  ),
  Question(
    text: 'Which widget arranges its children vertically?',
    options: ['Row', 'Column', 'Stack', 'Wrap'],
    correctIndex: 1,
  ),
  Question(
    text: 'Which widget can change its appearance when its state changes?',
    options: [
      'StatelessWidget',
      'Text',
      'StatefulWidget',
      'Icon',
    ],
    correctIndex: 2,
  ),
  Question(
    text: 'Which method tells Flutter to rebuild the UI after a state change?',
    options: ['build()', 'setState()', 'update()', 'refresh()'],
    correctIndex: 1,
  ),
  Question(
    text: 'Which widget is commonly used to add empty space between widgets?',
    options: ['Divider', 'Padding only', 'SizedBox', 'Spacer text'],
    correctIndex: 2,
  ),
  Question(
    text: 'Which file lists the packages and assets of a Flutter project?',
    options: ['main.dart', 'pubspec.yaml', 'README.md', 'build.gradle'],
    correctIndex: 1,
  ),
  Question(
    text: 'Which widget provides the basic app layout with AppBar and body?',
    options: ['Scaffold', 'Card', 'Center', 'Expanded'],
    correctIndex: 0,
  ),
];

// ---------------------------------------------------------------------------
// Quiz screen
// ---------------------------------------------------------------------------
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedIndex; // null means not answered yet

  bool get _isAnswered => _selectedIndex != null;
  bool get _isLast => _currentIndex == questions.length - 1;

  void _selectOption(int index) {
    if (_isAnswered) return; // one answer per question
    setState(() {
      _selectedIndex = index;
      if (index == questions[_currentIndex].correctIndex) {
        _score++;
      }
    });
  }

  void _next() {
    if (_isLast) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ResultScreen(score: _score, total: questions.length),
        ),
      );
    } else {
      setState(() {
        _currentIndex++;
        _selectedIndex = null;
      });
    }
  }

  Color _optionColor(int index) {
    if (!_isAnswered) return Colors.white;
    if (index == questions[_currentIndex].correctIndex) {
      return Colors.green.shade100;
    }
    if (index == _selectedIndex) return Colors.red.shade100;
    return Colors.white;
  }

  IconData? _optionIcon(int index) {
    if (!_isAnswered) return null;
    if (index == questions[_currentIndex].correctIndex) {
      return Icons.check_circle;
    }
    if (index == _selectedIndex) return Icons.cancel;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[_currentIndex];
    final isCorrect = _selectedIndex == question.correctIndex;

    return Scaffold(
      backgroundColor: const Color(0xFFEAF0FB),
      appBar: AppBar(
        title: const Text('Quiz App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${_currentIndex + 1} of ${questions.length}',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (_currentIndex + 1) / questions.length,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 24),
            Text(
              question.text,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...List.generate(question.options.length, (index) {
              return Card(
                color: _optionColor(index),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(question.options[index]),
                  trailing: _optionIcon(index) == null
                      ? null
                      : Icon(
                          _optionIcon(index),
                          color: index == question.correctIndex
                              ? Colors.green
                              : Colors.red,
                        ),
                  onTap: () => _selectOption(index),
                ),
              );
            }),
            const SizedBox(height: 8),
            if (_isAnswered)
              Text(
                isCorrect
                    ? 'Correct! Well done.'
                    : 'Wrong! Correct answer: ${question.options[question.correctIndex]}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isCorrect ? Colors.green : Colors.red,
                ),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isAnswered ? _next : null,
                child: Text(_isLast ? 'See Results' : 'Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Results screen
// ---------------------------------------------------------------------------
class ResultScreen extends StatelessWidget {
  final int score;
  final int total;

  const ResultScreen({super.key, required this.score, required this.total});

  String get _message {
    final percent = score / total;
    if (percent >= 0.8) return 'Excellent work!';
    if (percent >= 0.5) return 'Good job, keep practising!';
    return 'Keep learning, you will do better next time!';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF0FB),
      appBar: AppBar(
        title: const Text('Results'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.emoji_events,
                    size: 72,
                    color: Color(0xFF1E5BD8),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Quiz Completed',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$score / $total',
                    style: const TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuizScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Restart Quiz'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
