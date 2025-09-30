// lib/log_manager.dart

// Importa a implementação correta com base na plataforma.
import 'package:flutter/foundation.dart';

import 'log_output_mobile.dart' if (dart.library.html) 'log_output_web.dart' as logger;

/// Escreve uma mensagem de log usando a implementação da plataforma atual.
Future<void> writeLog(String message) async {
  await logger.writeLog(message);
}

/// Exporta os logs da plataforma atual.
/// Na web, aciona o download de um arquivo .txt.
/// No mobile, abre a caixa de diálogo de compartilhamento para salvar/enviar os arquivos de log.
Future<void> exportLogs() async {
  debugPrint("exportLogs ...");
  await logger.exportLogs();
  debugPrint("... exportLogs");
}

/// A função que o main.dart deve chamar para inicializar o logger.
Future<void> initializeLogger({required double maxLogSize, required String logFileName}) async {
  await logger.initialize(maxLogSize: maxLogSize, logFileName: logFileName);
}
