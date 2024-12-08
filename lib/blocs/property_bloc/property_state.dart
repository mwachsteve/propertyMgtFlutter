part of 'property_bloc.dart';

abstract class PropertyState extends Equatable {
  const PropertyState();

  @override
  List<Object?> get props => [];
}

class PropertyInitial extends PropertyState {}

class PropertyLoading extends PropertyState {}

class PropertyLoaded extends PropertyState {
  final PropertyModel propertyModel;
  const PropertyLoaded(this.propertyModel);
}

class PropertyError extends PropertyState {
  final String? message;
  const PropertyError(this.message);
}
