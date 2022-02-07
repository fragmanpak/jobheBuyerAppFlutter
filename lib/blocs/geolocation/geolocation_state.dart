import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

abstract class GeolocationState extends Equatable {
  const GeolocationState();

  @override
  List<Object> get props => [];
}

class GeolocationLoading extends GeolocationState {}

class GeolocationLoaded extends GeolocationState {
  final Position position;

  GeolocationLoaded({this.position});

  @override
  List<Object> get props => [position];
}

class GeolocationError extends GeolocationState {}
