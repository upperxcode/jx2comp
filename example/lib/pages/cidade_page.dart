import 'package:example/pages/cidade_controller.dart';
import 'package:example/pages/cidade_data.dart';
import 'package:flutter/material.dart';
import 'package:jx2_grid/components/current_row.dart';
import 'package:jx2_grid/components/datagrid.dart';
import 'package:jx2_grid/components/grid_page.dart';
import 'package:jx2_widgets/components/forms/jx_page.dart';
import 'package:jx2_widgets/core/theme/enums.dart';
import 'package:jx2_widgets/core/theme/jx_theme.dart';

import 'package:jx_data/components/widgets/constants.dart';
import 'package:jx_data/components/widgets/dbnavigator.dart';
import 'package:jx_data/jx_data.dart';

class CidadePage extends Jx2Page {
  CidadePage() : super(Text('Hello World'));

  @override
  State<CidadePage> createState() => _CidadePageState();
}

class _CidadePageState extends State<CidadePage> {
  int counter = 0;

  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return center(counter);
  }
}

Widget center(int value) {
  final store = CidadeController();
  store.dataList = cidades;

  final textStyle = const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold);

  // Define o callback de cor das linhas
  Color rowColorCallback(CurrentRow row) {
    if (row.rowIndex % 2 == 0) {
      return JxTheme.getColor(JxColor.gridEven).background;
    }
    return JxTheme.getColor(JxColor.gridOdd).background;
  }

  return Center(
    widthFactor: 1,
    heightFactor: 1,
    child: FutureBuilder<DataGrid>(
      future: DataGrid.create(store, textStyle: textStyle, rowColorCallback: rowColorCallback),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Carregando grid...'),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text('Erro ao carregar grid: ${snapshot.error}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Força rebuild para tentar novamente
                    (context as Element).markNeedsBuild();
                  },
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
        }

        // DataGrid está pronto para uso
        final dataGrid = snapshot.data!;
        return GridPage(
          dataGrid: dataGrid, // Já resolvido
          dataController: store,
          rowColorCallback: rowColorCallback,
          dbNavigator: Dbnavigator(
            store,
            dataGrid: dataGrid, // Já resolvido
            visibleBtn: gridNavBtn,
            insertFunc: () {},
            editFunc: () {},
          ),
        );
      },
    ),
  );
}
