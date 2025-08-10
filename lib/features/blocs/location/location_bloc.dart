import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orbitpatter/core/services/location_service.dart';
import 'package:orbitpatter/data/models/location.dart';
import 'package:orbitpatter/features/blocs/location/location_event.dart';
import 'package:orbitpatter/features/blocs/location/location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationService locationService;

  LocationBloc(this.locationService) : super(LocationInitial()) {
    on<FetchLocationEvent>(_onFetchLocation);
  }

  Future<void> _onFetchLocation(
      FetchLocationEvent event, Emitter<LocationState> emit) async {
    emit(LocationLoading());
    try {
      LocationModel? location = await locationService.getLocation();
      if (location != null) {
        emit(LocationLoaded(location));
      } else {
        emit(LocationError('Failed to fetch location'));
      }
    } catch (e) {
      emit(LocationError('Failed to fetch location'));
    }
  }
}