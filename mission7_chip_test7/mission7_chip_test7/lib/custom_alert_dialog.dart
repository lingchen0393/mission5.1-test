import 'package:flutter/material.dart';
import 'display_tags_page.dart';

class AlertWidget extends Dialog{
  String title = '';
  String message = '';
  String  confirm = '确定';
  VoidCallback  confirmCallback;
  VoidCallback  cancelCallback;

  AlertWidget({this.title,this.message,this.cancelCallback,this.confirmCallback,this.confirm});
  @override
  Widget build(BuildContext context) {

    return Material(
//        type: MaterialType.transparency,
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      child: Center(
        child: Container(
          margin: EdgeInsets.only(left: 40,right: 40),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 16,),
              Text(title,style: TextStyle(color:Colors.white, fontSize: 16,fontWeight: FontWeight.w600)),
              Text(message, style: TextStyle(color: Colors.white)),
              SizedBox(height: 16,),
              Divider(height: 1, color: Colors.white, thickness: 1),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Container(
                          child: FlatButton(
                            child: Text('不保存',style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              Navigator.pop(context);
                              cancelCallback();
                            },
                          ),
                          decoration: BoxDecoration(
                            border: Border(right: BorderSide(width: 1,color: Colors.white)),
                          ),
                        )
                    ),
                    Expanded(
                      flex: 1,
                      child: FlatButton(
                        child: Text(confirm,style: TextStyle(color: Colors.white),),
                        onPressed: (){
                          Navigator.pop(context);
                          confirmCallback();
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
