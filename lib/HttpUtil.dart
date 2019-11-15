import 'dart:convert';
import 'dart:io';

class HttpUtil{
    Future get(String url, {  Function startCallBack, Function successCallBack , Function errorCallBack}) async {
  var httpClient = new HttpClient();
  var request = await httpClient
      .getUrl(Uri.parse(url));
  var response = await request.close();
  //判断是否请求成功
  if (response.statusCode == 200) {
  var json = await response.transform(utf8.decoder).join();
  var jsonObj = jsonDecode(json);
  successCallBack(jsonObj);
  return jsonObj;
// {data: {curPage: 1, datas: [{apkLink: , audit: 1, author: gs666, chapterId: 294, chapterName: 完整项目, collect: false, courseId: 13, desc: 一个模仿企鹅 FM 界面的Android 应用&mdash;喜马拉雅Kotlin。完全使用 Kotlin 开发。有声资源和播放器由喜马拉雅 SDK 提供。 主要功能：
//    print(jsonObj);


  //解析json，拿到对应的jsonArray数据
  } else {

  print("error");
  }
 return null;
  }

}