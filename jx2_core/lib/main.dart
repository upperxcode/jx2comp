

import 'jx2_core.dart';

void main() {
  // Exemplo de uso do ResultModel
  final result = Jx2ResultModel.success(['Item 1', 'Item 2']);
  print(result.isSuccess); // true

  // Exemplo de validadores
  print(Jx2Validators.isValidEmail('teste@exemplo.com')); // true
  print(Jx2Validators.isValidCPF('12345678909')); // Resultado depende do CPF
}