import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpUser extends StatefulWidget {
  @override
  _SignUpUserState createState() => _SignUpUserState();
}

class _SignUpUserState extends State<SignUpUser> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerSureName = TextEditingController();
  final TextEditingController _controllerContactNo = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    bool _loaderState=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _loaderState,
              child: Container(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
                        child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 3.8,
                  ),
                  InkWell(
                                      child: Center(
                      child: Container(
                        child: SvgPicture.asset(
                          'assets/tvs.svg',
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: double.infinity,
                          allowDrawingOutsideViewBox: true,
                        ),
                      ),
                    ),
                    onTap: (){
                      Navigator.of(context).pushReplacementNamed('/adminLogin');

                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  _widgetTitleText(
                      'Name (नाव ) *', 18.0, Colors.black, FontWeight.normal),
                  _widgetTExtField(_controllerName,TextInputType.text),
                   SizedBox(
                    height: 20.0,
                  ),
                  _widgetTitleText(
                      'Surname (आडनाव ) *', 18.0, Colors.black, FontWeight.normal),
                     _widgetTExtField(_controllerSureName,TextInputType.text),
                      SizedBox(
                    height: 20.0,
                  ),
                    _widgetTitleText(
                      'Contact No (संपर्क) *', 18.0, Colors.black, FontWeight.normal),
                    
                    _widgetTExtField(_controllerContactNo,TextInputType.number),
                 SizedBox(
                    height: 20.0,
                  ),

                      Center(
                                          child: SizedBox(
                          height: 40.0,
                          child: RaisedButton(
                           
                            elevation: 6.0,
                            color: Colors.blue,
                            child: Text(
                              "SUBMIT",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              

                              if(_formKey.currentState.validate()){
                                setState(() {
                                _loaderState=true;
                                
                              });
                                SharedPreferences.getInstance().then((prefs){
                                  prefs.setString('name', _controllerName.text);
                                  prefs.setString('surname', _controllerSureName.text);
                                  prefs.setString('phone', _controllerContactNo.text);

                                }).then((onValue){
                                  Navigator.of(context).pushReplacementNamed('/landingPage');
                                  

                                });
                                
                              }
                            },
                          ),
                        ),
                      ),

                      SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _widgetTitleText(String value, fontSize, colors, fontWeights) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Text(
          value,
          style: TextStyle(
              fontSize: fontSize, fontWeight: fontWeights, color: colors),
        ));
  }

  _widgetTExtField(controllerSet,textType) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        keyboardType: textType,
        validator: (value) {
          if (value.isEmpty) {
            return 'This is a required question';
          }
          return null;
        },
        controller: controllerSet,
        decoration: InputDecoration(hintText: 'Your answer'),
      ),
    );
  }
}
