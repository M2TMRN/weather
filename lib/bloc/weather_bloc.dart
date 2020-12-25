import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_weather_bloc_app/bloc/bloc.dart';
import 'package:my_weather_bloc_app/data/weather_repository.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository repository;

  WeatherBloc(this.repository) : super(WeatherInitial());

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    yield WeatherLoading();

    if (event is GetWeather) {
      try{
        final weather = await repository.fetchWeather(event.cityName);
        yield WeatherLoaded(weather);
      } on NetworkError {
        yield WeatherError("Could not fetch weather. Is the device online?");
      }
      
    } else if (event is GetDetailedWeather) {
      try{
        final weather = await repository.fetchDetailedWeather(event.cityName);
        yield WeatherLoaded(weather);
      } on NetworkError {
        yield WeatherError("Could not fetch weather. Is the device online?");
      }
    }
  }
}
