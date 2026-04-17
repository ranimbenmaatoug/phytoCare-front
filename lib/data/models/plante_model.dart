class PlanteModel {
  final int? id;
  final String nomScientifique;
  final String typePlante;
  final String description;
  final int quantiteStock;
  final double prix;
  final String? besoinEau;
  final String? tempOptimale;
  final String? saisonPlantation;
  final String? urlPlante;
  final String? etatPlante;
  final List<String>? images;

  PlanteModel({
    this.id, required this.nomScientifique, required this.typePlante,
    required this.description, required this.quantiteStock,
    required this.prix, this.besoinEau, this.tempOptimale,
    this.saisonPlantation, this.urlPlante, this.etatPlante, this.images,
  });

  factory PlanteModel.fromJson(Map<String, dynamic> json) => PlanteModel(
    id: json['id'],
    nomScientifique: json['nomScientifique'] ?? '',
    typePlante: json['typePlante'] ?? '',
    description: json['description'] ?? '',
    quantiteStock: json['quantiteStock'] ?? 0,
    prix: (json['prix'] ?? 0).toDouble(),
    besoinEau: json['besoinEau'],
    tempOptimale: json['tempOptimale'],
    saisonPlantation: json['saisonPlantation'],
    urlPlante: json['urlPlante'],
    etatPlante: json['etatPlante'],
    images: json['images'] != null
        ? List<String>.from(json['images'].map((i) => i['urlFichier']))
        : [],
  );

  Map<String, dynamic> toJson() => {
    'nomScientifique': nomScientifique, 'typePlante': typePlante,
    'description': description, 'quantiteStock': quantiteStock,
    'prix': prix, 'besoinEau': besoinEau, 'tempOptimale': tempOptimale,
    'saisonPlantation': saisonPlantation,
  };
}