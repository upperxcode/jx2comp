import 'package:flutter/material.dart';

import '../../components/button/jx2button.dart';

class ButtonPage extends StatelessWidget {
  const ButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Welcome to the Button Example Page'),
          SizedBox(height: 30),
          Jx2ElevatedButton(
            text: 'Primário',
            icon: Icons.access_alarm,
            onPressed: () {},
          ),
          SizedBox(height: 20),
          circularbuttonOrage(),
          SizedBox(height: 20),

          const SizedBox(height: 16),
          Jx2OutlinedButton(
            text: 'Outlined',
            type: Jx2ButtonType.success,
            icon: Icons.add,
            onPressed: () {},
          ),
          SizedBox(height: 20),

          Jx2CircularButton(
            icon: Icons.add,
            onPressed: () {
              print('Botão circular pressionado!');
            },
            enabled: false, // Desabilita o botão
          ),
          SizedBox(height: 20),
          const SizedBox(height: 16),
          Jx2TextButton(
            text: 'Texto',
            type: Jx2ButtonType.danger,
            onPressed: () {},
          ),
          SizedBox(height: 20),
          cirularButtonPressionado(),
          SizedBox(height: 40),
          floatButton(),
        ],
      ),
    );
  }
}

Widget floatButton() {
  return Jx2FloatingButton(
    icon: Icons.add,
    type: Jx2ButtonType.primary,
    onPressed: () {
      // ignore: avoid_print
      print('Botão flutuante pressionado!');
    },

    tooltip: 'Adicionar',
  );
}

Widget cirularButtonPressionado() {
  return Jx2CircularButton(
    icon: Icons.add,
    size: 64.0,
    isLoading: true,

    /// Tamanho personalizado
    onPressed: () {
      print('Botão circular grande pressionado!');
    },
  );
}

Widget circularbuttonOrage() {
  return Jx2CircularButton(
    icon: Icons.edit,
    backgroundColor: Colors.orange, // Cor de fundo personalizada
    foregroundColor: Colors.black, // Cor do ícone personalizada
    onPressed: () {
      print('Botão circular personalizado pressionado!');
    },
  );
}
