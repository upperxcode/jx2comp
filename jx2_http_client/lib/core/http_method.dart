enum Jx2HttpMethod {
  get,
  post,
  put,
  delete,
  patch,
  head,
  options
  // Remover 'trace' pois não é suportado diretamente pelo Dio
}

/// Extensão para converter o enum [Jx2HttpMethod] em uma string
/// representando o método HTTP correspondente.
/// Adiciona métodos para verificar se o método é seguro ou idempotente.
extension Jx2HttpMethodExtension on Jx2HttpMethod {
  String get name {
    switch (this) {
      case Jx2HttpMethod.get:
        return 'GET';
      case Jx2HttpMethod.post:
        return 'POST';
      case Jx2HttpMethod.put:
        return 'PUT';
      case Jx2HttpMethod.delete:
        return 'DELETE';
      case Jx2HttpMethod.patch:
        return 'PATCH';
      case Jx2HttpMethod.head:
        return 'HEAD';
      case Jx2HttpMethod.options:
        return 'OPTIONS';
    }
  }

  bool get isSafe =>
      this == Jx2HttpMethod.get ||
      this == Jx2HttpMethod.head ||
      this == Jx2HttpMethod.options;

  bool get isIdempotent =>
      isSafe || this == Jx2HttpMethod.put || this == Jx2HttpMethod.delete;
}
