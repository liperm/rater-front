import 'favorito.dart';

class Usuario {
  int? id;
  String? nome;
  String? email;
  String? senha;
  String? confirmarSenha;
  List<Favorito>? favoritos;

  Usuario({
    this.id,
    this.nome,
    this.email,
    this.senha,
    this.confirmarSenha,
    this.favoritos,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    Usuario usuario = Usuario(
      id: json['id'],
      nome: json['name'],
      email: json['email'],
      senha: json['password'],
      confirmarSenha: '',
    );
    if (json['favorites'] != null) {
      usuario.favoritos =
          json['favorites'].map((fav) => Favorito.fromJson(fav)).toList();
    }
    return usuario;
  }
}
