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

  var textStyle = const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold);
  //store.refresh("inicial");

  final grid = DataGrid(
    store,
    rowColorCallback: (CurrentRow row) {
      if (row.rowIndex % 2 == 0) {
        return Colors.blue.withAlpha(10);
      } else {
        return Colors.white;
      }
    },

    textStyle: textStyle,
    darkMode: true,
  );

  return Center(widthFactor: 1, heightFactor: 1, child: Container(child: gridpage(grid, store)));
}

GridPage gridpage(DataGrid grid, Store store) {
  Color rowColorCallback(CurrentRow row) {
    if (row.rowIndex % 2 == 0) {
      return JxTheme.getColor(JxColor.gridEven).background;
    }
    return JxTheme.getColor(JxColor.gridOdd).background;
  }

  return GridPage(
    dataGrid: grid,
    dataController: store,
    rowColorCallback: rowColorCallback,
    dbNavigator: Dbnavigator(
      store,
      dataGrid: grid,
      visibleBtn: gridNavBtn,
      insertFunc: () {},
      editFunc: () {},
    ),
  );
}
