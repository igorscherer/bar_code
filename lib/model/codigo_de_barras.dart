class Codigo {
  final int? id;
  final String codigoEscaneado;
  final DateTime? time;
  final String? createdTime;

  const Codigo(
      {this.id,
      required this.codigoEscaneado,
      this.time,
      required this.createdTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'codigoEscaneado': codigoEscaneado,
      'time': createdTime,
    };
  }

  @override
  String toString() {
    return 'Codigo{id: $id, codigoEscaneado: $codigoEscaneado, time $createdTime}';
  }
}
