 import 'dart:convert';

import 'package:flutter/material.dart';
//导入网络请求相关的包 
 import 'package:flutter/services.dart';
 import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
 import 'package:http/http.dart' as http;

 /*
  * 生命周期信息以及固定list
  */
 /*
  * 静态组件相当于
  */
 class lifeCycle extends StatelessWidget {
   static const platform = const MethodChannel('app.channel.shared.data');
   @override
   Widget build(BuildContext context) {
     return MaterialApp(
       title: '生命周期信息',
       theme: ThemeData(
         primarySwatch: Colors.blue,
       ),
       home: Scaffold(
         appBar: AppBar(
           title: Text("生命周期信息以及本地列表"),
         ),
         body: Center(child: LifecycleWatcher()),
         //添加一个悬浮按钮，该按钮点击后触发_updateText方法
         floatingActionButton: FloatingActionButton(
           onPressed: _updateText,
           tooltip: 'Goto Next',
           child: Icon(Icons.update),
         ),
       ),
     );
   }
   void _updateText() async{
     await platform.invokeMethod("gotoNext");
   }
 }

 /*
  * 窗口小组件
  */
 class LifecycleWatcher extends StatefulWidget {
   @override
   _LifecycleWatcherState createState() => _LifecycleWatcherState();

 }
 /*
  * 页面具体内容以及生命周期等东西
  *  多重继承了 WidgetsBindingObserver
  */

 class _LifecycleWatcherState extends State<LifecycleWatcher>
     with WidgetsBindingObserver {
   AppLifecycleState _lastLifecycleState;
   //相当于初始化
   @override
   void initState() {
     super.initState();
     Fluttertoast.showToast(msg: "初始化页面");
     //注册应用声明周期监听
     WidgetsBinding.instance.addObserver(this);
   }

   //相当于销毁
   @override
   void dispose() {
     Fluttertoast.showToast(msg: "页面销毁");
     WidgetsBinding.instance.removeObserver(this);
     super.dispose();
   }
   String life="此小部件未观察到任何生命周期更改";
   /*
    * 监听应用声明周期方法
    */
   @override
   void didChangeAppLifecycleState(AppLifecycleState state) {
     print("current state is $state");
     setState(() {
       _lastLifecycleState = state;
       life="当前页面状态"+_lastLifecycleState.toString();
     });
   }
   @override
   Widget build(BuildContext context) {
   return ListView(children: _getListData());

   }
   List <StatelessWidget>  widgets = [];
   Widget getRow(int i) {
     return new GestureDetector(
       child: new Padding(
           padding: new EdgeInsets.all(10.0),
           child: new Text("Row $i")),
       onTap: () {
         setState(() {
           widgets = new List.from(widgets);
           widgets.add(getRow(widgets.length + 1));
           print('row $i');
         });
       },
     );
   }
   _getListData() {
     widgets = [];
     for (int i = 0; i < 10; i++) {
       widgets.add(new GestureDetector(
         child: new Padding(
             padding: new EdgeInsets.all(10.0),
             child: new Text("Row $i")),
         onTap: () {
           Fluttertoast.showToast(msg: "row $i" );
           print('row tapped');
         },
       ));
     }
     return widgets;
   }


   //返回String, 显示到text文本部件上
//调用接口 获取服务端数据
   Future<String> fetchPost() async {
     final response =
     await http.get("https://wanandroid.com/wxarticle/chapters/json");
     final result = response.body;
     print(result);
     return result;
   }

//     if (_lastLifecycleState == null){
//       Fluttertoast.showToast(msg: "AA");
//       return Text('此小部件未观察到任何生命周期更改.',
//           textDirection: TextDirection.ltr);
//     }
//     Fluttertoast.showToast(msg: "这个小部件观察到的最新生命周期状态是 $_lastLifecycleState." );
//     return Text(
//         '这个小部件观察到的最新生命周期状态是: $_lastLifecycleState.',
//         textDirection: TextDirection.ltr);
   }






