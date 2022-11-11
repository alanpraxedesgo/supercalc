class Lista {
  int? id;
  String nome;
  double saldo;

  Lista({this.id, required this.nome, required this.saldo});

  Map<String, Object> toMap() {
    return {'id': id ?? 0, 'nome': nome, 'saldo': saldo};
  }

  static Lista fromMap(Map<String, dynamic> lista) {
    return Lista(id: lista['id'], nome: lista['nome'], saldo: lista['saldo']);
  }
}
