/// Base exception class
class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'AppException: $message (statusCode: $statusCode)';
}

/// Server exception
class ServerException extends AppException {
  const ServerException({
    super.message = 'Error del servidor',
    super.statusCode,
  });
}

/// Network exception
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'Sin conexión a internet',
    super.statusCode,
  });
}

/// Cache exception
class CacheException extends AppException {
  const CacheException({
    super.message = 'Error de caché local',
    super.statusCode,
  });
}

/// Not found exception
class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Recurso no encontrado',
    super.statusCode = 404,
  });
}