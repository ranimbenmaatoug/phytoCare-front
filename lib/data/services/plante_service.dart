import '../../core/network/api_client.dart';
import '../models/plante_model.dart';

class PlanteService {
  final _api = ApiClient().dio;

  Future<List<PlanteModel>> getAllPlantes() async {
    final res = await _api.get('/plantes');
    return (res.data as List).map((e) => PlanteModel.fromJson(e)).toList();
  }

  Future<PlanteModel> getPlanteById(int id) async {
    final res = await _api.get('/plantes/$id');
    return PlanteModel.fromJson(res.data);
  }

  Future<List<PlanteModel>> searchPlantes(String query) async {
    final res = await _api.get('/plantes/search', queryParameters: {'q': query});
    return (res.data as List).map((e) => PlanteModel.fromJson(e)).toList();
  }
}