// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:jx2_widgets/components/screens/balloon_tooltips.dart';
import 'package:jx2_widgets/components/styles/form_text_style.dart';
import 'package:jx2_widgets/core/theme.dart';
import 'package:jx_data/components/models/jx_field.dart';
import 'package:jx_utils/logs/jx_log.dart';

import '../field_title.dart';
import '../utils.dart';
import 'search_dropdown.dart';

class JxSearchDropdown extends StatefulWidget {
  final JxField field;
  final String label;
  final String selectedItem;
  final FocusNode focusNode;
  final void Function() showModal;
  final void Function(String)? onChanged;
  final List<Map<String, dynamic>>? items; // Novo parâmetro opcional

  const JxSearchDropdown({
    super.key,
    required this.field,
    required this.label,
    required this.selectedItem,
    required this.focusNode,
    required this.showModal,
    this.onChanged,
    this.items,
  });

  @override
  State<JxSearchDropdown> createState() => _JxSearchDropdownState();
}

class _JxSearchDropdownState extends State<JxSearchDropdown> {
  late Future<Map<int, String>?> _lookupTableFuture;
  final GlobalKey<SearchableDropdownState> _searchableDropdownKey =
      GlobalKey<SearchableDropdownState>();
  final tipMessage =
      'Click sobre o campo para abrir as opções.\n Use o botão de clear para limpar o campo e mostrar tudo.\n Digite para filtrar os items.\n Os botões de adição só apacerem ao digitar no campo.\n Para adicionar um novo item digitado tecle enter.\n Para fazer update click no icone de update';

  @override
  void initState() {
    super.initState();
    _lookupTableFuture = _loadAndFormatData();
  }

  @override
  void didUpdateWidget(covariant JxSearchDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedItem != oldWidget.selectedItem) {
      // A recriação do widget via ValueKey cuidará da atualização.
      // A lógica complexa aqui não é mais necessária e era a fonte do erro.
    }
  }

  Future<Map<int, String>?> _loadAndFormatData() async {
    JxLog.info('Iniciando carregamento de dados para dropDown ${widget.label}');
    List<Map<String, dynamic>> rawData = [];

    try {
      // Se os itens forem passados diretamente, use-os.
      if (widget.items != null) {
        rawData = widget.items!;
      } else {
        // Caso contrário, use a lógica original do lookupTable.
        final lookup = widget.field.lookupTable;
        if (lookup == null) {
          JxLog.info('Aviso: lookupTable é nulo para o campo ${widget.label}');
          return null;
        }
        rawData = await lookup.loadData();
      }
      JxLog.info('Dados brutos carregados: ${rawData.length} registros.');

      // Converte a lista de mapas brutos para um formato de lookup.
      final Map<int, String> lookupMap = {};
      for (var item in rawData) {
        // Use 'id' e 'nome' para o mapeamento
        final int id = item['id'];
        final String nome = item['nome'];
        lookupMap[id] = nome;
      }
      JxLog.info('Mapeamento concluído.');
      return lookupMap;
    } catch (e, stacktrace) {
      JxLog.info('Erro ao carregar e formatar dados: $e $stacktrace');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildFieldTitle(),
          const SizedBox(height: 5),
          FutureBuilder<Map<int, String>?>(
            future: _lookupTableFuture,
            builder: (BuildContext context, AsyncSnapshot<Map<int, String>?> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('Erro ao carregar os dados: ${snapshot.error}');
                }
                return buildSearchableDropdown(isMobile, snapshot.data ?? const {});
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }

  // Seus outros métodos de build...
  Widget buildFieldTitle() {
    return widget.field.tip.isNotEmpty
        ? Row(
            children: [
              FieldTitle(widget.field.displayName ?? widget.field.name),
              const SizedBox(width: 5),
              BalloonTooltip(message: "${widget.field.tip}$tipMessage"),
            ],
          )
        : FieldTitle(widget.field.displayName ?? widget.field.name);
  }

  Widget buildSearchableDropdown(bool isMobile, Map<int, String> lookupData) {
    return SearchableDropdown(
      // Adicionar uma ValueKey força o Flutter a recriar este widget
      // (e seu estado) sempre que o valor do campo mudar.
      key: _searchableDropdownKey,
      showModal: widget.showModal,
      field: widget.field,
      focusNode: widget.focusNode,
      fieldController: widget.field.controller, // Passa o controller do JxField
      items: lookupData,
      // displayItem: (item) => item.toString(),
      height: isMobile ? 60 : 45,
      style: jxFormTextStyle(),
      onChanged: widget.onChanged,
      decoration: buildInputDecoration(widget.field),
    );
  }

  InputDecoration buildInputDecoration(JxField field) {
    return InputDecoration(
      counter: const Offstage(),
      isDense: true,
      floatingLabelStyle: jxFormTextStyleFloat(),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: jxFormTextStyleLabel(),
      errorStyle: jxErrorStyle(),
      contentPadding: padding(),
      prefixIcon: IconButton(
        icon: const Icon(Icons.list_alt_outlined),
        color: JxTheme.getColor(JxColor.formTextIcon).foreground,
        tooltip: "Mostrar todas as opções",
        onPressed: () {
          _searchableDropdownKey.currentState?.showAllItems();
        },
      ),
      suffixIcon: IconButton(
        icon: const Icon(Icons.search, color: Colors.red),
        onPressed: widget.showModal,
      ),
      filled: true,
      border: jxFormTextBorderStyle(),
      hoverColor: JxTheme.getColor(JxColor.formTextHover).background,
      fillColor: JxTheme.getColor(JxColor.formTextFace).background,
      focusedBorder: jxFormTextBorderStyleFocus(),
      enabledBorder: jxFormTextBorderStyleEnabled(),
      hintText: field.placeholder,
    );
  }
}
