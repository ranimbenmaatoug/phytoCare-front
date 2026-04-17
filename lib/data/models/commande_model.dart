class CommandeModel {
  final int? id;
  final String? dateCommande;
  final String statutCommande; // PANIER, PASSEE, VALIDEE
  final double? montantTotal;
  final String? adresseLivraison;
  final String? numeroCommande;
  final List<LigneCommandeModel>? lignes;

  CommandeModel({
    this.id, this.dateCommande, required this.statutCommande,
    this.montantTotal, this.adresseLivraison, this.numeroCommande, this.lignes,
  });

  factory CommandeModel.fromJson(Map<String, dynamic> json) => CommandeModel(
    id: json['id'],
    dateCommande: json['dateCommande'],
    statutCommande: json['statutCommande'] ?? 'PANIER',
    montantTotal: (json['montantTotal'] ?? 0).toDouble(),
    adresseLivraison: json['adresseLivraison'],
    numeroCommande: json['numeroCommande'],
    lignes: json['lignes'] != null
        ? List<LigneCommandeModel>.from(
            json['lignes'].map((l) => LigneCommandeModel.fromJson(l)))
        : [],
  );
}

class LigneCommandeModel {
  final int? id;
  final int quantite;
  final double? montant;
  final PlanteRef? plante;

  LigneCommandeModel({this.id, required this.quantite, this.montant, this.plante});

  factory LigneCommandeModel.fromJson(Map<String, dynamic> json) =>
      LigneCommandeModel(
        id: json['id'],
        quantite: json['quantite'] ?? 1,
        montant: (json['montant'] ?? 0).toDouble(),
        plante: json['plante'] != null ? PlanteRef.fromJson(json['plante']) : null,
      );
}

class PlanteRef {
  final int id;
  final String nomScientifique;
  final double prix;
  final String? urlPlante;

  PlanteRef({required this.id, required this.nomScientifique,
      required this.prix, this.urlPlante});

  factory PlanteRef.fromJson(Map<String, dynamic> json) => PlanteRef(
    id: json['id'], nomScientifique: json['nomScientifique'] ?? '',
    prix: (json['prix'] ?? 0).toDouble(), urlPlante: json['urlPlante'],
  );
}