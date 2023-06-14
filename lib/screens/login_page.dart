import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toptanci_otomasyon/core/locator.dart';
import 'package:toptanci_otomasyon/screens/user_register_page.dart';
import 'package:toptanci_otomasyon/view_models/sign_in_model.dart';
import 'package:toptanci_otomasyon/widgets/custom_elevated_button.dart';
import 'package:toptanci_otomasyon/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late TextEditingController codeController;
  final GlobalKey<FormState> _key = GlobalKey();
  final GlobalKey<FormState> _codeKey= GlobalKey();


  @override
  void initState() {
    codeController=TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var model=getIt<SignInModel>();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider(
      create: (context) => model,
      child: Consumer<SignInModel>(
        builder: (context, value, child) =>Scaffold(
          bottomNavigationBar: BottomAppBar(
              child: SizedBox(
                height: height / 13,
                child: Center(
                    child: TextButton(
                      onPressed: () {
                        showDialog(context: context, builder: (context) {
                          return Form(
                            key: _codeKey,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              title: Text('Kayıt Kodunu Girin !!',maxLines: 1,style: TextStyle(fontSize: width/20)),
                              content: TextFormField(
                                validator: codeValidate,
                                controller: codeController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)
                                  ),
                                  hintText: 'Kodu Giriniz',
                                ),
                              ),
                              actionsAlignment: MainAxisAlignment.spaceEvenly,
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.indigo,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    minimumSize: Size(width/4, height/20)
                                  ),
                                    onPressed: () {
                                      if(_codeKey.currentState?.validate() ?? false){
                                        codeController.text='';
                                        Navigator.pop(context);
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const UserRegisterPage()));
                                      }
                                }, child: Text('Onayla')),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.indigo,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        minimumSize: Size(width/4, height/20)
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }, child: Text('İptal')),
                              ],
                            ),
                          );
                        },);
                        //
                        },
                      child: Text('Hesabın yok mu?  Kayıt Ol'),
                    )),
              )),
          appBar: AppBar(
            title:  Text('Giriş Yap'),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(height/13),
                child:value.busy?const Center(child: CircularProgressIndicator(),):  Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.account_balance_outlined, size: height/5),
                      Space(),
                      CustomTextField(
                        validator: mailValidate,
                        labelText: 'Email',
                        textEditingController: emailController,
                      ),
                      Space(),
                      CustomTextField(
                          validator: passwordValidate,
                          obscureText: true,
                          labelText: 'Şifre',
                          textEditingController: passwordController),
                      Space(),
                      CustomElevatedButton(
                        text: 'Giriş Yap',
                        onPressed: () async{
                          if(_key.currentState?.validate() ?? false){
                            await value.signIn(emailController.text, passwordController.text);
                          }
                      },),
                      TextButton(
                          onPressed: () {}, child: Text('Şifremi unuttum')),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

  }
}

class Space extends StatelessWidget {
  const Space({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    return  SizedBox(
      height: height/30,
    );
  }
}
String? mailValidate(value) {
  if (value?.toString().isEmpty ?? false) {
    return 'bu alan boş geçilemez';
  }
  //return value.toString().contains(RegExp(r'[a,z]')) ? null:'';
  return (value?.toString().contains('@') ?? false)
      ? null
      : 'lütfen mail formatında giriniz ornek@gmail.com';
}
String? passwordValidate(value) {
  if (value?.toString().isEmpty ?? false) {
    return 'bu alan boş geçilemez';
  }
  return (value.toString().length > 5) ? null : 'şifre en az 6 karakter olmalı';
}
String? codeValidate(value) {
  if (value?.toString().isEmpty ?? false) {
    return 'bu alan boş geçilemez';
  }
  //return value.toString().contains(RegExp(r'[a,z]')) ? null:'';
  return (value?.toString().contains('654789') ?? false)
      ? null
      : 'Hatalı Kod';
}