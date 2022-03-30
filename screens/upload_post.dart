import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:location/location.dart';

class UploadPost extends StatefulWidget{

  const UploadPost({Key? key}) : super(key: key);
  static const routeName = 'uploadPost';

  @override
  _UploadPostState createState() => _UploadPostState();
}

class _UploadPostState extends State<UploadPost>{
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  LocationData? locationData;

  late FocusNode myFocusNode;
  bool isTapped = true;         //image animator trigger
  File? image;
  String? url;
  DateTime? dateTime;
  int? itemNum;

  @override
  void initState(){
    super.initState();
    getImage();
    retrieveLocation();
  }

  void retrieveLocation() async {
    var locationService = Location();
    locationData = await locationService.getLocation();
    setState(() {});
  }

  Future getImage() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    image = File(pickedFile!.path);

    var fileName = DateTime.now().toString() + '.jpg';
    Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = storageReference.putFile(image!);
    await uploadTask;
    url = await storageReference.getDownloadURL();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if(image == null && url == null){
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("New Post"),
    ),
          body:Column(
              children: [
                AnimatedContainer(
                  height: isTapped ? 300.0 : 200.0,
                  width: isTapped ? 300.0: 200.0,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.fastOutSlowIn,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(image!),
                      fit: BoxFit.cover
                    )
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Form(
                      key: _formKey,
                      child:  Focus(
                        child: TextFormField(
                            autofocus: false,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                          labelText: 'Number of Wasted Items',
                                          alignLabelWithHint: true,
                                        ),
                            onSaved: (value) {
                              itemNum = int.parse(value!);
                            },
                            validator: (value){
                              int numValue = int.parse(value!);
                              if (numValue is! int || value == null || value.isEmpty) {
                                return "Please enter a valid number input";
                              }
                              else{
                                return null;
                              }
                            }
                        ),
                        onFocusChange: (hasFocus){
                          if(hasFocus){
                            setState(() {
                              isTapped = false;
                            });
                          } else{
                            setState(() {
                              isTapped = true;
                            });
                          }
                        },),
                    )
                ),
              ],
          ),
          bottomNavigationBar: Container(
            child: ElevatedButton(
              onPressed: (){
                if(_formKey.currentState!.validate()){
                  _formKey.currentState!.save();
                }
                addDateToDataEntry();
                upLoadData();
                backPage();
              },
              child: Icon(
                Icons.cloud_upload,
                color: Colors.white,
                size: 80.0,
              ),
            )
          ),
      );
    }
  }

  void addDateToDataEntry() {
    dateTime = DateTime.now();
  }

  void upLoadData(){
    FirebaseFirestore.instance
        .collection('posts')
        .add({
            'date': dateTime,
            'itemNum': itemNum,
            'url': url,
            'latitude': locationData!.latitude,
            'longitude': locationData!.longitude,
        });
  }

  void backPage(){
    Navigator.pop(context);
  }
}