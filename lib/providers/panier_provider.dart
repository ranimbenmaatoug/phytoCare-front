import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/plante_model.dart';

class PanierItem {
  final PlanteModel plante;
  int quantite;
  PanierItem({required this.plante, required this.quantite});
}

class PanierNotifier extends StateNotifier<List<PanierItem>> {
  PanierNotifier() : super([]);

  void ajouterAuPanier(PlanteModel plante, int quantite) {
    final idx = state.indexWhere((e) => e.plante.id == plante.id);
    if (idx >= 0) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == idx)
            PanierItem(plante: plante, quantite: state[i].quantite + quantite)
          else
            state[i],
      ];
    } else {
      state = [...state, PanierItem(plante: plante, quantite: quantite)];
    }
  }

  void retirerDuPanier(int planteId) {
    state = state.where((e) => e.plante.id != planteId).toList();
  }

  void changerQuantite(int planteId, int quantite) {
    if (quantite <= 0) { retirerDuPanier(planteId); return; }
    state = [
      for (final item in state)
        if (item.plante.id == planteId)
          PanierItem(plante: item.plante, quantite: quantite)
        else item,
    ];
  }

  void viderPanier() => state = [];

  double get total => state.fold(0, (s, e) => s + e.plante.prix * e.quantite);
}

final panierProvider = StateNotifierProvider<PanierNotifier, List<PanierItem>>(
    (_) => PanierNotifier());