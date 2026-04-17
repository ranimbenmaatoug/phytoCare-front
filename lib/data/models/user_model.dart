class UserModel {
  final int? id;
  final String nom;
  final String prenom;
  final String email;
  final String? motDePasse;
  final String? statutCompte;
  final String? numeroTelephone;
  final String? adresse;
  final String role; // CLIENT, VENDEUR, ADMINISTRATEUR

  UserModel({
    this.id, required this.nom, required this.prenom,
    required this.email, this.motDePasse, this.statutCompte,
    this.numeroTelephone, this.adresse, required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    nom: json['nom'] ?? '',
    prenom: json['prenom'] ?? '',
    email: json['email'] ?? '',
    statutCompte: json['statutCompte'],
    numeroTelephone: json['numeroTelephone'],
    adresse: json['adresse'],
    role: json['role'] ?? 'CLIENT',
  );

  Map<String, dynamic> toJson() => {
    'nom': nom, 'prenom': prenom, 'email': email,
    'motDePasse': motDePasse, 'numeroTelephone': numeroTelephone,
    'adresse': adresse, 'role': role,
  };
}