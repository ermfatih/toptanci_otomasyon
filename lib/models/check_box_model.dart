/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckBoxModel extends ChangeNotifier{
  void listeyeEkle(bool? value,CheckBoxListTileItems2 checkBoxListTileItems,List<String> list) {
    checkBoxListTileItems.isCheck = value!;
    if (checkBoxListTileItems.isCheck) {
      list.add(checkBoxListTileItems.value);
    } else {
      list.remove(checkBoxListTileItems.value);
    }
    notifyListeners();
  }
  bool isOpenCategoryList=false;
  void changeCategoryList(){
    isOpenCategoryList=!isOpenCategoryList;
    notifyListeners();
  }
  List<String> selectedCategories = [''];
}
class CheckBoxWidget2 extends StatefulWidget {
  const CheckBoxWidget2({
    Key? key,
    required this.checkBoxListTileItems,
    required this.list,
  }) : super(key: key);
  final CheckBoxListTileItems2 checkBoxListTileItems;
  final List<String> list;
  @override
  State<CheckBoxWidget2> createState() => _CheckBoxWidget2State();
}
class _CheckBoxWidget2State extends State<CheckBoxWidget2> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CheckBoxModel(),
      child: Card(
        child: Consumer<CheckBoxModel>(
          builder: (context, value, child) => CheckboxListTile(
            selected: widget.checkBoxListTileItems.isCheck,
            activeColor: Colors.blue,
            title: Text(
              widget.checkBoxListTileItems.value,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            value: widget.checkBoxListTileItems.isCheck,
            onChanged: (value) {
                setState(() {
                  listeyeEkle(value);
                });
            },
          ),
        ),
      ),
    );
  }
  void listeyeEkle(bool? value) {
    widget.checkBoxListTileItems.isCheck = value!;
    if (widget.checkBoxListTileItems.isCheck) {
      widget.list.add(widget.checkBoxListTileItems.value);
    } else {
      widget.list.remove(widget.checkBoxListTileItems.value);
    }
  }
}
class CheckBoxListTileItems2 {
  String value;
  bool isCheck;
  CheckBoxListTileItems2(this.value, this.isCheck);
  static List<CheckBoxListTileItems2> getCategories() {
    return [
      CheckBoxListTileItems2('Atıştırmalık', false),
      CheckBoxListTileItems2('Dondurma', false),
      CheckBoxListTileItems2('Su İçecek', false),
      CheckBoxListTileItems2('Süt Ürünleri', false),
      CheckBoxListTileItems2('Temel Gıda', false),
      CheckBoxListTileItems2('Yiyecek', false),
      CheckBoxListTileItems2('Diğer', false),
    ];
  }
}*/