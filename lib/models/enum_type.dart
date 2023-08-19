class EnumType<T> {
  final Type type;
  final List<T> values;
  final T? defaultValue;

  const EnumType({
    required this.type,
    required this.values,
    this.defaultValue,
  });
}
