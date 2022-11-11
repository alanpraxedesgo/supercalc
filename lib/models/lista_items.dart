class ListaItems {
  int? id;
  String descricao;
  double valor;
  int listaId;

  ListaItems(
      {this.id,
      required this.descricao,
      required this.valor,
      required this.listaId});

  Map<String, Object> toMap() {
    return {
      'id': id ?? 0,
      'descricao': descricao,
      'valor': valor,
      'listaId': listaId
    };
  }

  static ListaItems fromMap(Map<String, dynamic> item) {
    return ListaItems(
        id: item['id'],
        descricao: item['descricao'],
        valor: item['valor'],
        listaId: item['listaId']);
  }
}
