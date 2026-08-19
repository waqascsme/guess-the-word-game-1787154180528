import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../providers/game_provider.dart';
import '../widgets/word_input.dart';
import '../widgets/word_input.dart';

class WordInput extends StatefulWidget {
  final void Function(String) onSubmit;
  final bool enabled;

  const WordInput({
    super.key,
    required this.onSubmit,
    required this.enabled,
  });

  @override
  State<WordInput> createState() => _WordInputState();
}

class _WordInputState extends State<WordInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasError = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && widget.enabled) {
      widget.onSubmit(text);
      if (context.read<GameProvider>().status != GameStatus.correct) {
        _controller.clear();
        _shakeAnimation();
      } else {
        _controller.clear();
      }
    }
  }

  void _shakeAnimation() {
    setState(() => _hasError = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _hasError = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final isIncorrect = provider.status == GameStatus.incorrect;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      transform: _hasError
          ? Matrix4.translationValues(
              (DateTime.now().millisecondsSinceEpoch % 20 - 10) * 0.5, 0, 0)
          : Matrix4.identity(),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            textCapitalization: TextCapitalization.words,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              letterSpacing: 4,
            ),
            decoration: InputDecoration(
              hintText: 'TYPE YOUR GUESS',
              hintStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                letterSpacing: 4,
                color: Colors.grey.shade400,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
              ),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.grey.shade500,
                      ),
                      onPressed: () {
                        _controller.clear();
                        setState(() {});
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: isIncorrect
                  ? Colors.red.shade50
                  : Theme.of(context).colorScheme.surface,
            ),
            onSubmitted: (_) => _handleSubmit(),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.enabled ? _handleSubmit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: widget.enabled ? 4 : 0,
                shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              ),
              child: const Text(
                'SUBMIT GUESS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}