import 'package:flutter/material.dart';
import 'package:cs492_hw5/models/pushed_file.dart';

class DetailView extends StatefulWidget{

  static const routeName = 'detailView';

  @override
  _DetailViewState createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView>{

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as PushedFile;
    if(args == null){
      return Center(child: CircularProgressIndicator(),);
    } else{
      print(args.imageUrl);
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Wasteagram"),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //date, image, itemNUm, location
                Text(args.date!, style: TextStyle(fontSize: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 300,
                      height: 300,
                      child: Image.network(args.imageUrl!),
                    )
                  ],
                ),
                Text('${args.numItem!.toString()} items', style: TextStyle(fontSize: 20)),
                Text('Location (${args.latitude!}, ${args.longitude!})'),
              ],
            ),
      );
    }
  }
}