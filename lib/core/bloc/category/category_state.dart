import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:toko_komputer/core/model/category_model.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();
  @override
  List<Object> get props => [];
}

class CategoryUninitialized extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> data;

  const CategoryLoaded({
    @required this.data,
  });
}

class CategoryCreated extends CategoryState {}

class CategoryUpdated extends CategoryState {}

class CategoryDeleted extends CategoryState {}

class CategoryFailure extends CategoryState {
  final String error;

  const CategoryFailure({@required this.error});

  @override
  List<Object> get props => [error];
}
