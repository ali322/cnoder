import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";
import "../common/helper.dart";

class PublishScene extends StatefulWidget{
  @override
    State<StatefulWidget> createState() {
      return new PublishState();
    }
}

class PublishState extends State<PublishScene>{
  String _tag = 'dev';
  final _formKey = GlobalKey<FormState>();

  @override
    Widget build(BuildContext context) {
      final _form = _renderForm(context);
      return new Scaffold(
        backgroundColor: Color(0xFFDEDEDE),
        appBar: new AppBar(
          brightness: Brightness.dark,
          elevation: 0.0,
          title: new Text('新建主题', style: new TextStyle(color: Colors.white, fontSize: 18.0)),
          leading: new IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20.0), onPressed: () {
            Navigator.maybePop(context);
          })
        ),
        body: new Column(
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.symmetric(vertical: 12.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: new BoxDecoration(
                color: Colors.white
              ),
              child: _form
            ),
            new Row(children: <Widget>[
              new Expanded(
                child: new Container(
                  margin: const EdgeInsets.only(top: 12.0),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: new RaisedButton(
                    color: Colors.lightGreen,
                    highlightElevation: 2.0,
                    textColor: Colors.white,
                    onPressed: () {
                     if (_formKey.currentState.validate()) {
                       print('is valid');
                     }
                    },
                    child: new Text('保存', style: new TextStyle(fontSize: 16.0)),
                  ),
                ),
              )
            ])
          ],
        )
      );
    }

    void _showTagPicker(BuildContext context) {
      final _tags = ['dev', 'ask', 'share', 'job'];

      showModalBottomSheet(context: context, builder: (BuildContext context){
        return new Container(
          height: 160.0,
          child: new CupertinoPicker(
          itemExtent: 25.0,
          onSelectedItemChanged: (int i) {
            setState(() {
              _tag = _tags[i];
            });
          },
          children: _tags.map((v) {
            return new Text(tagLabel(v));
          }).toList(),
        ),
        );
      });
    }

    Widget _renderForm(BuildContext context) {
      final theme = Theme.of(context);
      return new Form(
        key: _formKey,
        child: new Column(
          children: <Widget>[
            Theme(
              data: theme.copyWith(primaryColor: Color(0xFFDDDDDD)),
              child: TextFormField(
              autovalidate: true,
              validator: (value) {
                if (value.isEmpty) {
                  return '标题不能为空';
                }
              },
              decoration: new InputDecoration(
                border: const UnderlineInputBorder(borderSide: const BorderSide(width: 5.0)),
                hintText: "请输入标题",
                hintStyle: new TextStyle(color: Color(0xFF666666))
              ),
              ),
            ),
            new GestureDetector(
              onTap: () => _showTagPicker(context),
              child: new Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Text(tagLabel(_tag), style: new TextStyle(fontSize: 16.0)),
                    ),
                    new Icon(Icons.arrow_forward_ios, size: 16.0, color: Color(0xFF666666))
                  ],
                )
              ),
            ),
            new Divider(height: 1.0, color: Color(0xFF666666)),
            new TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return '内容不能为空';
                }
              },
              autovalidate: true,
              maxLines: 10,
              maxLength: 200,
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: "请输入内容",
                hintStyle: new TextStyle(color: Color(0xFF666666))
              ),
            ),
          ],
        )
      );
    }
}