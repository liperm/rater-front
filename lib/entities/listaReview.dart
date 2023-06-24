class ListaReview {
  String? nome;

  ListaReview({this.nome});

  factory ListaReview.fromJson(Map<String, dynamic> json) {
    return ListaReview(
      nome: json['name'],
    );
  }
}
