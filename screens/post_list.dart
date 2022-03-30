import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:cs492_hw5/models/food.dart';
import 'package:cs492_hw5/models/pushed_file.dart';
import 'package:cs492_hw5/screens/detail_view.dart';
import 'package:cs492_hw5/screens/upload_post.dart';

class PostListScreen extends StatefulWidget{

  static const routeName = '/';

  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen>{

  var postStream = FirebaseFirestore.instance.collection('posts');
  int? itemTotal;

  void initState(){
    super.initState();
    getNum();
  }

  // Get total number of waste item
void getNum() async{
  num totalItem = 0;
  postStream.get().then((QuerySnapshot querySnapshot){
    querySnapshot.docs.forEach((doc){
     totalItem = totalItem + (doc['itemNum']);
    });
  }).then((_)=>
    itemTotal = totalItem.toInt()
  ).then((_) =>
      setState(() {})
  );
}

  @override
  Widget build(BuildContext context){
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Wasteagram - ${itemTotal.toString()}",),
        ),
        body: StreamBuilder(
            stream: postStream.orderBy('date', descending: true).snapshots(),//FirebaseFirestore.instance.collection('posts').orderBy('date', descending: false).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if( itemTotal != null &&
                  snapshot.hasData &&
                  snapshot.data!.docs != null &&
                  snapshot.data!.docs.length > 0){
                return Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index){
                              var post = snapshot.data!.docs[index];
                              Food food = createFood(post);
                              return ListTile(
                                title: Text(DateFormat('EEEE, MMM d, y').format(food.date!)),
                                trailing: Text(food.itemNum.toString(), style: TextStyle(fontSize: 20)),
                                onTap: (){
                                  pushToDetail(food);
                                },);
                            }
                        )
                    ),
                  ],
                );
              } else{
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              }
            }
        ),
        floatingActionButton:
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  fixedSize: const Size(50, 50)
              ),
              onPressed: (){
                pushToUploadForm();
                },
              child: Icon(
                Icons.add_a_photo,
                color: Colors.white,
                size: 25.0,
              )
          ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
  }

  void pushToDetail(foodPost){
    Navigator.pushNamed(
     context, DetailView.routeName,
     arguments:PushedFile(
         foodPost.url,
         foodPost.itemNum,
         foodPost.latitude,
         foodPost.longitude,
         DateFormat('EEEE, MMM d, y').format(foodPost.date!))
    );
  }

  void pushToUploadForm() {
    Navigator.of(context)
        .pushNamed(UploadPost.routeName).then((_) =>getNum());
  }

  Food createFood(DocumentSnapshot food){
    return Food(
      url: food['url'],
      itemNum: food['itemNum'],
      latitude: food['latitude'],
      longitude: food['longitude'],
      date: food['date'].toDate(),
    );
  }
}