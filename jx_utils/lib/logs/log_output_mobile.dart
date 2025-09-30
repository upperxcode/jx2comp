// lib/logs/log_output_mobile.dart

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

// Variável interna para armazenar a instância do handler de arquivo de log.
// Ela só é acessada dentro deste arquivo.
late final LogFileHandler _logFileHandler;

/// Função para inicializar o log de arquivo, chamada pelo `main.dart`.
Future<void> initialize({required double maxLogSize, required String logFileName}) async {
  _logFileHandler = LogFileHandler(maxFileSizeMB: maxLogSize, logFileName: logFileName);
  await _logFileHandler.init();
}

/// A função que será exposta pelo log_manager.dart para escrever logs.
Future<void> writeLog(String message) async {
  await _logFileHandler.write(message);
}

/// A função que será exposta pelo log_manager.dart para ler os logs.
/// Esta função não é exportada diretamente, mas usada por `exportLogs`.
@internal
Future<List<Map<String, dynamic>>?> readLogs() async {
  try {
    final files = await _logFileHandler.getAllLogFiles();
    if (files.isEmpty) return [];

    final allLines = <String>[];
    for (final file in files) {
      if (await file.exists()) {
        allLines.addAll(await file.readAsLines());
      }
    }

    // Simplesmente convertendo cada linha em um mapa para manter a consistência da API.
    return allLines.map((line) => {'message': line}).toList();
  } catch (e) {
    debugPrint('Erro ao ler arquivos de log: $e');

    return null;
  }
}

/// Abre a caixa de diálogo de compartilhamento para exportar os arquivos de log.
Future<void> exportLogs() async {
  debugPrint("exportLogs $_logFileHandler");
  final files = await _logFileHandler.getAllLogFiles();
  if (files.isEmpty) {
    debugPrint('Nenhum arquivo de log encontrado para compartilhar.');
    return;
  }
  final xFiles = files.map((file) => XFile(file.path)).toList();
  await Share.shareXFiles(xFiles, text: 'Arquivos de Log do App');
}

/// A classe que gerencia os arquivos de log.
class LogFileHandler {
  final int maxSizeBytes;
  final String logFileName;
  late final Directory _appDocumentsDir;

  LogFileHandler({required double maxFileSizeMB, required this.logFileName})
    : maxSizeBytes = (maxFileSizeMB * 1024 * 1024).toInt();

  Future<void> init() async {
    _appDocumentsDir = await getApplicationDocumentsDirectory();
  }

  Future<void> write(String message) async {
    try {
      if (!await _appDocumentsDir.exists()) {
        await _appDocumentsDir.create(recursive: true);
      }
      int rotation = 0;
      File logFile;
      do {
        logFile = _getLogFile(rotation);
        if (await logFile.exists() && await logFile.length() > maxSizeBytes) {
          rotation++;
        } else {
          break;
        }
      } while (true);
      await logFile.writeAsString('$message\n', mode: FileMode.append);
    } catch (e) {
      debugPrint('ERRO AO ESCREVER NO ARQUIVO DE LOG: $e');
    }
  }

  String _getFileName(int rotationNumber) {
    final today = DateTime.now();
    final date = '${today.year}-${_twoDigits(today.month)}-${_twoDigits(today.day)}';
    if (rotationNumber > 0) {
      return '$logFileName-$date-$rotationNumber.log';
    }
    return '$logFileName-$date.log';
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  File _getLogFile(int rotationNumber) {
    final fileName = _getFileName(rotationNumber);
    return File('${_appDocumentsDir.path}/$fileName');
  }

  Future<List<File>> getAllLogFiles() async {
    final dir = _appDocumentsDir;
    if (!await dir.exists()) {
      return [];
    }

    final entities = dir.listSync();
    return entities
        .whereType<File>()
        .where((file) => file.path.contains(logFileName) && file.path.endsWith('.log'))
        .toList();
  }
}
