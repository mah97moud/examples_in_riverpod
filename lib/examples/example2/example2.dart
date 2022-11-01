import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

extension OptionalInfixAddation<T extends num> on T? {
  T? operator +(T? other) {
    final shadow = this;

    if (shadow != null) {
      return shadow + (other ?? 0) as T;
    } else {
      return null;
    }
  }
}

extension OptionalInfixMins<T extends num> on T? {
  T? operator -(T? other) {
    final shadow = this;
    if (shadow != null) {
      return shadow - (other ?? 0) as T;
    } else {
      return null;
    }
  }
}

class Counter extends StateNotifier<int?> {
  Counter() : super(null);

  void increment() => state = state == null ? 1 : state + 1;
  void decrement() => state = state == null ? 1 : state - 1;
  void reset() => state = null;
}

final counterProvider = StateNotifierProvider<Counter, int?>(
  (ref) => Counter(),
);

class ExampleTwo extends ConsumerWidget {
  const ExampleTwo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer(
          builder: (_, ref, __) {
            final count = ref.watch(counterProvider);
            final text = count == null ? "press the counter" : count.toString();
            return Text(text);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            onPressed: ref.read(counterProvider.notifier).increment,
            child: const Text('Increment counter'),
          ),
          TextButton(
            onPressed: ref.read(counterProvider.notifier).decrement,
            child: const Text('Decrement counter'),
          ),
          TextButton(
            onPressed: ref.read(counterProvider.notifier).reset,
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
