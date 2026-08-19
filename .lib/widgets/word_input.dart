import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../providers/game_provider.dart';
import './widgets/word_input.dart';
import './widgets/word_input.dart';

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

class _WordInputState extends State<WordInput> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasError = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && widget.enabled) {
      widget.onSubmit(text);
      final provider = context.read<GameProvider>();
      if (provider.status != GameStatus.correct) {
        _controller.clear();
        _shakeAnimation();
      } else {
        _controller.clear();
      }
    }
  }

  void _shakeAnimation() {
    setState(() => _hasError = true);
    _shakeController.forward(from: 0).then((_) {
      if (mounted) setState(() => _hasError = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final isIncorrect = provider.status == GameStatus.incorrect;
    final isCorrect = provider.status == GameStatus.correct;

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        final shakeOffset = _hasError
            ? (10 * (1 - _shakeAnimation.value) * 
                (1 - (_shakeAnimation.value * 2).abs())).roundToDouble()
            : 0.0;

        return Transform.translate(
          offset: Offset(shakeOffset, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isIncorrect
                          ? Colors.red.withOpacity(0.3)
                          : isCorrect
                              ? Colors.green.withOpacity(0.3)
                              : Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      blurRadius: isIncorrect || isCorrect ? 20 : 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled && !isCorrect,
                  textCapitalization: TextCapitalization.characters,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    letterSpacing: 4,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: 'GUESS THE WORD',
                    hintStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      letterSpacing: 4,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: isIncorrect
                            ? Colors.red
                            : isCorrect
                                ? Colors.green
                                : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 3,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.green.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    suffixIcon: widget.enabled && !isCorrect
                        ? IconButton(
                            icon: Icon(
                              Icons.send_rounded,
                              color: Theme.of(context).colorScheme.primary,
                              size: 28,
                            ),
                            onPressed: _handleSubmit,
                            tooltip: 'Submit',
                          )
                        : isCorrect
                            ? Icon(
                                Icons.check_circle_rounded,
                                color: Colors.green,
                                size: 28,
                              )
                            : null,
                  ),
                  onSubmitted: (_) => _handleSubmit(),
                  onChanged: (value) {
                    if (_hasError) {
                      setState(() => _hasError = false);
                    }
                  },
                ),
              ),
              if (isIncorrect) ...[
                const SizedBox(height: 12),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.close_rounded,
                        color: Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Incorrect! Try again',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (isCorrect) ...[
                const SizedBox(height: 12),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        provider.feedbackMessage,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
===END FILE===