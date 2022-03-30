import 'package:flutter/material.dart';
import 'screens/post_list.dart';
import 'screens/upload_post.dart';
import 'screens/detail_view.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<App>{
  @override
  Widget build(BuildContext context) {

    final routes = {
      PostListScreen.routeName: (context) =>PostListScreen(),
      UploadPost.routeName: (context) => UploadPost(),
      DetailView.routeName: (context) => DetailView(),
    };

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: routes,
    );
  }
}
// This widget is the root of your application.
