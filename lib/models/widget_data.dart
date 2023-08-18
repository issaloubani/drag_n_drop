class WidgetData {
  final Type type;
  final bool isTarget;
  final Map<String, dynamic> args;

  WidgetData({
    required this.type,
    required this.args,
    this.isTarget = true,
  });
}
