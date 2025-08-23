/// este arquivo define as interfaces base para o repositório e serviço
/// no Jx2Core. Essas interfaces são projetadas para serem implementadas
/// por classes específicas de repositório e serviço, fornecendo
/// uma estrutura comum para operações CRUD (Create, Read, Update, Delete).
/// As interfaces incluem métodos para buscar, criar, atualizar e excluir
/// entidades, além de métodos para lidar com resultados de operações.
abstract class Jx2BaseRepository<T> {
  //// Busca uma entidade pelo ID.
  /// @param id O ID da entidade a ser buscada.
  Future<T?> getById(String id);

  /// Busca todas as entidades.
  /// @return Uma lista de todas as entidades.
  Future<List<T>> getAll();

  /// Cria uma nova entidade.
  /// @param entity A entidade a ser criada.
  Future<T> create(T entity);

  /// Atualiza uma entidade existente.
  /// @param entity A entidade a ser atualizada.
  Future<T> update(T entity);

  /// Exclui uma entidade pelo ID.
  /// @param id O ID da entidade a ser excluída.
  Future<bool> delete(String id);
}
