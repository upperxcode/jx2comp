class Jx2Validators {
  // Validação de e-mail
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  // Validação de CPF
  static bool isValidCPF(String cpf) {
    // Remove caracteres não numéricos
    cpf = cpf.replaceAll(RegExp(r'[^\d]'), '');

    if (cpf.length != 11) return false;

    // Validação dos dígitos verificadores
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(cpf[i]) * (10 - i);
    }
    int digit1 = 11 - (sum % 11);
    if (digit1 > 9) digit1 = 0;

    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(cpf[i]) * (11 - i);
    }
    int digit2 = 11 - (sum % 11);
    if (digit2 > 9) digit2 = 0;

    return int.parse(cpf[9]) == digit1 &&
           int.parse(cpf[10]) == digit2;
  }

  // Validação de CNPJ
  static bool isValidCNPJ(String cnpj) {
    // Remove caracteres não numéricos
    cnpj = cnpj.replaceAll(RegExp(r'[^\d]'), '');

    if (cnpj.length != 14) return false;

    // Validação dos dígitos verificadores
    List<int> weights1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    List<int> weights2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];

    int sum1 = 0;
    for (int i = 0; i < 12; i++) {
      sum1 += int.parse(cnpj[i]) * weights1[i];
    }
    int digit1 = 11 - (sum1 % 11);
    if (digit1 > 9) digit1 = 0;

    int sum2 = 0;
    for (int i = 0; i < 13; i++) {
      sum2 += int.parse(cnpj[i]) * weights2[i];
    }
    int digit2 = 11 - (sum2 % 11);
    if (digit2 > 9) digit2 = 0;

    return int.parse(cnpj[12]) == digit1 &&
           int.parse(cnpj[13]) == digit2;
  }

  // Validação de telefone
  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    return phoneRegex.hasMatch(phone);
  }

  // Validação de senha forte
  static bool isStrongPassword(String password) {
    final passwordRegex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }
}