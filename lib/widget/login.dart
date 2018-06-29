import "dart:async";
import "package:redux/redux.dart";
import "package:flutter_redux/flutter_redux.dart";
import "../store/root_state.dart";
import "../store/action/action.dart";
import "package:flutter/services.dart";
import "package:flutter/material.dart";
import "package:barcode_scan/barcode_scan.dart";

class LoginScene extends StatefulWidget{
  @override
    State<StatefulWidget> createState() {
      return new LoginState();
    }
}

class LoginState extends State<LoginScene>{
  @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text('登陆')
        ),
        body: new StoreConnector<RootState, Function>(
          converter: (Store<RootState> store) {
            return (String accessToken) {
              store.dispatch(new StartLogin(accessToken, () {
                Navigator.of(context).pushNamed("/");
                store.dispatch(new SelectTab(3));
              }));
            };
          },
          builder: (BuildContext context, Function doLogin) {
            return new Center(
              child: new FlatButton.icon(
                icon: new Icon(Icons.drafts),
                label: new Text('扫码登陆'),
                onPressed: () {
                  doLogin(' 01206bae-f6ed-42de-bd0e-3775776deaf9');
                  // _scan(doLogin);
                },
              )
            );
          }
        )
      );
    }

    Future _scan(Function doLogin) async {
      String _errMsg = "";
      try {
        String ret = await BarcodeScanner.scan();
        doLogin(ret);
      } on PlatformException catch(e) {
        if (e.code == BarcodeScanner.CameraAccessDenied) {
          _errMsg = '无法获取相机权限';
        } else {
          _errMsg = "未知错误: $e";
        }
      } on FormatException {
        _errMsg = "用户强制退出";
      } catch(e) {
        _errMsg = "未知错误: $e";
      }
      if (_errMsg != "") {
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text(_errMsg),
        ));
      }
    }
}