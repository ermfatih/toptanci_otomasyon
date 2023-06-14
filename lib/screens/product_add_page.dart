import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toptanci_otomasyon/core/locator.dart';
import 'package:toptanci_otomasyon/models/product.dart';
import 'package:toptanci_otomasyon/view_models/product_add_page_model.dart';
import 'package:toptanci_otomasyon/widgets/CheckBoxWidget.dart';
import 'package:toptanci_otomasyon/widgets/custom_elevated_button.dart';
import 'package:toptanci_otomasyon/widgets/custom_text_field.dart';

class ProductAddPage extends StatefulWidget {
  const ProductAddPage({Key? key}) : super(key: key);

  @override
  State<ProductAddPage> createState() => _ProductAddPageState();
}

class _ProductAddPageState extends State<ProductAddPage> {
  final GlobalKey<FormState> _key = GlobalKey();
  final List<String> _selectedCategories = [];
  //String? url;

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController categoryController = TextEditingController(text: '');
  TextEditingController koliAdetController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    ProductAddModel model = getIt<ProductAddModel>();
    return ChangeNotifierProvider(
      create: (context) => model,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: const Text('Ürün Ekle')),
          body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                  Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        SizedBox(
                          height: 220,
                          child: Consumer<ProductAddModel>(
                            builder: (context, value, child) => (value.imageUrl==null)? const Placeholder():SizedBox(width: 400,child: Image.network(value.imageUrl!),) ,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(onPressed: () {
                                model.uploadMedia(ImageSource.camera);
                              }, child: Icon(Icons.add)),
                              ElevatedButton(onPressed: () {
                                model.uploadMedia(ImageSource.gallery);
                              },child: Icon(Icons.account_circle))
                            ],
                          )
                        ),
                      ],
                    ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Padding(padding: EdgeInsets.only(top:10),
                                child: SizedBox(
                                  width: 175,
                                  child: CustomTextField(
                                    validator: isEmpty,
                                    textEditingController: nameController,
                                    labelText: 'ürün adı',
                                  ),
                                ),),
                              Padding(
                                padding: EdgeInsets.only(top:20,bottom: 0),
                                child: SizedBox(width: 175,child: CustomTextField(
                                  validator: isEmpty,
                                    textEditingController: priceController,
                                    labelText: 'ürün Fiyatı'
                                ),),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: SizedBox(
                                  width: 175,
                                  child: CustomTextField(
                                    validator: isEmpty,
                                    textEditingController: stockController,
                                      labelText: 'Stok adedi',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: SizedBox(
                                  width: 175,
                                  child: CustomTextField(
                                    validator: isEmpty,
                                      labelText: 'koli adedi',
                                    textEditingController: koliAdetController,),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Container(
                              height: height/2.8,
                              width: width/2.2,
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
                    SizedBox(height: height/20,),
                    Padding(
                      padding:  EdgeInsets.only(top: 0,bottom: height/15),
                      child: SizedBox(
                        width: width,
                        child: CustomTextField(
                          textEditingController: descriptionController, labelText: 'Ürün Açıklaması',),
                      ),
                    ),
                  Consumer<ProductAddModel>(
                    builder: (context, value, child) => value.isComplete
                        ? CustomElevatedButton(
                          onPressed: () {
                            if(_key.currentState?.validate() ?? false){
                              model.addProduct(Product(
                                  howMoneySold: 0,
                                  description: descriptionController.text,
                                  koliAdet: int.parse(koliAdetController.text),
                                  photoUrl:(model.imageUrl==null) ? '':model.imageUrl!,
                                  name: nameController.text,
                                  price: int.parse(priceController.text),
                                  category: _selectedCategories,
                                  stock: int.parse(stockController.text)));
                            }
                      }, text: 'Ekle',) : const Center(child: CircularProgressIndicator(),
                    ),
                  ),

                  ],),
                ),)),
        ),
      ),
    );
  }
}
String? isEmpty(value) {
  if (value?.toString().isEmpty ?? false) {
    return 'bu alan boş geçilemez';
  }
  return null;
}

