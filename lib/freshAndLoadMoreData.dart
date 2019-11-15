import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'HttpUtil.dart';

class freshAndLoadMoreData extends StatefulWidget {
  freshAndLoadMoreData({Key key}) : super(key: key);

  @override
  _PersonalPageState createState() => new _PersonalPageState();
}

class _PersonalPageState extends State<freshAndLoadMoreData> {



  List widgets = [];
  final ScrollController _scrollController = new ScrollController();

  //是否在加载
  bool isLoading = false;

  //是否有更多数据
  bool isHasNoMore = false;

  //当前页
  var currentPage = 0;

  //一页的数据条数
  final int pageSize = 20;

  //这个key用来在不是手动下拉，而是点击某个button或其它操作时，代码直接触发下拉刷新
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<
      RefreshIndicatorState>();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
    loadData(false);
  }

  Widget getItem(int index) {
    print("${index == widgets.length}");
    if (index == widgets.length) {
      if (isHasNoMore) {
        return _buildNoMoreData();
      } else {
        return _buildLoadMoreLoading();
      }
    } else {
      return itemBuilder(context, index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Refresh"),
        ),
        body:

       new Container(child:  new RefreshIndicator(
      color: Colors.white,
      ///GlobalKey，用户外部获取RefreshIndicator的State，做显示刷新
      key: _refreshIndicatorKey,
      onRefresh: refreshHelper,
      child: new ListView.builder(
        ///保持ListView任何情况都能滚动，解决在RefreshIndicator的兼容问题。
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: widgets.length + 1,
        controller: _scrollController,
        itemBuilder: (context, index) {
          return getItem(index);
        },
      ),
    ), color: Colors.white,)  );
  }

  Future<Null> refreshHelper() {
    final Completer<Null> completer = new Completer<Null>();
    //清空数据
    widgets.clear();
    currentPage = 0;
    loadData(false, completer);
    return completer.future;
  }

  //completer可选参数
  void loadData(bool isLoadMore, [Completer completer]) async {
    String url = "http://www.wanandroid.com/article/list/${currentPage}/json?cid=60";
    if (isLoadMore) {
      setState(() => isLoading = true);
    }
    var response = await HttpUtil().get(url,
        startCallBack: () {
          print("开始");
        },
        successCallBack: (var success) {
          print("成功");
          List data  = success["data"]["datas"];

          if (data.length < pageSize) {
            isHasNoMore = true;
          } else {
            isHasNoMore = false;
          }
          if (isLoadMore) {
            setState(() {
              isLoading = false;
              widgets.addAll(data);
            });
          } else {
            setState(() {
              widgets = data;
            });
          }
        },
        errorCallBack: () {
          print("失败");
        });
      completer?.complete();

  }

  Widget itemBuilder(BuildContext context, int index) {
    return new Container(
      color: Colors.white,
      margin: EdgeInsets.all(15.0),

      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          new Text("标题: ${widgets[index]["title"]}",
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.deepPurpleAccent,fontSize: 10),
          ),
          new Text(
            "内容: ${widgets[index]["link"]}", textAlign: TextAlign.start,     style: TextStyle(color: Colors.purpleAccent,fontSize: 10),
          ),
          new Container(
            margin: EdgeInsets.only(top: 10.0),
            child: new Divider(
              height: 2.0,
            ),
          )
        ],
      ),
    );
  }


  void _getMoreData() async {
    if (!isLoading) {
      currentPage++;
      loadData(true);
    }
  }


  Widget _buildLoadMoreLoading() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 0.0,
          child : new Container(color :Colors.white,child: new Row(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SpinKitFadingCircle(
                color: Colors.grey,
                size: 5.0,
              ),
              new Padding(padding: EdgeInsets.only(left: 10)),
              new Text("正在加载更多...", style: TextStyle(color: Colors.blue,fontSize: 20) )
            ],
          ),
        )),
      ),);
  }

  Widget _buildNoMoreData() {
    return new Container(
      margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
      alignment: Alignment.center,
      child: new Text("没有更多数据了",style: TextStyle(color: Colors.amberAccent,fontSize: 20) ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

}