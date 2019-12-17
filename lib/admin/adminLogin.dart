import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:tvs_service/firestore/firestoreMain.dart';
class AdminLogin extends StatefulWidget {
  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final TextEditingController _controllerEmail=TextEditingController();
  final TextEditingController _controllerPassword=TextEditingController();
      final _formKey = GlobalKey<FormState>();
      final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
        bool _loaderState=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall:   _loaderState,
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
                            Navigator.of(context).pushReplacementNamed('/landingPage');
                          },
                      ),

                          SizedBox(
                        height: 20.0,
                      ),
                      _widgetTitleText(
                          'Email (ईमेल ) *', 18.0, Colors.black, FontWeight.normal),
                      _widgetTExtField(_controllerEmail,TextInputType.emailAddress),
                       SizedBox(
                        height: 20.0,
                      ),
                      _widgetTitleText(
                          'Password (संकेतशब्द ) *', 18.0, Colors.black, FontWeight.normal),
                         _widgetTExtField(_controllerPassword,TextInputType.visiblePassword),
                         SizedBox(
                        height: 30.0,
                      ),


                      Center(
                                              child: SizedBox(
                              height: 40.0,
                              child: RaisedButton(
                               
                                elevation: 6.0,
                                color: Colors.blue,
                                child: Text(
                                  "LOG IN",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  // setState(() {
                                  //   _loaderState=true;
                                    
                                  // });

                                  if(_formKey.currentState.validate()){
                                    setState(() {
                                      _loaderState=true;
                                    });
                                    FireStoreFunction().loginUser(email: _controllerEmail.text
                                    ,password: _controllerPassword.text).then((admin){
                                      if(admin!=null){

                                        Navigator.of(context).pushReplacementNamed('/adminHome');

                                        


                                      }
                                      else{

                                        _showSnackbar('Invalid email password');

                                      }

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


   void _showSnackbar(String message) {
    setState(() {
      _loaderState = false;
    });
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    ));
  }
}