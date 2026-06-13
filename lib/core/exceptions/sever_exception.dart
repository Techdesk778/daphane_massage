class ServerException implements Exception {
  final String? message;
  const ServerException([this.message]);

  @override
  String toString() => message ?? "ServerException: Deep database communication failed.";
}

class CacheException implements Exception {
  final String? message;
  const CacheException([this.message]);

  @override
  String toString() => message ?? "CacheException: Local memory disk operation allocation block failed.";
}