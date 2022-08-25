import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;

/*
  I use my plugin to implements gif effect,this plugin can help you to controll gif easily,
  see page to find about usage: (https://github.com/peng8350/flutter_gifimage)
*/
class GifHeader1 extends RefreshIndicator {
  GifHeader1() : super(height: 80.0, refreshStyle: RefreshStyle.Follow);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GifHeader1State();
  }
}

class GifHeader1State extends RefreshIndicatorState<GifHeader1>
    with SingleTickerProviderStateMixin {
  GifController _gifController;

  @override
  void initState() {
    // TODO: implement initState
    // init frame is 2
    _gifController = GifController(
      vsync: this,
      value: 1,
    );
    super.initState();
  }

  @override
  void onModeChange(RefreshStatus mode) {
    // TODO: implement onModeChange
    if (mode == RefreshStatus.refreshing) {
      _gifController.repeat(
          min: 0, max: 29, period: Duration(milliseconds: 500));
    }
    super.onModeChange(mode);
  }

  @override
  Future<void> endRefresh() {
    // TODO: implement endRefresh
    _gifController.value = 30;
    loading.value = true;
    return _gifController.animateTo(59, duration: Duration(milliseconds: 500));
  }

  @override
  void resetValue() {
    // TODO: implement resetValue
    // reset not ok , the plugin need to update lowwer
    _gifController.value = 0;
    super.resetValue();
  }
  final loading = new ValueNotifier(false);
  @override
  Widget buildContent(BuildContext context, RefreshStatus mode) {
    // TODO: implement buildContent
    return ValueListenableBuilder<bool>(
        valueListenable: loading,
        builder: (context, value, child) {
          return !loading.value ?
            GifImage(
      image: AssetImage("assets/volume-colorful.gif"),
      controller: _gifController,
      height: 80.0,
      width: 537.0,
    ):Container(
            height: 80.0,
            width: 537.0,
            child:Image.asset("assets/volume-colorful.gif"),
          );
  });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _gifController.dispose();
    super.dispose();
  }
}
