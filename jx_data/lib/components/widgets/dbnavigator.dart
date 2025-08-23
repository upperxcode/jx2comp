import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:jx2_grid/components/datagrid.dart';
import 'package:jx2_widgets/components/dialogs/delete.dart';
import 'package:jx2_widgets/components/inputs/buttons/icon_button.dart';
import 'package:jx2_widgets/core/theme.dart';
import 'package:jx_data/jx_data.dart';

import 'base_navigator.dart';
import 'constants.dart';

class Dbnavigator extends StatelessWidget {
  final BaseStore model;
  final Function()? insertFunc;
  final Function()? editFunc;
  final DataGrid? dataGrid;
  final List<NavBtn> visibleBtn;
  const Dbnavigator(
    this.model, {
    this.insertFunc,
    this.editFunc,
    this.dataGrid,
    this.visibleBtn = completeNavBtn,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final btnColor = JxTheme.getColor(JxColor.dbNav).foreground;
    return width < hideWidth
        ? const Text("dont render Dbnavigator")
        : BaseDbNavigator([
          if (visibleBtn.contains(NavBtn.navFirst) && width > minWidth)
            JxIconButton(
              icon: Icon(Icons.first_page, color: btnColor, size: 32),
              tooltip: "first register",
              onPressed: () {
                model.first(true);
                if (dataGrid != null) dataGrid!.first();
              },
            ),
          if (visibleBtn.contains(NavBtn.navPrior) && width > minWidth)
            JxIconButton(
              icon: Icon(Icons.navigate_before, color: btnColor, size: 32),
              tooltip: "Prior register",
              onPressed: () {
                model.prior(true);
                if (dataGrid != null) dataGrid!.prior();
                //
              },
            ),
          if (visibleBtn.contains(NavBtn.navNext) && width > minWidth)
            JxIconButton(
              icon: Icon(Icons.navigate_next, color: btnColor, size: 32),
              tooltip: "Next register",
              onPressed: () {
                model.next(true);
                if (dataGrid != null) dataGrid!.next();
              },
            ),
          if (visibleBtn.contains(NavBtn.navLast) && width > minWidth)
            JxIconButton(
              icon: Icon(Icons.last_page, color: btnColor, size: 32),
              onPressed: () {
                log("last $dataGrid");
                model.last(true);
                if (dataGrid != null) dataGrid!.last();
              },
            ),
          if (visibleBtn.contains(NavBtn.navAdd))
            JxIconButton(
              icon: Icon(Icons.add, color: JxTheme.getColor(JxColor.dbNavAdd).foreground, size: 32),
              onPressed:
                  insertFunc ??
                  () {
                    model.append();
                  },
            ),
          if (visibleBtn.contains(NavBtn.navRemove))
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
          if (visibleBtn.contains(NavBtn.navEdit))
            JxIconButton(
              icon: Icon(
                Icons.edit,
                color: JxTheme.getColor(JxColor.dbNavEdit).foreground,
                size: 32,
              ),
              onPressed: editFunc ?? () => {},
            ),
          if (visibleBtn.contains(NavBtn.navSave))
            JxIconButton(
              icon: Icon(
                Icons.save,
                color: JxTheme.getColor(JxColor.dbNavSave).foreground,
                size: 32,
              ),
              onPressed: () {
                model.updateDataByController();
              },
            ),
          if (visibleBtn.contains(NavBtn.navCancel))
            JxIconButton(
              icon: Icon(
                Icons.cancel,
                color: JxTheme.getColor(JxColor.dbNavCancel).foreground,
                size: 32,
              ),
              onPressed: () => model.cancel(),
            ),
          if (visibleBtn.contains(NavBtn.navRefresh))
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
        ]);
  }
}
