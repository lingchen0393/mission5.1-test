import 'package:flutter/material.dart';
import 'package:mission7chiptest8/pages/edit_tags_page.dart';
import 'package:mission7chiptest8/main.dart';

class ChipChosen extends StatefulWidget {

  @override
  _ChipChosenState createState() => _ChipChosenState();
}

class _ChipChosenState extends State<ChipChosen> {

  List<String> inputs=["要啥自行车"];
  bool isCreater = true;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
          padding: EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 200),
              Divider(),
              Row(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "标签",
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  Spacer(),

                  isCreater
                      ? Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: () async{
                          //  去选择chips页面
                          ChangeValue(context);
                        }
                    ),
                  )
                      : null,
                ],
              ),

              /**
               * 展示选中保存后chips
               */
              Padding(
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(1, 0, 8, 0),
                    child: new ListView(
                      scrollDirection: Axis.horizontal,
                      children: buildWrapChildren(),
                    ),
                  )
              ),
              Divider(),
            ],
          ),

        )
    );
  }

  ChangeValue(BuildContext context) {
    Navigator.push(
        context,
        new MaterialPageRoute(builder: (BuildContext context) => new ChipsEdit(inputs: inputs))
    ).then((value) =>
        setState(() {
          inputs = value;
        }));
  }


  List<Widget> buildWrapChildren() {
    List<Widget> widgets = [];
    EdgeInsets.all(8.0);
    widgets = inputs.map((tag) {
      return Chip(
        label: Text(tag),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3),side: BorderSide(color: Colors.white54, width: 7)),
        padding: EdgeInsets.fromLTRB(6.0, 3.0, 6.0, 3.0),
        backgroundColor: Colors.grey[200],
        labelStyle: TextStyle(fontSize: 17, color: Colors.black, fontStyle: FontStyle.normal),
      );
    }).toList();

    return widgets;
  }
}

