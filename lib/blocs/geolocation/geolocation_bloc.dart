import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jobheebuyer/blocs/geolocation/geolocation_event.dart';
import 'package:jobheebuyer/blocs/geolocation/geolocation_state.dart';
import 'package:jobheebuyer/repositories/geolocation/geolocation_repository.dart';

class GeolocationBloc extends Bloc<GeolocationEvent, GeolocationBloc> {
  final GeolocationRepository _geolocationRepository;
  StreamSubscription _streamSubscription;

  GeolocationBloc({GeolocationRepository geolocationRepository})
      : _geolocationRepository = geolocationRepository,
        super(GeolocationBloc());

  Stream<GeolocationState> mapEventToState(GeolocationEvent event) async* {
    if (event is LoadGeolocation) {
      yield* _mapLoadGeolocationToState();
    } else if (event is UpdateGeolocation) {
      yield* _mapUpdateGeolocationToState(event);
    }
  }

  Stream<GeolocationState> _mapLoadGeolocationToState() async* {
    _streamSubscription.cancel();
    final Position position = await _geolocationRepository.getCurrentPosition();
    add(UpdateGeolocation(position));
  }

  Stream<GeolocationState> _mapUpdateGeolocationToState(
      UpdateGeolocation event) async* {
    yield GeolocationLoaded(position: event.position);
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
