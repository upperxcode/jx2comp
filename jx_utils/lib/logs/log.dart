/// Utilitário para formatação e impressão de logs no console do Flutter.
///
/// A classe `JxLog` oferece um sistema de logs robusto com vários níveis de severidade,
/// cores e informações detalhadas sobre a origem do log (arquivo, linha, função).
///
/// Principais Funcionalidades:
/// - **Níveis de Log**: Permite categorizar as mensagens em níveis de severidade como `trace`, `debug`, `info`, `warning`, `error` e `critical`.
/// - **Filtro**: Os logs podem ser filtrados por nível de severidade para exibir apenas as mensagens mais importantes.
/// - **Cores**: Usa códigos de cores ANSI para destacar os logs no console, facilitando a identificação visual.
/// - **Rastreamento de Origem**: Utiliza a biblioteca `stack_trace` para identificar automaticamente o arquivo, a linha e a função que gerou o log.
/// - **Cores por Palavra-Chave**: Permite configurar cores personalizadas para logs que contenham palavras-chave específicas, como "sucesso" ou "falha".
///
/// O objetivo é fornecer uma ferramenta de depuração poderosa e limpa, eliminando a necessidade de usar `print()` diretamente e garantindo que os logs sejam informativos e fáceis de analisar.
library;

import 'package:flutter/foundation.dart';
import 'package:jx_utils/logs/console_printer.dart';
import 'package:stack_trace/stack_trace.dart';

import 'log_colors.dart';
import 'log_manager.dart';

class JxLog {
  static LogLevel _currentLogLevel = LogLevel.info;
  static Set<LogOutput> _logOutputs = {LogOutput.console, LogOutput.file};
  //static LogFileHandler? _logFileHandler;
  static final Map<LogLevel, LogColor> _logColors = {
    LogLevel.trace: LogColor.white,
    LogLevel.debug: LogColor.cyan,
    LogLevel.info: LogColor.green,
    LogLevel.warning: LogColor.yellow,
    LogLevel.error: LogColor.red,
    LogLevel.critical: LogColor.magenta,
  };

  static Map<String, LogColor> _keywordColors = {};

  JxLog._();

  static void setLevel(LogLevel level) {
    _currentLogLevel = level;
  }

  /// Define os destinos da saída do log (console, arquivo, ou ambos).
  ///
  /// Exemplo:
  /// - Apenas console: `JxLog.setOutputs({LogOutput.console});`
  /// - Apenas arquivo: `JxLog.setOutputs({LogOutput.file});`
  /// - Ambos (padrão): `JxLog.setOutputs({LogOutput.console, LogOutput.file});`
  /// - Nenhum: `JxLog.setOutputs({});`
  static void setOutputs(Set<LogOutput> outputs) {
    _logOutputs = outputs;
  }

  static void setKeywordColors(Map<String, LogColor> colors) {
    _keywordColors = colors;
  }

  static void _processLog(LogLevel level, String message, Trace trace) {
    if (kReleaseMode && level.index < LogLevel.error.index) {
      return;
    }

    if (level.index < _currentLogLevel.index) {
      return;
    }

    final callerInfo = _getCallerInfo(trace);
    LogColor color = _logColors[level]!;

    _keywordColors.forEach((keyword, keywordColor) {
      if (message.contains(keyword)) {
        color = keywordColor;
      }
    });

    final now = DateTime.now();
    final timestamp =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}.${now.millisecond.toString().padLeft(3, '0')}';

    final levelName = level.toString().split('.').last.toUpperCase();
    final logDetails = '[$levelName] ${callerInfo != null ? '($callerInfo) ' : ''}$message';

    // Mensagem para arquivo (sem cor)
    final cleanMessage = '[$timestamp] $logDetails';
    // Mensagem para console (com cor)
    final coloredMessage = '${color.code}[$timestamp] $logDetails$resetColor';

    // 1. Imprime a mensagem colorida no console de depuração
    if (_logOutputs.contains(LogOutput.console) && kDebugMode) {
      consolePrint(coloredMessage);
    }

    // 2. Salva a mensagem limpa (sem cores) no arquivo/banco de dados
    if (_logOutputs.contains(LogOutput.file)) {
      writeLog(cleanMessage);
    }
  }

  static String? _getCallerInfo(Trace trace) {
    try {
      final frame = trace.frames.firstWhere((frame) {
        final uriString = frame.uri.toString();
        return !uriString.contains('log.dart') && !uriString.contains('stack_trace.dart');
      });

      final uri = frame.uri;
      final lineNumber = frame.line;
      final member = frame.member;

      if (lineNumber != null && member != null) {
        final fileName = uri.path.split('/').last;
        final methodName = member.split('.').last;
        return '$fileName:$lineNumber - $methodName';
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  ///Quando usar: Para o nível de detalhe mais baixo. Use para rastrear o fluxo de dados,
  ///o estado de variáveis dentro de loops, ou chamadas de função repetidas.
  ///Pense nele como uma "trilha de migalhas de pão" para entender o que está acontecendo passo a passo.
  static void trace(String message) => _processLog(LogLevel.trace, message, Trace.current());

  ///Quando usar: Para informações de depuração que são úteis para os desenvolvedores,
  ///mas que geralmente não são importantes para o fluxo principal do aplicativo.
  ///Use para mostrar valores de variáveis em pontos-chave do código, o estado de um widget,
  ///ou o resultado de uma operação.
  static void debug(String message) => _processLog(LogLevel.debug, message, Trace.current());

  ///Quando usar: Para eventos importantes que indicam que o aplicativo está funcionando como esperado.
  ///Use para o início e fim de operações maiores, como a inicialização do aplicativo,
  ///o login do usuário, ou o salvamento de dados. É um log que confirma que algo esperado aconteceu.
  static void info(String message) => _processLog(LogLevel.info, message, Trace.current());

  ///Quando usar: Para indicar que algo inesperado, mas não fatal, aconteceu. A aplicação
  ///pode continuar funcionando, mas a situação pode levar a problemas futuros.
  ///Use para dados faltando, configurações incorretas ou valores que não correspondem ao esperado.
  static void warning(String message) => _processLog(LogLevel.warning, message, Trace.current());

  ///Quando usar: Para erros que impedem uma funcionalidade de ser concluída, mas que não travam
  ///o aplicativo por completo. Geralmente, esses erros devem ser tratados com um try-catch.
  ///Use para falhas na comunicação com a API, erros de parsing, ou tentativas falhas de acesso a dados.
  static void error(String message) => _processLog(LogLevel.error, message, Trace.current());

  ///Quando usar: Para erros graves e fatais que fazem com que a aplicação não consiga continuar.
  ///Isso é o mais severo. Use para falhas de inicialização, erros de dependência,
  ///ou quando um serviço essencial (como o banco de dados) não puder ser acessado.
  ///Esses logs indicam que o aplicativo não pode mais funcionar.
  static void critical(String message) => _processLog(LogLevel.critical, message, Trace.current());
}
