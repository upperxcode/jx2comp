import 'package:flutter/material.dart';
import 'package:jx2_grid/components/datagrid.dart';
import 'package:jx2_widgets/components/inputs/buttons/jx_button.dart';
import 'package:jx2_widgets/components/screens/snackbar_message.dart';
import 'package:jx2_widgets/core/theme.dart';
import 'package:jx_data/components/stores/jx_store.dart';
import 'package:jx_utils/logs/jx_log.dart';
import 'base_navigator.dart';

class FormButton extends StatelessWidget {
  final Store model;
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
    return BaseDbNavigator(padding: 5, [
      JxButton(
        label: "Salvar",
        icon: const Icon(Icons.save),

        // Assumindo que sua função snackMessage está disponível (global ou importada)
        // e tem a assinatura:
        // void snackMessage(BuildContext context, String message, Function() onPressed, int durationSeconds, SMType type)
        // E que SMType é um enum como: enum SMType { information, success, error }
        onPressed: () async {
          JxLog.info("JxFormButton onPressed inicio ...");
          // Garante que o formulário é válido antes de prosseguir
          if (Form.of(context).validate()) {
            // 1. Exibir um SnackBar de "Processando dados..."
            // Este SnackBar será substituído pelo de sucesso ou erro mais tarde.
            snackMessage(context, "Processando dados...", () => {}, 1, SMType.information);

            // Flags para controlar o resultado da operação
            bool operationSuccessful = true;
            bool conflictDetected = false;
            bool? saveResult; // Para capturar o resultado do saveRecord (true, false ou null)

            try {
              // 2. Definir o modo do banco de dados (update ou insert)
              model.dbStateMode(editMode! ? DbState.update : DbState.insert);

              // 3. Atualizar os dados do controlador (popula model.recordData)
              await model.updateDataByController();

              // 4. Chamar saveRecord (se não for nulo)
              // O método saveRecord DEVE ser modificado para não chamar fetchData() internamente.
              saveResult = await model.saveRecord.call();
              if (saveResult == false) {
                // Se saveResult é false, houve um conflito de dados
                operationSuccessful = false;
                conflictDetected = true;
              }
              // Se saveResult for null (modo em memória), operationSuccessful permanece true,
              // pois a operação em memória é considerada bem-sucedida.

              // 5. Esconder o SnackBar de "Processando..." antes de mostrar a mensagem final
              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              // 6. Lógica para exibir a mensagem final (erro, conflito ou sucesso)
              if (conflictDetected) {
                snackMessage(
                  context,
                  "Erro! Conflito de dados. Por favor, atualize e tente novamente.",
                  () => {},
                  4,
                  SMType.error,
                );
              } else if (!operationSuccessful) {
                // Esta condição pegaria outros erros se operationSuccessful se tornasse false por outro motivo
                snackMessage(
                  context,
                  "Erro desconhecido ao salvar o registro.",
                  () => {},
                  4,
                  SMType.error,
                );
              } else {
                // Se a operação foi um sucesso (sem conflito e sem outros erros)
                if (dataGrid != null) {
                  // ==========================================================
                  // 7. Se a operação foi um sucesso e há uma grade, busca os dados mais recentes
                  //    e então atualiza a grade. Isso garante a ordem correta.
                  // ==========================================================
                  JxLog.info("dataGrid não nulo, fazendo o fatch");
                  await model
                      .fetchData(); // Busca os dados mais recentes do DB (popula _dataList, chama refresh, etc.)
                  // await dataGrid!.updateGrid();
                  await dataGrid!.refreshGrid();
                  // Atualiza a exibição da grade com os novos dados
                  // ==========================================================
                }
                if (context.mounted) {
                  snackMessage(
                    context,
                    "Registro salvo com sucesso!",
                    () => {},
                    1,
                    SMType.information,
                  );
                }
              }
            } catch (e) {
              // 8. Captura outros erros inesperados durante o processo
              operationSuccessful = false;
              conflictDetected = false; // Não é um conflito, é outro tipo de erro

              if (context.mounted) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();

                snackMessage(context, "Ocorreu um erro inesperado: $e", () => {}, 4, SMType.error);
              }
            }

            // 9. Aguardar um curto período para o SnackBar final ser visível antes de fechar a tela
            await Future.delayed(const Duration(seconds: 1));

            // 10. Fechar a tela condicionalmente:
            //    - context.mounted: Garante que o widget ainda está na árvore (segurança)
            //    - operationSuccessful: Apenas fecha se a operação terminou com sucesso
            //    - dialog!: Apenas fecha se a tela atual é um diálogo que deve ser fechado
            if (context.mounted && operationSuccessful && dialog!) {
              Navigator.of(context).pop();
            }
          }
          JxLog.info("... JxFormButton onPressed final");
        },
      ),
      JxButton(
        label: "Cancelar",
        icon: const Icon(Icons.cancel),
        color: JxColor.warning,
        onPressed: () {
          snackMessage(context, "Cancelando alterações...", () => {}, 1, SMType.warning);
          model.cancel();
          if (dialog!) Navigator.of(context).pop();
        },
      ),
    ], alignment: MainAxisAlignment.spaceAround);
  }
}
