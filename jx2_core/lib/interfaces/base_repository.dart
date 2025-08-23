import 'base_interface.dart';

abstract class Jx2BaseService<T> {
  final Jx2BaseRepository repository;

  /// Construtor da classe Jx2BaseService.
  Jx2BaseService({required this.repository});

  /// Busca uma entidade pelo ID.
  /// @param id O ID da entidade a ser buscada.
  Future<T?> findById(String id);

  /// Busca todas as entidades.
  Future<List<T>> findAll();

  /// Cria uma nova entidade.
  Future<T> save(T entity);

  /// Atualiza uma entidade existente.
  Future<bool> remove(String id);
}
