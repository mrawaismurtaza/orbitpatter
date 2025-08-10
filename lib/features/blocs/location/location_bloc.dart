import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orbitpatter/core/services/location_service.dart';
import 'package:orbitpatter/features/blocs/location/location_event.dart';
import 'package:orbitpatter/features/blocs/location/location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationService locationService;

  LocationBloc(this.locationService) : super(LocationInitial()) {
    on<FetchLocationEvent>(_onFetchLocation);
    on<FetchCountryFromLocationEvent>(_onFetchCountryFromLocation);
  }


  Future<void> _onFetchLocation(
      FetchLocationEvent event, Emitter<LocationState> emit) async {
    emit(LocationLoading());
    try {
      final location = await locationService.getCurrentLocation();
      if (location != null) {
        emit(LocationLoaded(location));
      } else {
        emit(LocationError('Failed to fetch location'));
      }
    } catch (e) {
      emit(LocationError('Failed to fetch location'));
    }
  }

  Future<void> _onFetchCountryFromLocation(
      FetchCountryFromLocationEvent event, Emitter<LocationState> emit) async {
    emit(LocationLoading());
    try {
      final country = await locationService.getCountryFromLocation();
      if (country != null) {
        emit(LocationLoaded(country));
      } else {
        emit(LocationError('Failed to fetch country'));
      }
    } catch (e) {
      emit(LocationError('Failed to fetch country'));
    }
  }
}