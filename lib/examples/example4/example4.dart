import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const names = [
  'Mahmoud Atef',
  'Hager Belal',
  'Eman Atef',
  'Ahmed Selemon',
  'Hadeer Seleman',
];

final tickerProvider = StreamProvider(
  (ref) => Stream.periodic(
    const Duration(seconds: 1),
    (i) => i + 1,
  ),
);

final namesProvider = StreamProvider(
  (ref) => ref.watch(tickerProvider.stream).map(
    (count) {
      return names.getRange(0, count);
    },
  ),
);

class ExampleFour extends ConsumerWidget {
  const ExampleFour({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(namesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: names.when(
        data: (names) {
          return ListView.builder(
            itemCount: names.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(names.elementAt(index)),
              );
            },
          );
        },
        error: (error, stackTrace) => const Text('Reach the end of the list'),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
