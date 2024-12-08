import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:property_bloc_fetch_api/models/property_model.dart';
import 'package:property_bloc_fetch_api/resources/api_repository.dart';

part 'property_event.dart';
part 'property_state.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  PropertyBloc() : super(PropertyInitial()) {
    final ApiRepository _apiRepository = ApiRepository();

    on<GePropertyList>((event, emit) async {
      try {
        emit(PropertyLoading());
        final mList = await _apiRepository.fetchPropertyList();
        emit(PropertyLoaded(mList));
        if (mList.error != null) {
          emit(PropertyError(mList.error));
        }
      } on NetworkError {
        emit(PropertyError("Failed to fetch data. is your device online?"));
      }
    });
  }
}
