import "package:flutter/material.dart";
import "dart:async";

class ReplyScene extends StatefulWidget{
  final Function createReply;
  final String id;
  final String replyId;
  final String replyTo;

  ReplyScene({Key key, @required this.createReply, @required this.id, @required this.replyId, @required this.replyTo}):super(key: key);

  @override
    State<StatefulWidget> createState() {
      return new ReplyState();
    }
}

class ReplyState extends State<ReplyScene>{
  final _formKey = GlobalKey<FormState>();
  String _content = '';
  bool _isSubmiting = false;
  Timer _timer;

  @override
    void initState() {
      super.initState();
      if (widget.replyTo != '') {
        _content = '@${widget.replyTo} ';
      }
    }

    @override
      void dispose() {
        super.dispose();
        if (_timer != null) {
          _timer.cancel();
        }
      }

  @override
    Widget build(BuildContext context) {
      return new Scaffold(
        backgroundColor: Color(0xFFDEDEDE),
        appBar: new AppBar(
          brightness: Brightness.dark,
          elevation: 0.0,
          title: new Text(widget.replyTo != '' ? '回复 @${widget.replyTo}' : '添加回复', style: new TextStyle(color: Colors.white, fontSize: 18.0)),
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
              child: _renderForm(context)
            ),
            _renderButton(context)
          ],
        )
      );
    }

    Widget _renderForm(BuildContext context) {
      final _theme = Theme.of(context);
      return new Form(
        key: _formKey,
        child: new Theme(
          data: _theme.copyWith(primaryColor: Color(0xFFDDDDDD)),
          child: new TextFormField(
            initialValue: _content,
            validator: (String value) {
              if (value.isEmpty) {
                return '标题不能为空';
              }
            },
            onSaved: (String value) {
              setState(() {
                _content = value;
              });
            },
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: "请输入回复内容",
              hintStyle: new TextStyle(color: Color(0xFF666666))
            ),
          ),
        )
      );
    }

    Widget _renderButton(BuildContext context) {
      return new Builder(
        builder: (BuildContext context) {
          return new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(top: 12.0),
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: new RaisedButton(
              color: Colors.lightGreen,
              highlightElevation: 2.0,
              textColor: Colors.white,
              onPressed: _isSubmiting ? null : () {
                if (_formKey.currentState.validate() ) {
                  _formKey.currentState.save();
                  setState(() {
                    _isSubmiting = true;
                  });
                  widget.createReply(widget.id, _content, (bool success, String errMsg) {
                    setState(() {
                      _isSubmiting = false;
                    });
                    Scaffold.of(context).showSnackBar(new SnackBar(
                      backgroundColor: success ? Colors.lightGreen : Colors.redAccent,
                      content: new Text(success ? '添加回复成功' : errMsg),
                    ));
                    _timer = new Timer(const Duration(milliseconds: 3000),() {
                      Navigator.of(context).pop();
                    });
                  });
                }
              },
              child: new Text('发布', style: new TextStyle(fontSize: 16.0))
            )
          );
        }
      );
    }
}