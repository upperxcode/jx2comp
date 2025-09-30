import 'dart:async';
import 'package:web/web.dart' as web;
import 'package:flutter/foundation.dart';
import 'dart:js_interop';

const String dbName = 'logs_db';
const int dbVersion = 1;
const String storeName = 'logs_store';

web.IDBDatabase? _db;
Future<web.IDBDatabase>? _dbInitializer;

Future<void> initialize({required double maxLogSize, required String logFileName}) async {
  await _getDb(); // Parâmetros não são usados na web, mas a assinatura deve corresponder.
}

/// Obtém a instância do banco de dados, inicializando-a se necessário.
/// Usa um Future para evitar múltiplas inicializações concorrentes.
Future<web.IDBDatabase> _getDb() {
  _dbInitializer ??= _initDb();
  return _dbInitializer!;
}

Future<web.IDBDatabase> _initDb() async {
  final completer = Completer<web.IDBDatabase>();
  final request = web.window.indexedDB.open(dbName, dbVersion);

  request.onupgradeneeded = (web.IDBVersionChangeEvent event) {
    final db = request.result as web.IDBDatabase;
    if (!db.objectStoreNames.contains(storeName)) {
      db.createObjectStore(storeName, web.IDBObjectStoreParameters(autoIncrement: true));
      debugPrint('IndexedDB: Object Store "$storeName" criado.');
    }
  }.toJS;

  request.onsuccess = (web.Event event) {
    debugPrint('IndexedDB: Banco de dados "$dbName" aberto com sucesso.');
    _db = request.result as web.IDBDatabase;
    completer.complete(_db);
  }.toJS;

  request.onerror = (web.Event event) {
    final error = request.error;
    debugPrint('Error: Falha ao inicializar IndexedDB: $error');
    completer.completeError('Falha ao inicializar IndexedDB: $error');
  }.toJS;

  return completer.future;
}

Future<void> writeLog(String message) async {
  try {
    final db = await _getDb();

    final transaction = db.transaction(storeName.toJS, 'readwrite');
    final store = transaction.objectStore(storeName.toString());
    final completer = Completer<void>();
    transaction.oncomplete = (web.Event _) {
      completer.complete();
    }.toJS;
    transaction.onerror = (web.Event event) {
      completer.completeError('Transaction error: ${transaction.error}');
    }.toJS;

    final logEntry = {
      'timestamp': DateTime.now().toIso8601String(),
      'message': message,
      'level': getLogLevel(message),
    }.jsify(); // Converte o mapa Dart para um objeto JS

    store.add(logEntry as JSAny);

    await completer.future; // Aguarda a transação ser concluída
    // debugPrint('Registro adicionado com sucesso'); // Opcional: pode poluir o console
  } catch (e) {
    debugPrint('Erro ao escrever log no IndexedDB: $e');
  }
}

Future<List<Map<String, dynamic>>?> readLogs() async {
  try {
    final db = await _getDb();
    final transaction = db.transaction(storeName.toJS, 'readonly');
    final store = transaction.objectStore(storeName.toString());

    // Obter todos os registros
    final request = store.getAll();

    final completer = Completer<List<Map<String, dynamic>>?>();

    request.onsuccess = (web.Event event) {
      final jsArray = request.result as JSArray?;
      if (jsArray == null) {
        completer.complete([]);
        return;
      }
      final list = <Map<String, dynamic>>[];
      for (final item in jsArray.toDart) {
        if (item != null && item.isA<JSObject>()) {
          // Converte o objeto JS para um mapa Dart
          final map = (item.dartify() as Map).cast<String, dynamic>();
          list.add(map);
        }
      }
      completer.complete(list);
    }.toJS;

    request.onerror = (web.Event event) {
      debugPrint('Erro ao ler logs: ${request.error}');
      completer.completeError('Erro ao ler logs: ${request.error}');
    }.toJS;

    return completer.future;
  } catch (e) {
    debugPrint('Erro ao ler logs: $e');
    return null;
  }
}

Future<void> clearLogs() async {
  try {
    final db = await _getDb();
    final transaction = db.transaction(storeName.toJS, 'readwrite');
    final store = transaction.objectStore(storeName.toString());
    final completer = Completer<void>();
    transaction.oncomplete = (web.Event _) {
      completer.complete();
    }.toJS;
    transaction.onerror = (web.Event event) {
      completer.completeError('Transaction error on clear: ${transaction.error}');
    }.toJS;

    store.clear();

    await completer.future;
    debugPrint('Logs limpos com sucesso.');
  } catch (e) {
    debugPrint('Erro ao limpar logs: $e');
  }
}

Future<void> exportLogs() async {
  try {
    final logs = await readLogs();
    if (logs == null || logs.isEmpty) {
      debugPrint('Nenhum log para exportar.');
      return;
    }

    // Formata os logs em uma única string, um por linha.
    final buffer = StringBuffer();
    for (final logEntry in logs) {
      // A mensagem já vem formatada da classe JxLog
      final message = logEntry['message'] as String? ?? 'Mensagem indisponível';
      buffer.writeln(message);
    }

    final logContent = buffer.toString();
    final doc = web.window.document;

    final blob = web.Blob(
      [logContent.toJS].toJS,
      web.BlobPropertyBag(type: 'text/plain;charset=utf-8'),
    );
    final url = web.URL.createObjectURL(blob);
    final anchor = doc.createElement('a') as web.HTMLAnchorElement;

    final today = DateTime.now();
    final date =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    anchor.href = url;
    anchor.download = 'app-logs-$date.txt';
    anchor.click(); // Aciona o download

    web.URL.revokeObjectURL(url); // Libera a memória
    debugPrint('Exportação de logs iniciada.');
  } catch (e) {
    debugPrint('Erro ao exportar logs na web: $e');
  }
}

String getLogLevel(String message) {
  if (message.contains('[ERROR]')) return 'ERROR';
  if (message.contains('[WARNING]')) return 'WARNING';
  if (message.contains('[CRITICAL]')) return 'CRITICAL';
  return 'INFO';
}
