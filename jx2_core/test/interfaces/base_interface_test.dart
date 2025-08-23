import 'package:flutter_test/flutter_test.dart';
import 'package:jx2_core/interfaces/base_interface.dart';
import 'package:jx2_core/interfaces/base_repository.dart';
import 'package:mocktail/mocktail.dart'; // Import mocktail

// Define mock data for testing purposes
final List<Map<String, dynamic>> mockEntities = [
  {'id': '1', 'name': 'Entity 1', 'description': 'This is entity 1'},
  {'id': '2', 'name': 'Entity 2', 'description': 'This is entity 2'}
];

final Map<String, dynamic> mockEntity = {
  'id': '3',
  'name': 'New Entity',
  'description': 'This is a new entity'
};

// Crie um mock que IMPLEMENTA a interface
class MockJx2BaseRepository extends Mock
    implements Jx2BaseRepository<Map<String, dynamic>> {}

void main() {
  group('BaseService Tests with Mocktail', () {
    late MockJx2BaseRepository mockRepository;
    late BaseService service;

    setUp(() {
      mockRepository = MockJx2BaseRepository();
      service = BaseService(mockRepository);
    });

    test('findById should return an entity', () async {
      when(() => mockRepository.getById('1'))
          .thenAnswer((_) async => mockEntities[0]);

      final result = await service.findById('1');

      expect(result, isNotNull);
      verify(() => mockRepository.getById('1'))
          .called(1); // Adicione a verificação
    });

    test('findAll should return a list of entities', () async {
      when(() => mockRepository.getAll()).thenAnswer((_) async => [mockEntity]);

      final result = await service.findAll();

      expect(result, isA<List>());
      verify(() => mockRepository.getAll()).called(1); // Adicione a verificação
    });

    test('save should return the saved entity', () async {
      final entity = mockEntities[0];
      when(() => mockRepository.create(entity)).thenAnswer((_) async => entity);

      final result = await service.save(entity);

      expect(result, equals(entity));
      verify(() => mockRepository.create(entity))
          .called(1); // Adicione a verificação
    });

    test('remove should return true on successful deletion', () async {
      when(() => mockRepository.delete('id')).thenAnswer((_) async => true);

      final result = await service.remove('id');

      expect(result, isTrue);
      verify(() => mockRepository.delete('id'))
          .called(1); // Adicione a verificação
    });
  });
}

class BaseService implements Jx2BaseService {
  final Jx2BaseRepository repository;

  BaseService(this.repository);

  @override
  Future findById(String id) async {
    return await repository.getById(id);
  }

  @override
  Future<List> findAll() async {
    return await repository.getAll();
  }

  @override
  Future save(entity) async {
    return await repository.create(entity);
  }

  @override
  Future<bool> remove(String id) async {
    return await repository.delete(id);
  }
}
