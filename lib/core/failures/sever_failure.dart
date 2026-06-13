abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

/// Returned when server communications or API responses time out or break down
class ServerFailure extends Failure {
  const ServerFailure([String message = "Server connection lost. Please try again later."]) : super(message);
}

/// Returned when local device caching, SharedPreferences, or secure storage lookups fail
class CacheFailure extends Failure {
  const CacheFailure([String message = "Unable to retrieve localized user preferences storage cache."]) : super(message);
}

/// Returned when input constraints or validation requests fail locally or server-side
class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}