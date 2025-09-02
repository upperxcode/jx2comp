// arquivo: jx_search_dropdown.dart

import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:jx2_widgets/components/screens/balloon_tooltips.dart';
import 'package:jx2_widgets/components/styles/form_text_style.dart';
import 'package:jx2_widgets/core/theme.dart';
import 'package:jx_data/components/models/jx_field.dart';
import '../field_title.dart';
import '../utils.dart';
import 'search_dropdown.dart';

abstract class Lookup {
  Future<List<Map<String, dynamic>>> loadData();
}

class JxSearchDropdown extends StatefulWidget {
  final JxField field;
  final String label;
  final String selectedItem;
  final FocusNode focusNode;
  final void Function() showModal;

  const JxSearchDropdown({
    super.key,
    required this.field,
    required this.label,
    required this.selectedItem,
    required this.focusNode,
    required this.showModal,
  });

  @override
  State<JxSearchDropdown> createState() => _JxSearchDropdownState();
}

class _JxSearchDropdownState extends State<JxSearchDropdown> {
  late Future<Map<int, String>?> _lookupTableFuture;
  final tipMessage =
      'Click sobre o campo para abrir as opções.\n Use o botão de clear para limpar o campo e mostrar tudo.\n Digite para filtrar os items.\n Os botões de adição só apacerem ao digitar no campo.\n Para adicionar um novo item digitado tecle enter.\n Para fazer update click no icone de update';

  @override
  void initState() {
    super.initState();
    _lookupTableFuture = _loadAndFormatData();
  }

  Future<Map<int, String>?> _loadAndFormatData() async {
    log('Iniciando carregamento de dados para dropDown ${widget.label}');
    try {
      final lookup = widget.field.lookupTable as Lookup?;
      if (lookup == null) {
        log('Aviso: lookupTable é nulo para o campo ${widget.label}');
        return null;
      }

      // Chama o método loadData() da interface Lookup para obter os dados brutos.
      final List<Map<String, dynamic>> rawData = await lookup.loadData();
      log('Dados brutos carregados: ${rawData.length} registros.');

      // Converte a lista de mapas brutos para um formato de lookup.
      final Map<int, String> lookupMap = {};
      for (var item in rawData) {
        // Use 'id' e 'nome' para o mapeamento
        final int id = item['id'];
        final String nome = item['nome'];
        lookupMap[id] = nome;
      }
      log('Mapeamento concluído.');
      return lookupMap;
    } catch (e, stacktrace) {
      log('Erro ao carregar e formatar dados: $e', stackTrace: stacktrace);
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
    return SearchableDropdown<String>(
      showModal: widget.showModal,
      field: widget.field,
      focusNode: widget.focusNode,
      fieldController: widget.field.controller,
      items: lookupData,
      displayItem: (item) => item.toString(),
      height: isMobile ? 60 : 45,
      style: jxFormTextStyle(),
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
      suffixIcon: const Icon(Icons.search, color: Colors.red),
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
