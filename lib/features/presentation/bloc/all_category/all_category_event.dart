part of 'all_category_bloc.dart';

abstract class AllCategoryEvent extends Equatable {
  const AllCategoryEvent();

  @override
  List<Object> get props => [];
}

class GetAllCategoryEvent extends AllCategoryEvent {
  final int? page;
  GetAllCategoryEvent({
    required this.page,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GetAllCategoryEvent && other.page == page;
  }

  @override
  int get hashCode => page.hashCode;

  @override
  String toString() => 'GetAllCategoryEvent(page: $page)';
}
