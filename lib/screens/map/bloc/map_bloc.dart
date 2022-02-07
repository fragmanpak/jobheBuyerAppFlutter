import 'package:bloc/bloc.dart';
import 'package:jobheebuyer/services/map_services.dart';

import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapInitial()) {
    on<LoadMyPosition>((event, emit) => _loadPosition(event));
    on<SearchAddress>((event, emit) => _searchAddress(event.query));
    on<LoadRouteCoordinates>((event, emit) => _getRoute(event));
  }

  final currentPosition = MapService.instance.currentPosition;

  Stream<MapState> mapEventToState(MapEvent event) async* {
    if (event is LoadMyPosition) {
      yield* _loadPosition(event);
    } else if (event is SearchAddress) {
      yield* _searchAddress(event.query);
    } else if (event is LoadRouteCoordinates) {
      yield* _getRoute(event);
    }
  }

  Stream<MapState> _loadPosition(LoadMyPosition event) async* {
    if (event.latLng == null) {
      await MapService.instance.getCurrentPosition();
      MapService.instance.listenToPositionChanges();
      yield LoadedCurrentPosition(currentPosition.value);
      print(event.latLng);
    } else {
      final myPosition = await MapService.instance.getPosition(event.latLng);
      yield LoadedCurrentPosition(myPosition);
      print('myPosition - ' + myPosition.toString());
    }
  }

  Stream<MapState> _searchAddress(String query) async* {
    await MapService.instance?.getAddressFromQuery(query);
    yield LoadedSearchAddressResults(MapService.instance.searchedAddress);
  }

  Stream<MapState> _getRoute(LoadRouteCoordinates event) async* {
    final endAddress = await MapService.instance
        .getRouteCoordinates(event.startLatLng, event.endLatLng);
    yield LoadedRoutes(currentPosition.value, endAddress);
  }
}
