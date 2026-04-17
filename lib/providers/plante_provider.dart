import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/plante_model.dart';
import '../data/services/plante_service.dart';

final planteServiceProvider = Provider((ref) => PlanteService());

final plantesProvider = FutureProvider<List<PlanteModel>>((ref) async {
  return ref.read(planteServiceProvider).getAllPlantes();
});

final planteDetailProvider = FutureProvider.family<PlanteModel, int>((ref, id) async {
  return ref.read(planteServiceProvider).getPlanteById(id);
});

// Filtre local
final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedTypeProvider = StateProvider<String?>((ref) => null);

final filteredPlantesProvider = Provider<AsyncValue<List<PlanteModel>>>((ref) {
  final plantes = ref.watch(plantesProvider);
  final query   = ref.watch(searchQueryProvider).toLowerCase();
  final type    = ref.watch(selectedTypeProvider);

  return plantes.whenData((list) => list.where((p) {
    final matchQuery = query.isEmpty ||
        p.nomScientifique.toLowerCase().contains(query) ||
        p.typePlante.toLowerCase().contains(query);
    final matchType = type == null || p.typePlante == type;
    return matchQuery && matchType;
  }).toList());
});