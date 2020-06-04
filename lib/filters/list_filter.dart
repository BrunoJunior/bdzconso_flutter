class ListFilter {
  final listIsEmpty = (List value) => 0 == (value?.length ?? 0);
  final listIsNotEmpty = (List value) => 0 != (value?.length ?? 0);
  listHasOnly(int elements) => (List value) => elements == (value?.length ?? 0);
}
