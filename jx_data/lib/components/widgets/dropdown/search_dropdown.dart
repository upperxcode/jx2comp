import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:jx2_widgets/components/icons/double_icons_row.dart';
import 'package:jx2_widgets/core/theme.dart';
import 'package:jx_data/components/models/jx_field.dart';
import 'package:jx_data/components/utils/type2icon.dart';
import 'package:jx_data/jx_data.dart';
import 'package:jx_utils/logs/jx_log.dart';

class SearchableDropdown extends StatefulWidget {
  final Map<int, String> items;
  final InputDecoration? decoration;
  final TextStyle? style;
  final double height;
  final TextEditingController fieldController;
  final FocusNode focusNode;
  final JxField field;
  final void Function() showModal;
  final void Function()? onPrefixIconTap;
  final void Function(String)? onChanged; // Adiciona o callback onChanged

  const SearchableDropdown({
    super.key,
    required this.items,
    this.decoration,
    this.style,
    this.height = 45,
    required this.fieldController,
    required this.focusNode,
    required this.field,
    required this.showModal,
    this.onPrefixIconTap,
    this.onChanged, // Inicializa o callback
  });

  @override
  State<SearchableDropdown> createState() => SearchableDropdownState();
}

class SearchableDropdownState extends State<SearchableDropdown> {
  final TextEditingController _textEditingController = TextEditingController();
  OverlayEntry? _overlayEntry;
  List<MapEntry<int, String>> filteredItems = [];
  late List<MapEntry<int, String>> _allEntries;
  late FieldType type;
  bool obscure = false;
  late Icon suffixIcon;
  bool isEmpty = true;
  String? _selectedItemName;
  int? _selectedItemId;
  bool _isValid = true;

  // Adicione os ícones que estavam faltando
  final visibleIcon = const Icon(Icons.disabled_visible, color: Colors.red);
  final clearIcon = Icon(
    Icons.backspace,
    color: JxTheme.getColor(JxColor.formTextIcon).background,
    size: 24,
  );

  @override
  void initState() {
    super.initState();
    _allEntries = widget.items.entries.toList();

    final value = widget.fieldController.text;
    _textEditingController.text = widget.items[int.tryParse(value)] ?? "";

    filteredItems = _allEntries;

    _textEditingController.addListener(_onTextChanged);
    widget.focusNode.addListener(_onFocusChange);
    type = widget.field.type;
    suffixIcon = obscure ? visibleIcon : clearIcon;
  }

  void _onTextChanged() {
    // Só filtra se o campo estiver com foco
    if (widget.focusNode.hasFocus) {
      _filterItems(_textEditingController.text);
      if (_overlayEntry == null) {
        _openDropdown();
      }
    }
  }

  void _onFocusChange() {
    if (!widget.focusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (!mounted) return;
        _closeDropdown();
        setState(() {});
      });
    } else {
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _filterItems(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        filteredItems = _allEntries;
        _isValid = true;
      } else {
        filteredItems = _allEntries
            .where((entry) => entry.value.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
        _isValid = filteredItems.isNotEmpty;
      }
    });
  }

  void __selectItem(int id, String name) {
    _textEditingController.text = name;
    _selectedItemName = name;
    _selectedItemId = id;
    widget.fieldController.text = id.toString();
    JxLog.info(
      "_selectItem fieldController => ${widget.fieldController.text} selectItem => $_selectedItemName ",
    );
    if (widget.onChanged != null) {
      widget.onChanged!(id.toString());
    }
    _closeDropdown();
    setState(() {});
  }

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _openDropdown();
    } else {
      _closeDropdown();
    }
  }

  void _openDropdown() {
    // Garante que qualquer dropdown aberto seja fechado antes de abrir um novo.
    // Isso evita que múltiplas listas fiquem sobrepostas.
    _closeDropdown();

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (BuildContext context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: size.width,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            JxLog.info("fechando 2");
          },
          child: Material(
            elevation: 4.0,
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: filteredItems.map((entry) {
                return ListTile(
                  shape: Border(
                    bottom: BorderSide(
                      color: JxTheme.getColor(JxColor.modalBorder).foreground,
                      width: 1,
                    ),
                  ),
                  textColor: JxTheme.getColor(JxColor.formTextFace).foreground,
                  title: Text(entry.value),
                  onTap: () {
                    __selectItem(entry.key, entry.value);
                    widget.focusNode.requestFocus();
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  void _clearText() {
    setState(() {
      isEmpty = true;
      _textEditingController.text = '';
    });
  }

  /// Limpa o campo de texto, reseta o filtro para mostrar todos os itens e abre o dropdown.
  void showAllItems() {
    _textEditingController.clear();
    _filterItems(''); // Garante que a lista de itens filtrados seja a lista completa.
    widget.focusNode.requestFocus(); // Pede foco para o campo.
    _openDropdown(); // Abre o dropdown.
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: GestureDetector(
        onDoubleTap: () {
          _textEditingController.clear();
          widget.fieldController.clear();
        },
        child: TextFormField(
          controller: _textEditingController,
          focusNode: widget.focusNode,
          onFieldSubmitted: (value) {
            _closeDropdown();
          },
          decoration: widget.decoration?.copyWith(
            prefixIcon: GestureDetector(
              onTap: widget.onPrefixIconTap,
              child: widget.decoration?.prefixIcon,
            ),
            suffixIcon: widget.field.readOnly
                ? widget.field.icon ?? type2Icon(type)
                : isEmpty
                ? DoubleIconsRow(
                    onTap1: () {},
                    onTap2: () {},
                    icon1:
                        widget.field.icon ??
                        type2Icon(type, JxTheme.getColor(JxColor.formTextIcon).foreground),
                    icon2: null,
                  )
                : DoubleIconsRow(
                    onTap1: _clearText,
                    onTap2: _toggleDropdown,
                    icon1: suffixIcon,
                    icon2: const Icon(Icons.update_sharp, color: Colors.red, size: 24),
                  ),
          ),
          style: widget.style,
          onTap: _toggleDropdown,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    // Remove o listener para evitar memory leaks e chamadas a setState após o dispose.
    widget.focusNode.removeListener(_onFocusChange);
    _overlayEntry?.remove();
    super.dispose();
  }
}
