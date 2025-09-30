enum LogLevel { trace, debug, info, warning, error, critical }

// Enum que define as opções de saída do log.
enum LogOutput {
  console, // Saída padrão para o terminal de console
  file, // Saída para um arquivo de log
}

/// Enum que armazena códigos de cores ANSI para formatação de logs.
enum LogColor {
  // Cores padrão
  black('\x1B[30m'),
  red('\x1B[31m'),
  green('\x1B[32m'),
  yellow('\x1B[33m'),
  blue('\x1B[34m'),
  magenta('\x1B[35m'),
  cyan('\x1B[36m'),
  white('\x1B[37m'),

  // Cores de alto brilho (para destaque)
  brightBlack('\x1B[90m'),
  brightRed('\x1B[91m'),
  brightGreen('\x1B[92m'),
  brightYellow('\x1B[93m'),
  brightBlue('\x1B[94m'),
  brightMagenta('\x1B[95m'),
  brightCyan('\x1B[96m'),
  brightWhite('\x1B[97m'),
  orange('\x1B[38;5;208m'), // Laranja usando a paleta de 256 cores
  brightPurple('\x1B[95m'); // Roxo brilhante (mesmo que brightMagenta, mas com nome diferente)

  final String code;

  const LogColor(this.code);
}

const String resetColor = '\x1B[0m';
