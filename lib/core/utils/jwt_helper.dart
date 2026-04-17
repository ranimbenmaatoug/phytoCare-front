import 'dart:convert';

class JwtHelper {
  static Map<String, dynamic> decodePayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return {};
    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final decoded = utf8.decode(base64Url.decode(normalized));
    return jsonDecode(decoded);
  }

  static String? getRole(String token) {
    final payload = decodePayload(token);
    return payload['role'] as String?;
  }
}