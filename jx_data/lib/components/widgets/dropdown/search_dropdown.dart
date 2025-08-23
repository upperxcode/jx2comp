// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:jx2_widgets/components/icons/double_icons_row.dart';
import 'package:jx2_widgets/core/theme.dart';
import 'package:jx_data/components/models/jx_field.dart';
import 'package:jx_data/components/utils/type2icon.dart';

class SearchableDropdown<T> extends StatefulWidget {
  final Map<int, String> items;
  final String Function(T) displayItem;
  final InputDecoration? decoration;
  final TextStyle? style;
  final double height;
  final TextEditingController fieldController;
  final FocusNode focusNode;
  final JxField field;
  final void Function() showModal;

  const SearchableDropdown({
    super.key,
    required this.items,
    required this.displayItem,
    this.decoration,
    this.style,
    this.height = 45,
    required this.fieldController,
    required this.focusNode,
    required this.field,
    required this.showModal,
  });

  @override
  _SearchableDropdownState<T> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  final TextEditingController _textEditingController = TextEditingController();

  OverlayEntry? _overlayEntry;
  List<T> filteredItems = [];
  List<T> items = [];
  late FieldType type;
  bool obscure = false;
  late Icon suffixIcon;
  bool isEmpty = true;
  String? _selectedItem;
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
    final value = widget.fieldController.text;
    _textEditingController.text = widget.items[int.tryParse(value)] ?? "";
    items = widget.items.values.cast<T>().toList();
    filteredItems = items;
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
      setState(() {});
    }
  }

  void _filterItems(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        filteredItems = items;
        _isValid = true;
      } else {
        filteredItems = items
            .where((item) => widget.displayItem(item).toLowerCase().contains(keyword.toLowerCase()))
            .toList();
        _isValid = filteredItems.isNotEmpty;
      }
    });
  }

  void _selectItem(T item) {
    _textEditingController.text = widget.displayItem(item);
    _selectedItem = widget.displayItem(item);
    widget.fieldController.text = _selectedItem ?? "";
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
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);

    print("open");
  }

  void _closeDropdown() {
    print("close close");
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
            log("fechando 2");
            //_closeDropdown();
          },
          child: Material(
            elevation: 4.0,
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: filteredItems.map((item) {
                return ListTile(
                  title: Text(widget.displayItem(item)),
                  onTap: () {
                    _textEditingController.text = widget.displayItem(item);
                    setState(() {
                      _selectedItem = widget.displayItem(item);
                    });
                    widget.focusNode.requestFocus(); // Mantenha o foco no TextField
                    _closeDropdown();
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
      widget.field.controller.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: TextFormField(
        controller: _textEditingController,
        focusNode: widget.focusNode,
        onFieldSubmitted: (value) {
          _closeDropdown();
          log("submite");
        },
        decoration: widget.decoration?.copyWith(
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
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }
}
