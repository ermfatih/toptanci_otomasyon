import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toptanci_otomasyon/core/locator.dart';
import 'package:toptanci_otomasyon/models/product.dart';
import 'package:toptanci_otomasyon/screens/product_add_page.dart';
import 'package:toptanci_otomasyon/screens/update_page.dart';
import 'package:toptanci_otomasyon/view_models/product_model.dart';


class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  TextEditingController searchEditingController=TextEditingController();
  TextEditingController minController=TextEditingController();
  TextEditingController maxController=TextEditingController();


  String find='';
  double? max;
  double? min;
  double minv=0;
  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    var model=getIt<ProductModel>();
    return ChangeNotifierProvider(
      create: (context) => model,
      child: Scaffold(
        endDrawer: Drawer(
          width: 200,
          child: ListView(
            children: [
              AppBar(
                title: Text('Filtrele'),
                actions: const[
                  SizedBox.shrink()
              ],),
              Consumer<ProductModel>(builder: (context, value, child) => ElevatedButton.icon(
                  label:Icon(value.isOpenPriceList? Icons.arrow_drop_up:Icons.arrow_drop_down),
                  onPressed: () {
                    value.changePriceList();
                  }, icon:const Text('Fiyat') ),),

              Consumer<ProductModel>(builder: (context, value, child) => Container(height: value.isOpenPriceList ? 200:0,color: Colors.transparent,
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text('Min'),
                        SizedBox(width: 100,child: TextField(
                          onChanged: (values) {
                            setState(() {
                              min=double.tryParse(values);
                            });
                          },
                        )),
                      ],
                    ),

                  ],
                ),
              ),),
              Consumer<ProductModel>(builder: (context, value, child) => ElevatedButton.icon(
                  label:Icon(value.isOpenCategoryList? Icons.arrow_drop_up:Icons.arrow_drop_down) ,
                  onPressed: () {
                    value.changeCategoryList();
                  }, icon:const Text('Kategori') ),),

              Consumer<ProductModel>(builder: (context, value, child) => Container(
                decoration: BoxDecoration(border: Border.all(width: 2,color: Colors.white54)),
                  height: value.isOpenCategoryList ? 300:0,child: ListView.builder(
                  itemCount: value.kategoriler.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: CheckboxListTile(
                        selected: value.kategoriler.values.elementAt(index),
                        activeColor: Colors.blue,
                        title: Text(
                          value.kategoriler.keys.elementAt(index),
                          style:const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        value: value.kategoriler.values.elementAt(index),
                        onChanged: (newBool) {
                          value.changeCategoryMap(index, newBool!);
                          },
                      ),
                    );
                  },)),),

            ],
          ),
        ),
          bottomNavigationBar: BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8,bottom: 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        minimumSize: Size(width, 50),
                        primary: Colors.indigo
                      ),
                        onPressed: () {model.navigatorService.navigateTo(const ProductAddPage());},
                        child:const Text('Ürün Ekle')),
                  )],)),
          appBar: AppBar(
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.filter_alt),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              ),
            ],
            title: TextFormField(
              decoration:const InputDecoration(prefixIcon: Icon(Icons.find_replace)),
              onChanged: (value) {
                setState(() {
                  find=value;
                });
              },
            ),
            leading: IconButton(onPressed: () {
              Navigator.pop(context);
            },icon:const Icon(Icons.arrow_back)),
          ),
          body: ChangeNotifierProvider(
            create: (context) => model,
            child: Consumer<ProductModel>(
              builder: (context, value, child) => StreamBuilder<QuerySnapshot>(
                  stream:value.getSnapshotsBy(list: value.selectedCategories,name: find,min:min),
                  builder: (context, snapshot) {
                    if(snapshot.hasError) return const Text('bir problem var');
                    if(!snapshot.hasData) return const Center(child:  Text('yükleniyor...'));
                    List<Product> list=snapshot.data!.docs.map((e) => Product.fromSnapshot(e)).toList();
                    return ListView.builder(
                      itemCount:list.length ,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: (list[index].photoUrl==null)? const Icon(Icons.add): CircleAvatar(backgroundImage: NetworkImage(list[index].photoUrl!),),
                            title: Text(list[index].name),
                            trailing: Consumer<ProductModel>(
                              builder: (context, value, child) => Container(color: Colors.transparent,width: 190,child: Row(children: [
                                ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.indigo
                                    ),
                                    onPressed: () {
                                      showDialog(context: context, builder: (context) {
                                        return AlertDialog(
                                          title: Text('Uyarı !'),
                                          content: Text('Silmek istediğinize emin misiniz?'),
                                          actions: [
                                            ElevatedButton(onPressed: (){
                                              value.deleteProduct(list[index]);
                                            }, child: Text('Evet')),
                                            ElevatedButton(onPressed: () {
                                              Navigator.pop(context);
                                            }, child: Text('Hayır'))
                                          ],
                                        );
                                      },);
                                    }, label: Text('sil'),icon:const Icon(Icons.delete)),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.indigo
                                    ),
                                    onPressed: () {
                                      model.navigatorService.navigateTo(UpdatePage(product: list[index]));
                                    }, label:const Text('güncelle',style: TextStyle(fontSize: 12)),icon:const Icon(Icons.update),),
                                )
                              ]),),
                            ),
                            subtitle: Text(list[index].description),
                          ),
                        );
                      },);
                  }
              ),
            ),
          )
      ),
    );
  }
}

class CustomSlider extends StatefulWidget {
  CustomSlider({
    Key? key, required this.value, required this.min, required this.max,
  }) : super(key: key);
  double value;
  final double? min;
  final double? max;
  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  @override
  Widget build(BuildContext context) {
    return Slider(
      divisions: 10,
      autofocus: true,
      activeColor: Colors.indigo,
      thumbColor: Colors.red,
      onChangeEnd: (value) {
      },
      value: widget.value,
      onChanged: (value) {
        setState(() {
          widget.value=value;
          print(widget.value);
        });
      },
      label:widget.value.toString(),
      min: widget.min ?? 0,
      max: widget.max ?? 1000,
    );
  }
}
