import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final outputController = TextEditingController();
  final translator = GoogleTranslator();

  String inputText = '';
  String inputLanguage = 'en';
  String outputLanguage = 'ko';

  Future<void> translateText() async {
    final translated = await translator.translate(inputText,
        from: inputLanguage, to: outputLanguage);

    setState(() {
      outputController.text = translated.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '텍스트 번역',
                ),
                onChanged: (value) {
                  setState(() {
                    inputText = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                DropdownButton<String>(
                    value: inputLanguage,
                    onChanged: (newValue) {
                      setState(() {
                        inputLanguage = newValue!;
                      });
                    },
                    items: <String>['ko', 'en', 'fr', 'ja']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()),
                const Icon(Icons.arrow_forward_rounded),
                DropdownButton<String>(
                    value: outputLanguage,
                    onChanged: (newValue) {
                      setState(() {
                        outputLanguage = newValue!;
                      });
                    },
                    items: <String>['ko', 'en', 'fr', 'ja']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList())
              ]),
              const SizedBox(height: 16),
              ElevatedButton(
                  onPressed: translateText,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(55)),
                  child: const Text('번역')),
              const SizedBox(height: 30),
              TextField(
                controller: outputController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '텍스트 번역',
                ),
                onChanged: (value) {
                  setState(() {
                    inputText = value;
                  });
                },
              )
            ],
          ),
        ),
      )),
    );
  }
}
