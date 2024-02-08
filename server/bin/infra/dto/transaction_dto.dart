class TransactionDto {
  final double value;
  final String type;
  final String description;

  TransactionDto({
    required this.value,
    required this.type,
    required this.description,
  });

  factory TransactionDto.fromJson(Map<String, dynamic> json) {
    return TransactionDto(
      value: json['valor'],
      type: json['tipo'],
      description: json['descricao'],
    );
  }

  Map<String, dynamic> toJson() => {
        'valor': value,
        'tipo': type,
        'descricao': description,
      };
}
