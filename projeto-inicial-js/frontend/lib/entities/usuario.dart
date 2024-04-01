class Usuario {
  final int id;
  final String nome;
  final String email;
  final String? password; // Opcional(nao vem na listagem e etc)

  Usuario({required this.id, required this.nome, required this.email, this.password});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
    );
  }
}
