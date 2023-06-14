import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toptanci_otomasyon/core/locator.dart';
import 'package:toptanci_otomasyon/models/userModel.dart';
import 'package:toptanci_otomasyon/view_models/settings_view_model.dart';
import 'package:toptanci_otomasyon/widgets/custom_text_field.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required this.user}) : super(key: key);
  final UserModel? user;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController userNameController=TextEditingController();

  TextEditingController addressController=TextEditingController();

  TextEditingController businessNameController=TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.user!=null){
      userNameController.text=widget.user!.userName!;
      addressController.text=widget.user!.address!;
      businessNameController.text=widget.user!.businessName!;
    }

  }
  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    var model=getIt<SettingModel>();

    return (widget.user==null)? Center(child: CircularProgressIndicator(),):
    ChangeNotifierProvider<SettingModel>(
      create: (context) => model,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Consumer<SettingModel>(builder: (context, value, child) => TextButton(onPressed: () {
              value.openEdit();
            }, child:const Text('Düzenle')),)
          ],
          title: Text('Hesabım'),),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(height/25),
            child:
            Consumer<SettingModel>(
              builder: (context, value, child) => Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      (widget.user?.image==null || widget.user!.image!.isEmpty) ? Align(alignment: Alignment.center, child: const Icon(Icons.manage_accounts_sharp,size: 150,)):
                      CircleAvatar(minRadius: height/7,backgroundImage:NetworkImage((value.imageUrl==null)? widget.user!.image!:value.imageUrl!)),
                      value.readOnly? SizedBox.shrink():Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(onPressed: () {
                            model.changePhoto(ImageSource.camera, widget.user!.id!);
                          }, icon: Icon(Icons.camera)),
                          IconButton(onPressed: () {
                            model.changePhoto(ImageSource.gallery, widget.user!.id!);
                          }, icon: Icon(Icons.folder)),
                        ],
                      )
                    ],
                  ),
                  const SpaceSetting(),
                  CustomTextField(
                    textEditingController: userNameController,
                      labelText:'Ad Soyad',readOnly: value.readOnly),
                  const SpaceSetting(),
                  CustomTextField(
                    textEditingController: addressController,
                    labelText: 'Adres',readOnly: value.readOnly,),
                  const SpaceSetting(),
                  CustomTextField(
                    textEditingController: businessNameController,
                      labelText: 'İşletme Adı',readOnly: value.readOnly),
                  const SpaceSetting(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(),
                              primary:Theme.of(context).cardColor,
                              minimumSize: Size(width/2.5, height/18)
                          ),
                          onPressed: () {}, child: Text('İletişim Bilgileri')),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(),
                              primary:Theme.of(context).cardColor,
                              minimumSize: Size(width/2.5, height/18)
                          ),
                          onPressed: () {}, child: Text('Şifre İşlemleri')),
                    ],),
                  const SpaceSetting(),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.indigo,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        minimumSize: Size(width, height/18),
                      ),
                      onPressed: () {
                        UserModel user=widget.user!;
                        model.updateUser(id:widget.user!.id!, userName: userNameController.text, address: addressController.text, businessName: businessNameController.text);
                      }, child: Text('Değişiklikleri Kaydet'))

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SpaceSetting extends StatelessWidget {
  const SpaceSetting({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    return SizedBox(height:height/27,);
  }
}

