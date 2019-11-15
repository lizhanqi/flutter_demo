import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class upData  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //需要构建一个material的部件
    return MaterialApp(
      title: '获取远程数据并解析为模型',
      home: MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  //必须重写该方法 返回state
  @override
  State<StatefulWidget> createState() {
    return MyState();
  }
}
class MyState extends State<MyPage> {
  String ddddd = "点我更新UI";

  String title="数据信息";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: <Widget>[

          Container(
              child: GestureDetector(
                child: Text(ddddd),
//                onTap: fetchPost,
                //刷新界面
//            onTap: fetchPost, //这里需要的是一个方法, 而不是一个方法的返回值
                onTap: (){
                  fetchPost().then((value){
                    String st=value;

                    setState(() {
                      ddddd = value;
                      title="网络信息";
                    });
                  });
                },
              ))
        ],
      ),
    );
  }
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