import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum City {
  newYork,
  london,
  paris,
  stPetersburg,
  rome,
  stockholm,
  warsaw,
}

typedef WeatherEmoji = String;

Future<WeatherEmoji> getWeather(City city) {
  return Future.delayed(
    const Duration(seconds: 1),
    () =>
        {
          City.newYork: '❄',
          City.london: '🌞',
          City.paris: '🌧',
        }[city] ??
        '💨',
  );
}

final currentCityProvider = StateProvider<City?>(
  (ref) => null,
);

const unknownEmoji = '🤷‍♂️';

final weatherProvider = FutureProvider<WeatherEmoji>(
  (ref) async {
    //need to listen fro currentCityProvider
    final city = ref.watch(currentCityProvider);
    if (city != null) {
      return getWeather(city);
    }
    return unknownEmoji;
  },
);

class ExampleThree extends ConsumerWidget {
  const ExampleThree({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(
      weatherProvider,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: Column(
        children: [
          currentWeather.when(
            data: (data) => Text(
              data,
              style: const TextStyle(fontSize: 40),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
            error: (error, stackTrace) => Text(error.toString()),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: City.values.length,
              itemBuilder: ((context, index) {
                final city = City.values[index];
                final isSelected = city == ref.watch(currentCityProvider);

                return ListTile(
                  title: Text(city.name),
                  trailing: isSelected ? const Icon(Icons.check) : null,
                  onTap: () => ref
                      .read(
                        currentCityProvider.notifier,
                      )
                      .state = city,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
