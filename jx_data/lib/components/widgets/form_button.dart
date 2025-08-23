import 'package:flutter/material.dart';
import 'package:jx2_grid/components/datagrid.dart';
import 'package:jx2_widgets/components/inputs/buttons/jx_button.dart';
import 'package:jx2_widgets/components/screens/snackbar_message.dart';
import 'package:jx2_widgets/core/theme.dart';
import 'package:jx_data/jx_data.dart';
import 'base_navigator.dart';

class FormButton extends StatelessWidget {
  final BaseStore model;
  final GlobalKey<FormState> formkey;
  final bool? dialog;
  final bool? editMode;
  final DataGrid? dataGrid;

  const FormButton(
    this.model,
    this.formkey, {
    this.dialog = false,
    this.editMode = false,
    this.dataGrid,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BaseDbNavigator(padding: 20.0, [
      JxButton(
        label: "Submit",
        icon: const Icon(Icons.save),
        onPressed: () {
          if (Form.of(context).validate()) {
            snackMessage(context, "Processing Data...", () => {}, 2, SMType.information);

            model.dbStateMode(editMode! ? DbState.update : DbState.insert);
            model.updateDataByController();
            if (dataGrid != null) {
              dataGrid!.updateGrid();
            }

            if (dialog!) Navigator.of(context).pop();
          }
        },
      ),
      JxButton(
        label: "Cancel",
        icon: const Icon(Icons.cancel),
        color: JxColor.warning,
        onPressed: () {
          snackMessage(context, "Canceling...", () => {}, 1, SMType.warning);
          if (!editMode!) {
            model.dbStateMode(DbState.canceling);
          }
          model.updateControllerByData();
          if (dialog!) Navigator.of(context).pop();
        },
      ),
    ], alignment: MainAxisAlignment.spaceAround);
  }
}
