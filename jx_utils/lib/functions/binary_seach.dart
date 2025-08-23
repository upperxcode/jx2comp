//
//

int binarySearch<T>(T value, List<dynamic> list, String key) {
  if (list.isEmpty) {
    // Se a lista está vazia, não há nada para procurar.
    return -1;
  }

  int start = 0;
  int end = list.length - 1;
  int middle = start + ((end - start) >> 1); // Utilizando bit shift para evitar overflow

  while (start <= end) {
    var middleValue = list[middle][key];

    if (compareEq(value, middleValue)) {
      // Se o valor no meio é igual ao valor procurado, retorna o índice.
      return middle;
    } else if (compareLess(value, middleValue)) {
      end = middle - 1;
    } else {
      start = middle + 1;
    }

    middle = start + ((end - start) >> 1);
  }

  // Se o loop termina sem encontrar o valor, retorna -1.
  return -1;
}

bool compareLess<T>(T v1, T v2) {
  if (v1 is Comparable<dynamic> && v2 is Comparable<dynamic>) {
    // Ambos os valores são comparáveis, então podemos usar compareTo diretamente.
    return v1.compareTo(v2) < 0;
  } else {
    // Tipos não são comparáveis, lançar uma exceção ou tratar de outra forma.
    throw Exception('Os tipos de dados não são comparáveis: ${v1.runtimeType} e ${v2.runtimeType}');
  }
}

bool compareEq<T>(T v1, T v2) {
  if (v1 is Comparable<dynamic> && v2 is Comparable<dynamic>) {
    // Ambos os valores são comparáveis, então podemos usar compareTo diretamente.
    return v1.compareTo(v2) == 0;
  } else {
    // Tipos não são comparáveis, lançar uma exceção ou tratar de outra forma.
    throw Exception('Os tipos de dados não são comparáveis: ${v1.runtimeType} e ${v2.runtimeType}');
  }
}
