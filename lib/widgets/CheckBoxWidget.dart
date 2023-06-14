import 'package:flutter/material.dart';
import 'package:toptanci_otomasyon/screens/product_add_page.dart';

class CheckBoxWidget extends StatefulWidget {
  const CheckBoxWidget({
    Key? key,
    required this.checkBoxListTileItems,
    required this.list, this.onChanged,
  }) : super(key: key);
  final CheckBoxListTileItems checkBoxListTileItems;
  final List<String> list;
  final void Function(bool?)? onChanged;
  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}
class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        selected: widget.checkBoxListTileItems.isCheck,
        activeColor: Colors.blue,
        title: Text(
          widget.checkBoxListTileItems.value,
          style:const TextStyle(
            fontSize: 15,
          ),
        ),
        value: widget.checkBoxListTileItems.isCheck,
        onChanged: (value) {
          setState(() {
            setState(() {
              widget.checkBoxListTileItems.isCheck = value!;
              if (widget.checkBoxListTileItems.isCheck) {
                widget.list.add(widget.checkBoxListTileItems.value);
              } else {
                widget.list.remove(widget.checkBoxListTileItems.value);
              }
            });
          });
        },
      ),
    );
  }
}
class CheckBoxListTileItems {
  String value;
  bool isCheck;
  CheckBoxListTileItems(this.value, this.isCheck);
  static List<CheckBoxListTileItems> getCategories() {
    return [
      CheckBoxListTileItems('Atıştırmalık', false),
      CheckBoxListTileItems('Dondurma', false),
      CheckBoxListTileItems('Su İçecek', false),
      CheckBoxListTileItems('Süt Ürünleri', false),
      CheckBoxListTileItems('Temel Gıda', false),
      CheckBoxListTileItems('Yiyecek', false),
      CheckBoxListTileItems('Diğer', false),
    ];
  }
}
/**/