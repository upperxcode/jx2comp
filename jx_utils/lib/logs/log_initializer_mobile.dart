// lib/logs/log_initializer_mobile.dart

import 'log_output_mobile.dart';

Future<void> initializeLogHandler({required double maxLogSize, required String logFileName}) async {
  final handler = LogFileHandler(maxFileSizeMB: maxLogSize, logFileName: logFileName);
  await handler.init();
  setFileHandler(handler);
}

void setFileHandler(LogFileHandler handler) {
  logFileHandler = handler;
}

late final LogFileHandler logFileHandler;
