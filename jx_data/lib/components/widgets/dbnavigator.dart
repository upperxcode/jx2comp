import 'dart:developer';
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

    // Conta quantos botões estão visíveis atualmente
    int visibleCount = 0;

    // Calcula o espaço necessário para cada botão (considerando tamanho fixo)
    const double buttonWidth = 36.0; // Largura aproximada de um botão
    const double spacing = 2.0; // Espaçamento entre botões

    // Botões que podem ser exibidos
    final List<Widget> buttons = [];

    // Primeiro, contamos quantos botões poderiam ser exibidos com base no espaço disponível
    double availableWidth = width - 32; // Subtrai margem lateral
    int maxButtonsCanShow = (availableWidth / (buttonWidth + spacing)).floor();

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
      visibleCount++;
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
      visibleCount++;
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
      visibleCount++;
    }

    if (visibleBtn.contains(NavBtn.navLast) && width > minWidth) {
      buttons.add(
        JxIconButton(
          icon: Icon(Icons.last_page, color: btnColor, size: 32),
          onPressed: () {
            log("last $dataGrid");
            model.last(true);
            if (dataGrid != null) dataGrid!.last();
          },
        ),
      );
      visibleCount++;
    }

    // Botões de ação
    if (visibleBtn.contains(NavBtn.navAdd)) {
      buttons.add(
        JxIconButton(
          icon: Icon(Icons.add, color: JxTheme.getColor(JxColor.dbNavAdd).foreground, size: 32),
          onPressed: insertFunc ?? () => model.append(),
        ),
      );
      visibleCount++;
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
      visibleCount++;
    }

    if (visibleBtn.contains(NavBtn.navEdit)) {
      buttons.add(
        JxIconButton(
          icon: Icon(Icons.edit, color: JxTheme.getColor(JxColor.dbNavEdit).foreground, size: 32),
          onPressed: editFunc ?? () => {},
        ),
      );
      visibleCount++;
    }

    if (visibleBtn.contains(NavBtn.navSave)) {
      buttons.add(
        JxIconButton(
          icon: Icon(Icons.save, color: JxTheme.getColor(JxColor.dbNavSave).foreground, size: 32),
          onPressed: () => model.updateDataByController(),
        ),
      );
      visibleCount++;
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
      visibleCount++;
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
      visibleCount++;
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
      visibleCount++;
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
      visibleCount++;
    }

    // Apenas exibe botões se houver espaço suficiente
    if (buttons.isEmpty) {
      return const SizedBox.shrink();
    }

    // Se o número de botões visíveis for maior que o máximo permitido, ocultamos os últimos
    List<Widget> finalButtons = buttons;
    if (visibleCount > maxButtonsCanShow && maxButtonsCanShow > 0) {
      finalButtons = buttons.sublist(0, maxButtonsCanShow);
    }

    return BaseDbNavigator(finalButtons);
  }
}
