import 'package:flutter/material.dart';
import '../utils/app_texts.dart';
import '../utils/app_styles.dart';

class PhysicalCardWidget extends StatefulWidget {
  final String language;
  final String cardNameKey;
  final String questionKey;
  final String optAKey;
  final String optBKey;
  final int correctIndex; // 0:A, 1:B
  final VoidCallback onCorrect;

  const PhysicalCardWidget({
    super.key,
    required this.language,
    required this.cardNameKey,
    required this.questionKey,
    required this.optAKey,
    required this.optBKey,
    required this.correctIndex,
    required this.onCorrect,
  });

  @override
  State<PhysicalCardWidget> createState() => _PhysicalCardWidgetState();
}

class _PhysicalCardWidgetState extends State<PhysicalCardWidget> {
  bool _showQuestion = false;

  void _handleOption(int index) {
    if (index == widget.correctIndex) {
      widget.onCorrect();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppTexts.get('card_wrong', widget.language)),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: AppStyles.neonBox(color: Colors.amberAccent),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.style, color: Colors.amberAccent, size: 50),
            const SizedBox(height: 15),
            Text(
              AppTexts.get('card_alert_title', widget.language),
              style: AppStyles.titleStyle(Colors.amberAccent),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            if (!_showQuestion) ...[
              Text(
                AppTexts.get('card_alert_desc', widget.language),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  AppTexts.get(widget.cardNameKey, widget.language),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent,
                    foregroundColor: Colors.black),
                onPressed: () => setState(() => _showQuestion = true),
                child: Text(AppTexts.get('card_btn_read', widget.language)),
              ),
            ] else ...[
              Text(
                AppTexts.get(widget.questionKey, widget.language),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _optionBtn(0, widget.optAKey)),
                  const SizedBox(width: 10),
                  Expanded(child: _optionBtn(1, widget.optBKey)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _optionBtn(int index, String textKey) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.amberAccent),
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      onPressed: () => _handleOption(index),
      child: Text(AppTexts.get(textKey, widget.language), textAlign: TextAlign.center),
    );
  }
}