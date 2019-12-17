import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart' as p;

class AadvertiseMent extends StatefulWidget {
  @override
  _AadvertiseMentState createState() => _AadvertiseMentState();
}

class _AadvertiseMentState extends State<AadvertiseMent> {
  File _image;
  bool _loaderState = false;
   var data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advertisement'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loaderState,
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30.0,
                ),

                _getFireBaseImage(),
                SizedBox(
                  height: 30.0,
                ),
                Center(
                  child: SizedBox(
                    height: 40.0,
                    child: RaisedButton(
                      child: Text('Submit'),
                      elevation: 6.0,
                      color: Colors.blue,
                      onPressed: () {
                        if(data!=null&&data==true){
  if (_image != null) {
                          setState(() {
                            _loaderState = true;
                          });
                          uploadImage().then((imageurl) {
                            if (imageurl != null) {
                              Firestore.instance.collection('advertise').add(
                                  {'image_url': imageurl}).then((onValue) {
                                    setState(() {
                                      _loaderState=false;
                                    });
                                    Navigator.of(context).pop();
                                  });
                            } else {}
                          });
                        }
                        }

                      
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> uploadImage() async {
    String fileName = p.basename(_image.path);
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child(fileName + DateTime.now().millisecondsSinceEpoch.toString());
    StorageUploadTask _uploadTask = ref.putFile(_image);
    var downUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();
    return downUrl.toString();
  }

  _getFireBaseImage() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('advertise').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
          data=snapshot.data.documents.isEmpty;
          //print(data);
         
     
        return snapshot.data.documents.isNotEmpty
            ? Stack(
              
              children: <Widget>[
                Container(
                padding: EdgeInsets.only(top: 18.0),
                 margin: EdgeInsets.only(top: 13.0,right: 8.0),
                child: DottedBorder(
                  color: Colors.blue,
                  borderType: BorderType.RRect,
                  radius: Radius.circular(12),
                  padding: EdgeInsets.all(6),
                  child: Container(
                    width: double.infinity,
                    height: 320.0,
                    child: Image.network(
                      snapshot.data.documents[0].data['image_url'],
                      fit: BoxFit.fill,
                    ),
                  ),
                )),

                Positioned(
                right: 0.0,
                child: GestureDetector(
                onTap: (){
                  setState(() {
                    _loaderState=true;
                  });
                  Firestore.instance.runTransaction((transaction)async{
  DocumentSnapshot snapshots =
                          await transaction.get(snapshot.data.documents[0].reference);

                          await transaction.delete(snapshots.reference).whenComplete((){
FirebaseStorage.instance
                            .getReferenceFromUrl(snapshot.data.documents[0].data['image_url'].toString());
                        Future<StorageReference> _reference = FirebaseStorage
                            .instance
                            .getReferenceFromUrl(snapshot.data.documents[0].data['image_url'].toString());
                        _reference.then((onValue) {
                          onValue.delete();
                          setState(() {
                            _loaderState = false;

                          });
                        });
                          });
                  });
                   
                },
                child: Align(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                    radius: 14.0,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.close, color: Colors.red),
                    ),
                ),
                ),
            ),

              ],
            )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: DottedBorder(
                  color: Colors.blue,
                  borderType: BorderType.RRect,
                  radius: Radius.circular(12),
                  padding: EdgeInsets.all(6),
                  child: Container(
                    width: double.infinity,
                    height: 320.0,
                    child: _image != null
                        ? Image.file(
                            _image,
                            fit: BoxFit.fill,
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.add,
                              size: 40.0,
                              color: Colors.blue,
                            ),
                            onPressed: () async {
                              var image = await ImagePicker.pickImage(
                                  source: ImageSource.gallery);

                              setState(() {
                                _image = image;
                              });
                            },
                          ),
                  ),
                ),
              );
      },
    );
  }
}
