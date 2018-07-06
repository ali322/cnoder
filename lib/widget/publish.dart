import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";
import "../common/helper.dart";
import "../store/view_model/publish.dart";

class PublishScene extends StatefulWidget{
  final String id;
  final PublishViewModel vm;

  PublishScene({Key key, @required this.vm, this.id = ''}):super(key: key);

  @override
    State<StatefulWidget> createState() {
      return new PublishState();
    }
}

class PublishState extends State<PublishScene>{
  String _tag = 'dev';
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';
  bool _isSubmiting = false;

  @override
    Widget build(BuildContext context) {
      final _form = _renderForm(context);
      return new Scaffold(
        backgroundColor: Color(0xFFDEDEDE),
        appBar: new AppBar(
          brightness: Brightness.dark,
          elevation: 0.0,
          title: new Text(widget.id == '' ? '新建主题' : '编辑主题', style: new TextStyle(color: Colors.white, fontSize: 18.0)),
          leading: new IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20.0), onPressed: () {
            Navigator.maybePop(context);
          })
        ),
        body: widget.id != '' && widget.vm.isLoading ? _renderLoading(context) : new Column(
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.symmetric(vertical: 12.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: new BoxDecoration(
                color: Colors.white
              ),
              child: _form
            ),
            _renderButton(context)
          ],
        )
      );
    }

    Widget _renderLoading(BuildContext context) {
      return new Center(
        child: new CircularProgressIndicator(
          strokeWidth: 2.0
        )
      );
    }

    Widget _renderButton(BuildContext context) {
      return new Builder(
        builder: (BuildContext context) {
          return new Row(children: <Widget>[
            new Expanded(
              child: new Container(
                margin: const EdgeInsets.only(top: 12.0),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: new RaisedButton(
                  color: Colors.lightGreen,
                  highlightElevation: 2.0,
                  textColor: Colors.white,
                  onPressed: _isSubmiting ? null : () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      setState(() {
                        _isSubmiting = true;
                      });
                      widget.vm.createTopic({
                        "id": widget.id,
                        "title": _title,
                        "tag": _tag,
                        "content": _content
                      }, (bool success, String errMsg) {
                          final _successMsg = widget.id == '' ? '创建主题成功' : '编辑主题成功';
                          Scaffold.of(context).showSnackBar(new SnackBar(
                            content: new Text(success ? _successMsg : errMsg),
                          ));
                        setState(() {
                          _isSubmiting = false;
                        });
                      });
                    }
                  },
                  child: new Text('保存', style: new TextStyle(fontSize: 16.0)),
                ),
              ),
            )
          ]);
        }
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
      final topic = widget.vm.topic;
      return new Form(
        key: _formKey,
        child: new Column(
          children: <Widget>[
            Theme(
              data: theme.copyWith(primaryColor: Color(0xFFDDDDDD)),
              child: TextFormField(
                initialValue: topic.title,
                // autovalidate: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return '标题不能为空';
                  }
                },
                onSaved: (value) {
                  setState(() {
                    _title = value;
                  });
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
                      child: new Text(
                        _tag == '' ?  tagLabel(topic.tag) : tagLabel(_tag), 
                        style: new TextStyle(fontSize: 16.0)
                      ),
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
              onSaved: (value) {
                setState(() {
                  _content = value;
                });
              },
              initialValue: topic.content,
              // autovalidate: true,
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