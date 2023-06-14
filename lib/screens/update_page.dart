import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toptanci_otomasyon/core/locator.dart';
import 'package:toptanci_otomasyon/models/product.dart';
import 'package:toptanci_otomasyon/view_models/update_view_model.dart';
import 'package:toptanci_otomasyon/widgets/CheckBoxWidget.dart';
import 'package:toptanci_otomasyon/widgets/custom_elevated_button.dart';
import 'package:toptanci_otomasyon/widgets/custom_text_field.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  DateTime? dateTime;
  TextEditingController nameController=TextEditingController();
  TextEditingController priceController=TextEditingController();
  TextEditingController stockController=TextEditingController();
  TextEditingController koliController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();
  TextEditingController newPriceController=TextEditingController();

  final List<String> _selectedCategories = [];
  @override
  void initState() {
    super.initState();
    nameController.text=widget.product.name;
    priceController.text=widget.product.price.toString();
    stockController.text=widget.product.stock.toString();
    koliController.text=widget.product.koliAdet.toString();
    descriptionController.text=widget.product.description.toString();
  }
  @override
  Widget build(BuildContext context) {
    var model=getIt<UpdateViewModel>();
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (context) => model,
      child: Scaffold(
        appBar: AppBar(title: const Text('Güncelle')),
        body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      SizedBox(
                        height: 220,
                        child: Consumer<UpdateViewModel>(
                          builder: (context, value, child) => (value.imageUrl==null)? Center(child:(widget.product.photoUrl==null) ? Icon(Icons.add):Image.network(widget.product.photoUrl!),):SizedBox(width: 400,child: Image.network(value.imageUrl!),) ,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(onPressed: () {
                                model.uploadMedia(ImageSource.camera);
                              }, icon:const Icon(Icons.camera)),
                              IconButton(onPressed: () {
                                model.uploadMedia(ImageSource.gallery);
                              },icon: Icon(Icons.folder))
                            ],
                          )
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: SizedBox(
                                    height: 50,
                                    child: TextField(
                                        controller: nameController,
                                        decoration: InputDecoration(
                                            labelText: 'ürün adı',
                                            border: OutlineInputBorder())),
                                    width: 175,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                SizedBox(height: 50,width: 120,child: TextField(
                                  readOnly: true,
                                    controller:priceController,
                                    decoration: InputDecoration(labelText: 'ürün Fiyatı',border: OutlineInputBorder())),),
                                IconButton(onPressed: () {
                                  showDialog(context: context, builder: (context) {

                                    return NewWidget(newPriceController:newPriceController,dateTime: dateTime,);
                                  },);
                                }, icon: Icon(Icons.update),iconSize: 20),
                                Text(newPriceController.text.isEmpty? '' : newPriceController.text,style: TextStyle(fontSize: 10),)
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 0,bottom: 5,top: 15),
                              child: SizedBox(
                                height: 50,
                                child: TextField(
                                    controller: stockController,
                                    decoration: InputDecoration(
                                        labelText: 'Stok adedi',
                                        border: OutlineInputBorder())),
                                width: 175,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 0,top: 5,bottom: 15),
                              child: SizedBox(
                                height: 50,
                                child: TextField(
                                  controller: koliController,
                                    decoration: InputDecoration(
                                        labelText: 'koli adedi',
                                        border: OutlineInputBorder())),
                                width: 175,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Container(
                            height: 250,
                            width: 190,
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(7)),
                                border:
                                Border.all(color: Colors.white30, width: 2)),
                            child: Column(
                              children: [
                                const Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Kategori Seçiniz',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    )),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount:
                                    CheckBoxListTileItems.getCategories()
                                        .length,
                                    itemBuilder: (context, index) {
                                      var category = CheckBoxListTileItems
                                          .getCategories()[index];
                                      return CheckBoxWidget(
                                              checkBoxListTileItems: category,
                                              list: _selectedCategories);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                 Padding(
                  padding:
                  EdgeInsets.only(left: 5, right: 5, bottom: 15, top: height/20),
                  child: SizedBox(
                    height: 60,
                    child: CustomTextField(labelText: 'Ürün Açıklaması',
                      textEditingController: descriptionController,
                    ),
                    width: 385,
                  ),
                ),
                SizedBox(height:height/17,),
                Consumer<UpdateViewModel>(
                  builder: (context, value, child) => value.isComplete ? CustomElevatedButton(
                    onPressed: () {
                      model.updateProduct(
                          Product(
                            howMoneySold: widget.product.howMoneySold,
                            koliAdet: int.parse(koliController.text),
                            description: descriptionController.text,
                              photoUrl:(model.imageUrl==null) ? widget.product.photoUrl:model.imageUrl!,
                          name: nameController.text,
                          price: int.parse(priceController.text),
                          category: _selectedCategories,
                          stock: int.parse(stockController.text))
                          ,widget.product.id!,dateTime,int.tryParse(newPriceController.text));
                          model.deleteMedia(widget.product.photoUrl);
                    },
                    text:'Güncelle',) : const Center(child: CircularProgressIndicator(),
                  ),
                )
              ],
            )),
      ),
    );
  }
}

class NewWidget extends StatefulWidget {
  NewWidget({
    super.key, required this.newPriceController,
    required this.dateTime
  });
  final TextEditingController newPriceController;

  DateTime? dateTime;
  @override
  State<NewWidget> createState() => _NewWidgetState();
}

class _NewWidgetState extends State<NewWidget> {
  DateTime? _dateTime;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceAround,
      title: Text('Fiyat güncelle'),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          ElevatedButton(onPressed: () {
            showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2030)).then((value) {
              setState(() {
                _dateTime=value;
              });
            });
          }, child: Text('Tarih Seçin')),
          Text((_dateTime?.day.toString() ) ?? '...')
        ],),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Yeni fiyat'),
            SizedBox(width: 40,height: 50,child: TextField(controller: widget.newPriceController,))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(onPressed: () {
              setState(() {
                widget.dateTime=_dateTime;
              });
              Navigator.of(context).pop();
            }, child: Text('Kaydet')),
            ElevatedButton(onPressed: () {
              Navigator.of(context).pop();
            }, child: Text('İptal'))
          ],
        )
      ],
    );
  }
}