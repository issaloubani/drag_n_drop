class ComplexType<T> {
  final Type type;
  final T? defaultValue;
  final Map<String, dynamic> supportedParameters;

  const ComplexType(
    this.supportedParameters, {
    required this.type,
    this.defaultValue,
  });
}
