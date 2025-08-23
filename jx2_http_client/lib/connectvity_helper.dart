/// essa classe é responsável por verificar a conectividade com a internet
/// e retornar um valor booleano indicando se há conexão ou não.
/// Ela é usada pelo serviço de cliente HTTP [Jx2HttpClientService]
/// para verificar a conectividade antes de realizar uma requisição HTTP.
/// A classe é abstrata e deve ser implementada por classes concretas.
/// A classe é usada para encapsular a lógica de verificação de conectividade
/// e facilitar a realização de requisições HTTP.
/// A classe é usada em conjunto com o cliente HTTP [DioHttpClient].
abstract class Jx2ConnectivityHelper {
  Future<bool> checkInternetConnection();
}

/// Implementação de teste para conectividade
/// Esta implementação sempre retorna true, simulando uma conexão
/// com a internet. É usada para testes e desenvolvimento.
/// A classe é usada para encapsular a lógica de verificação de conectividade
/// e facilitar a realização de requisições HTTP.
/// A classe é usada em conjunto com o cliente HTTP [DioHttpClient].
/// A classe é usada para encapsular a lógica de verificação de conectividade
/// e facilitar a realização de requisições HTTP.
class TestConnectivityHelper implements Jx2ConnectivityHelper {
  @override
  Future<bool> checkInternetConnection() async {
    return true; // Sempre retorna conexão para testes
  }
}
