import 'package:flutter/material.dart';
import 'package:flutter_app/listData.dart';

//导入网络请求相关的包
import 'dart:io';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'freshAndLoadMoreData.dart';
import 'freshData.dart';
import 'lifeCycle.dart';
import 'upData.dart';

/*
 * ok网络请求
 */
loadData() async {
  String dataURL = "https://jsonplaceholder.typicode.com/posts";
  http.Response response = await http.get(dataURL);
  taostRes(str: response.body);
}

/*
 *
 * 结果展示
 */
void taostRes({var str: String}) {
  Fluttertoast.showToast(
      msg: str,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

/*
 * 系统自带的HttpClient
 */
void _httpClient() async {
  var httpClient = new HttpClient();
  var request = await httpClient
      .getUrl(Uri.parse("http://www.wanandroid.com/project/list/1/json?cid=1"));
  var response = await request.close();
  //判断是否请求成功
  if (response.statusCode == 200) {
    var json = await response.transform(utf8.decoder).join();
    var jsonObj = jsonDecode(json);
// {data: {curPage: 1, datas: [{apkLink: , audit: 1, author: gs666, chapterId: 294, chapterName: 完整项目, collect: false, courseId: 13, desc: 一个模仿企鹅 FM 界面的Android 应用&mdash;喜马拉雅Kotlin。完全使用 Kotlin 开发。有声资源和播放器由喜马拉雅 SDK 提供。 主要功能：
//    print(jsonObj);
    taostRes(str: jsonObj["data"]["datas"][0]["chapterName"]);

    //解析json，拿到对应的jsonArray数据
  } else {
    taostRes(str: "error");
    print("error");
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter   Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              color: Colors.deepPurpleAccent,
              onPressed: () {
                Navigator.push(context,  MaterialPageRoute(builder: (context) => upData()));
              },
              child: new Text("UI更新"),
            ),
            MaterialButton(
              color: Colors.deepPurpleAccent,
              onPressed: () {
                Fluttertoast.showToast(
                    msg: "中心",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
              child: new Text("Toast"),
            ),
            MaterialButton(
              color: Colors.deepPurpleAccent,
              onPressed: () {
                Navigator.push(context,  MaterialPageRoute(builder: (context) =>  lifeCycle()));
              },
              child: new Text("生命周期"),
            ),

            MaterialButton(
              color: Colors.deepPurpleAccent,
              onPressed: () {
                Navigator.push(context,  MaterialPageRoute(builder: (context) => listData()));
              },
              child: new Text("网络列表数据"),
            ),
            MaterialButton(
              color: Colors.deepPurpleAccent,
              onPressed: () {
                Navigator.push(context,  MaterialPageRoute(builder: (context) => freshData()));
              },
              child: new Text("刷新"),
            ),

            MaterialButton(
              color: Colors.deepPurpleAccent,
              onPressed: () {
                Navigator.push(context,  MaterialPageRoute(builder: (context) => freshAndLoadMoreData()));
              },
              child: new Text("刷新以及加载"),
            ),

            new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    color: Colors.red,
                    onPressed: () {
                      _httpClient();
                    },
                    child: new Text("正常网络请求"),
                  ),
                  MaterialButton(
                    color: Colors.deepPurpleAccent,
                    onPressed: () {
                      loadData();
                    },
                    child: new Text("OK网络"),
                  )
                ]),
            MaterialButton(
              onPressed: _incrementCounter,
              child: new Text("你按了这么多次"),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
