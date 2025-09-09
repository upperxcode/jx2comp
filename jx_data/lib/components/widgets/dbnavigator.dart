import 'package:flutter/material.dart';
import 'package:jx2_grid/components/datagrid.dart';
import 'package:jx2_widgets/components/dialogs/delete.dart';
import 'package:jx2_widgets/components/inputs/buttons/icon_button.dart';
import 'package:jx2_widgets/core/theme.dart';
import 'package:jx_data/jx_data.dart';
import 'base_navigator.dart';

class Dbnavigator extends StatelessWidget {
  final BaseStore model;
  final Function()? insertFunc;
  final Function()? editFunc;
  final DataGrid? dataGrid;
  final IconData? custom1Icon;
  final IconData? custom2Icon;
  final Function()? custom1Func;
  final Function()? custom2Func;
  final List<NavBtn> visibleBtn;

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

    // Botões que podem ser exibidos
    final List<Widget> buttons = [];

    // Calcula o espaço necessário para cada botão com espaçamento real de 2px
    const double buttonWidth = 48.0;
    const double spacing = 2.0;

    // Botões com prioridade alta (primeiro nível)
    if (visibleBtn.contains(NavBtn.navFirst) && width > minWidth) {
      buttons.add(
        JxIconButton(
          icon: Icon(Icons.first_page, color: btnColor, size: 32),
          tooltip: "first register",
          onPressed: () {
            model.first(true);
            if (dataGrid != null) dataGrid!.first();
          },
        ),
      );
    }

    if (visibleBtn.contains(NavBtn.navPrior) && width > minWidth) {
      buttons.add(
        JxIconButton(
          icon: Icon(Icons.navigate_before, color: btnColor, size: 32),
          tooltip: "Prior register",
          onPressed: () {
            model.prior(true);
            if (dataGrid != null) dataGrid!.prior();
          },
        ),
      );
    }

    if (visibleBtn.contains(NavBtn.navNext) && width > minWidth) {
      buttons.add(
        JxIconButton(
          icon: Icon(Icons.navigate_next, color: btnColor, size: 32),
          tooltip: "Next register",
          onPressed: () {
            model.next(true);
            if (dataGrid != null) dataGrid!.next();
          },
        ),
      );
    }

    if (visibleBtn.contains(NavBtn.navLast) && width > minWidth) {
      buttons.add(
        JxIconButton(
          icon: Icon(Icons.last_page, color: btnColor, size: 32),
          tooltip: "last register",
          onPressed: () {
            model.last(true);
            if (dataGrid != null) dataGrid!.last();
          },
        ),
      );
    }

    // Botões de ação
    if (visibleBtn.contains(NavBtn.navAdd)) {
      buttons.add(
        JxIconButton(
          icon: Icon(Icons.add, color: JxTheme.getColor(JxColor.dbNavAdd).foreground, size: 32),
          onPressed: insertFunc ?? () => model.append(),
        ),
      );
    }

    if (visibleBtn.contains(NavBtn.navRemove)) {
      buttons.add(
        JxIconButton(
          icon: Icon(
            Icons.delete,
            color: JxTheme.getColor(JxColor.dbNavRemove).foreground,
            size: 32,
          ),
          onPressed: () async {
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
        ),
      );
    }

    if (visibleBtn.contains(NavBtn.navEdit)) {
      buttons.add(
        JxIconButton(
          icon: Icon(Icons.edit, color: JxTheme.getColor(JxColor.dbNavEdit).foreground, size: 32),
          onPressed: editFunc ?? () => {},
        ),
      );
    }

    if (visibleBtn.contains(NavBtn.navSave)) {
      buttons.add(
        JxIconButton(
          icon: Icon(Icons.save, color: JxTheme.getColor(JxColor.dbNavSave).foreground, size: 32),
          onPressed: () => model.updateDataByController(),
        ),
      );
    }

    if (visibleBtn.contains(NavBtn.navCancel)) {
      buttons.add(
        JxIconButton(
          icon: Icon(
            Icons.cancel,
            color: JxTheme.getColor(JxColor.dbNavCancel).foreground,
            size: 32,
          ),
          onPressed: () => model.cancel(),
        ),
      );
    }

    if (visibleBtn.contains(NavBtn.navRefresh)) {
      buttons.add(
        JxIconButton(
          icon: Icon(
            Icons.refresh,
            color: JxTheme.getColor(JxColor.dbNavRefresh).foreground,
            size: 32,
          ),
          onPressed: () async {
            await model.refresh();
            if (dataGrid != null) dataGrid!.refreshGrid();
          },
        ),
      );
    }

    if (visibleBtn.contains(NavBtn.navCustom1)) {
      buttons.add(
        JxIconButton(
          icon: Icon(
            custom1Icon ?? Icons.verified,
            color: JxTheme.getColor(JxColor.dbNavEdit).foreground,
            size: 32,
          ),
          onPressed: custom1Func ?? () => {},
        ),
      );
    }

    if (visibleBtn.contains(NavBtn.navCustom2)) {
      buttons.add(
        JxIconButton(
          icon: Icon(
            custom2Icon ?? Icons.verified,
            color: JxTheme.getColor(JxColor.dbNavEdit).foreground,
            size: 32,
          ),
          onPressed: custom2Func ?? () => {},
        ),
      );
    }

    // Apenas exibe botões se houver espaço suficiente
    if (buttons.isEmpty) {
      return const SizedBox.shrink();
    }

    // Calcula quantos botões cabem na largura disponível
    double availableWidth = width - 32; // Margem de 16px de cada lado

    // Para cada botão, precisamos de buttonWidth + spacing pixels
    int maxButtonsCanFit = (availableWidth / (buttonWidth + spacing)).floor();

    // Se for possível mostrar todos os botões, mostra todos
    if (buttons.length <= maxButtonsCanFit) {
      return BaseDbNavigator(buttons);
    } else {
      // Mostra apenas os primeiros botões que cabem
      List<Widget> visibleButtons = buttons.sublist(0, maxButtonsCanFit);
      return BaseDbNavigator(visibleButtons);
    }
  }
}
