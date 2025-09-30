import 'package:flutter/material.dart';
import 'package:jx2_grid/components/datagrid.dart';
import 'package:jx2_widgets/components/dialogs/delete.dart';
import 'package:jx2_widgets/components/inputs/buttons/icon_button.dart';
import 'package:jx2_widgets/core/theme.dart';
import 'package:jx_data/jx_data.dart';
import 'base_navigator.dart';
import 'package:jx_utils/logs/jx_log.dart';

class Dbnavigator extends StatelessWidget {
  final Store model;
  final Function()? insertFunc;
  final Function()? editFunc;
  final DataGrid? dataGrid;
  final IconData? custom1Icon;
  final IconData? custom2Icon;
  final Function()? custom1Func;
  final Function()? custom2Func;
  final List<NavBtn> visibleBtn;
  final double iconSize;

  const Dbnavigator(
    this.model, {
    this.insertFunc,
    this.editFunc,
    this.custom1Icon,
    this.custom2Icon,
    this.custom1Func,
    this.custom2Func,
    this.dataGrid,
    this.visibleBtn = completeNavBtn,
    this.iconSize = 32.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    // Se a largura for muito pequena, não renderiza nada
    if (width < hideWidth) {
      return const SizedBox.shrink();
    }

    final btnColor = JxTheme.getColor(JxColor.dbNav).foreground;
    final buttons = <Widget>[];

    // Configuração dos botões
    final buttonConfig = <NavBtn, Map<String, dynamic>>{
      NavBtn.navFirst: {
        'icon': Icon(Icons.first_page, color: btnColor, size: iconSize),
        'tooltip': "first register",
        'onPressed': () {
          model.first(true);
          if (dataGrid != null) dataGrid!.first();
        },
      },
      NavBtn.navPrior: {
        'icon': Icon(Icons.navigate_before, color: btnColor, size: iconSize),
        'tooltip': "Prior register",
        'onPressed': () {
          model.prior(true);
          if (dataGrid != null) dataGrid!.prior();
        },
      },
      NavBtn.navNext: {
        'icon': Icon(Icons.navigate_next, color: btnColor, size: iconSize),
        'tooltip': "Next register",
        'onPressed': () {
          model.next(true);
          if (dataGrid != null) dataGrid!.next();
        },
      },
      NavBtn.navLast: {
        'icon': Icon(Icons.last_page, color: btnColor, size: iconSize),
        'tooltip': "last register",
        'onPressed': () {
          model.last(true);
          if (dataGrid != null) dataGrid!.last();
        },
      },
      NavBtn.navAdd: {
        'icon': Icon(
          Icons.add,
          color: JxTheme.getColor(JxColor.dbNavAdd).foreground,
          size: iconSize,
        ),
        'onPressed': insertFunc ?? () => model.append(),
      },
      NavBtn.navRemove: {
        'icon': Icon(
          Icons.delete,
          color: JxTheme.getColor(JxColor.dbNavRemove).foreground,
          size: iconSize,
        ),
        'onPressed': () async {
          final ok = await deleteDlg(context);
          if (ok) {
            int index = model.recno;
            if (dataGrid != null) {
              index = dataGrid!.currentIndex;
              dataGrid!.removeCurrentRow();
            }
            model.recno = index;
            model.remove();
          }
        },
      },
      NavBtn.navEdit: {
        'icon': Icon(
          Icons.edit,
          color: JxTheme.getColor(JxColor.dbNavEdit).foreground,
          size: iconSize,
        ),
        'onPressed': editFunc ?? () => {},
      },
      NavBtn.navSave: {
        'icon': Icon(
          Icons.save,
          color: JxTheme.getColor(JxColor.dbNavSave).foreground,
          size: iconSize,
        ),
        'onPressed': () => model.updateDataByController(),
      },
      NavBtn.navCancel: {
        'icon': Icon(
          Icons.cancel,
          color: JxTheme.getColor(JxColor.dbNavCancel).foreground,
          size: iconSize,
        ),
        'onPressed': () => model.cancel(),
      },
      NavBtn.navRefresh: {
        'icon': Icon(
          Icons.refresh,
          color: JxTheme.getColor(JxColor.dbNavRefresh).foreground,
          size: iconSize,
        ),
        'onPressed': () async {
          // await model.refresh();
          if (dataGrid != null) await dataGrid!.refreshGrid();
        },
      },
      NavBtn.navCustom1: {
        'icon': Icon(
          custom1Icon ?? Icons.verified,
          color: JxTheme.getColor(JxColor.dbNavCustom1).foreground,
          size: iconSize,
        ),
        'onPressed': custom1Func ?? () => {},
      },
      NavBtn.navCustom2: {
        'icon': Icon(
          custom2Icon ?? Icons.verified,
          color: JxTheme.getColor(JxColor.dbNavCustom2).foreground,
          size: iconSize,
        ),
        'onPressed': custom2Func ?? () => {},
      },
    };

    // Adiciona botões visíveis
    for (final btn in visibleBtn) {
      if (buttonConfig.containsKey(btn)) {
        final config = buttonConfig[btn]!;
        buttons.add(
          JxIconButton(
            icon: config['icon'],
            tooltip: config['tooltip'],
            onPressed: config['onPressed'],
          ),
        );
      }
    }

    // Apenas exibe botões se houver espaço suficiente
    if (buttons.isEmpty) {
      return const SizedBox.shrink();
    }

    // Calcula quantos botões cabem na largura disponível
    const double buttonWidth = 48.0;
    const double spacing = 2.0;
    double availableWidth = width - 32; // Margem de 16px de cada lado
    int maxButtonsCanFit = (availableWidth / (buttonWidth + spacing)).floor();

    JxLog.trace(
      "btn length ${buttons.length} max fit $maxButtonsCanFit width $width minWidth $minWidth",
    );

    if (buttons.length <= maxButtonsCanFit) {
      return BaseDbNavigator(buttons);
    } else {
      // Mostra apenas os primeiros botões que cabem
      List<Widget> visibleButtons = buttons.sublist(0, maxButtonsCanFit);
      return BaseDbNavigator(visibleButtons);
    }
  }
}
