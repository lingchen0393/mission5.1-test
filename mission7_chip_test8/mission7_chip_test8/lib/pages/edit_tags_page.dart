import 'dart:async';

import 'package:mission7chiptest8/src/substring_highlight.dart';
import 'package:flutter/cupertino.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mission7chiptest8/src/chip_data.dart';
import 'package:w_popup_menu/w_popup_menu.dart';
import 'display_tags_page.dart';
import '../main.dart';
import '../src/custom_alert_dialog.dart';


class ChipsEdit extends StatefulWidget {
  final List<String> inputs;
  ChipsEdit({this.inputs});

  @override
  _ChipsEditState createState() => _ChipsEditState();
}

class _ChipsEditState extends State<ChipsEdit> {
  List<AppProfile> tagsPrefix10;
  List<String> chipsInit = [];
  List<String> chipSelected = [];
  TextEditingController _textFieldController = TextEditingController();
  ScrollController _controller = new ScrollController();
  TextEditingValue _editingValue;
  String _textChanged;
  GlobalKey key = new GlobalKey<AutoCompleteTextFieldState<AppProfile>>();
  String selected;
  var _data = ["删除"];

  FocusNode focusNode = new FocusNode();
  FocusNode _keyBoardFocusNode = new FocusNode();
  OverlayEntry overlayEntry;
  LayerLink layerLink = new LayerLink();
  List<AppProfile> _suggestion = []; //推荐列表

  var placeHolder = "\u{2006}";
  ///过滤emoji
  RegExp regexp=RegExp("[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]");

  @override
  void initState() {
    super.initState();
    saveInitChips();
    tagsPrefix10 = tags.sublist(0,9);
    overlayEntry = createSelectPopupWindow();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        _textFieldController.addListener(() {
          if(_textFieldController.text.length != 0 && _textFieldController.text == placeHolder){
            Overlay.of(context).insert(overlayEntry);
          } else {
            overlayEntry.remove();
          }
        });
      } else {
        overlayEntry.remove();
        focusNode.unfocus();
      }
    });
  }

  /// 保存初始化的chips
  void saveInitChips() {
    List<String> chips = widget.inputs;
    chipsInit.addAll(chips);
  }

  @override
  void dispose() {
    focusNode?.dispose();
    //_keyBoardFocusNode?.dispose();
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode()); //点击空白处回收键盘
        overlayEntry.remove(); //点击空白处回收overlay
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0, // 底部透明设置
          title: Text(
              "设置任务标签", style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 19)),
          centerTitle: true,
          /**
           * 关闭/返回键，跳转回选择标签首页面
           */
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.grey[600], size: 28,),
            onPressed: () {
              showGeneralDialog(
                  context: context,
                  pageBuilder: (context, anim1, anim2){},
                  barrierColor: Colors.black54.withOpacity(.4),
                  barrierDismissible: true,
                  barrierLabel: "",
                  transitionDuration: Duration(milliseconds: 125),
                  transitionBuilder: (context, anim1, anim2, child){
                    return Transform.scale(
                      scale: anim1.value,
                      child: Opacity(
                        opacity: anim1.value,
                        child: AlertWidget(
                          title: "温馨提示",
                          message:"是否保存标签编辑？",
                          confirm: "保存",
                          confirmCallback: () async {
                            print(widget.inputs);
                            Navigator.of(context).pop(widget.inputs);
                          },
                          cancelCallback: () async {
                            print(chipsInit);
                            Navigator.of(context).pop(chipsInit);
                          },
                        ),
                      ),
                    );
                  }
              );
            },
          ),

          /**
           * 完成键
           */
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                /**
                 * "保存"键，添加所有新输入的标签到上一页
                 */
                Navigator.pop(context,widget.inputs);
              },
              child:Text(
                "保存",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),

        body: SingleChildScrollView(
          child: Container(
            //padding: EdgeInsets.all(0.0),
            padding: EdgeInsets.only(top: 20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  SizedBox(height: 20),
                  /**
                   * 显示已选中标签,同时可删除，也可搜索&添加
                   */
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                    child: Wrap(
                      spacing: 11.0,
                      runSpacing: 5.0,
                      alignment: WrapAlignment.start,
                      children: buildWrapChildren(),
                    ),
                  ),
                  SizedBox(height: 15),
                  /**
                   * 分界栏
                   */
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[200], width: 5.5)
                    ),
                  ),

                  /**
                   * 展示推荐标签
                   */
                  CompositedTransformTarget(
                    link: layerLink,
                  ),

                  SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                    child: Text(
                      "你也可以选择以下标签",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: 22),

                  /**
                   * 后台返回的前十个标签罗列
                   * InputChip
                   */
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                    child: Wrap(
                      spacing: 11.0,
                      runSpacing: 5.0,
                      children: tagsPrefix10
                          .asMap()
                          .entries
                          .map((entry) {
                        int index = entry.key;
                        return buildInputChip(
                          index: index,
                          label: entry.value,
                        );
                      }).toList(),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  List<Widget> buildWrapChildren() {
    List<Widget> widgets = [];

    EdgeInsets.all(0.0);
    if (widget.inputs != null && widget.inputs.isNotEmpty) {
      widgets = widget.inputs
          .asMap()
          .entries
          .map((entry) {
        return buildSelectedInputChip(
          label: entry.value,
        );
      }).toList();
      /**
       * 选中(包括输入)超过5个标签，flutterToast提示
       */
      if (widgets.length > 5) {
        setState(() {
          showMoreThan5TagsToast();
          widgets.removeLast();
          widget.inputs.removeLast();
        });
      }
    }

    /**
     * 文本框，并在搜索框中出现已选中tag，并可以自编辑tag;
     * ！！！！现换成可自动推荐搜索
     */
    //textEdit.add(replacement);
    Widget inputWidget = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 110,
      ),

      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 7.5),
            child: TextField(
              focusNode: focusNode,
              controller: _textFieldController,
              textAlign: TextAlign.start,
              textInputAction: TextInputAction.done,
              cursorColor: Colors.blue,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.normal
              ),
              cursorWidth: 2.0,
              autofocus: false,
              keyboardType: TextInputType.text,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(8), //最多不能超过8个字符
                BlacklistingTextInputFormatter.singleLineFormatter, //限制单行输入
                BlacklistingTextInputFormatter(RegExp(" ")),//控制空格输入
                BlacklistingTextInputFormatter(regexp)
              ],
              /**
               * 输入背景添加判断
               */
              decoration:
              _textFieldController.text.length == 0
              //textEdit.last == replacement
                  ? InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.only(top: 3,bottom: 8.5),
                  border: InputBorder.none,
                  //hintText: "\u200B",
                  //hintText: placeHolder,
                  hintText: "输入标签",
                  hintStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  )
              )   : InputDecoration(
                filled: true,
                isDense: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.only(left: 12,right: 12,top: 6,bottom: 6),
                border: InputBorder.none,
              ),

              onChanged: (text) {
                setState(() {
                  _textChanged = text;
                  _onTextChanged(text);
                  _textFieldController.text.length != 0 ?  Overlay.of(context).insert(overlayEntry)
                      :  overlayEntry.remove();
                }
                );
              },

              /**
               * 回车返回编辑的标签
               */
              onSubmitted: (text){
                setState(() {
                  //if(_textFieldController.text.length > replacement.length && text != " ")
                  if(_textFieldController.text.length != 0 && text != " ")
                    widget.inputs.add(text.trim());
                  _textFieldController.clear();
                  //_textFieldController.text = replacement;
                });
              },
            ),
          ),
        ],
      ),
    );
    widgets.add(inputWidget);
    return widgets;
  }

  /**
   * 罗列标签（下方）
   */
  Widget buildInputChip({int index, AppProfile label}) {
    bool chipSelectedBottom = widget.inputs.contains(label.tagName);
    return InputChip(
        showCheckmark: false,
        backgroundColor: Colors.grey[200],
        labelStyle: chipSelectedBottom ? TextStyle( fontSize: 17, color: Colors.green, fontStyle: FontStyle.normal)
            : TextStyle( fontSize: 17, color: Colors.black, fontStyle: FontStyle.normal),
        label: Text(
          label.tagName,
        ),
        shape: chipSelectedBottom ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(3),side:BorderSide(color: Colors.green))
            : RoundedRectangleBorder(borderRadius: BorderRadius.circular(3),side:BorderSide(color: Colors.grey[200])),
        padding: EdgeInsets.fromLTRB(6.0, 3.0, 6.0, 3.0),
        selected: chipSelectedBottom,
        selectedColor: Colors.grey[200],
        onSelected: (bool selected) {
          setState(() {
            selected ? widget.inputs.add(label.tagName) : widget.inputs.remove(label.tagName);
          });
        }
    );
  }

  /**
   * 展示所选标签（上方）
   */
  Widget buildSelectedInputChip({String label}) {
    bool chipSelectTop = chipSelected.contains(label);

    return WPopupMenu(
      onValueChanged: (int selected){
        switch (_data[selected]){
          case "删除":
            setState(() {
              widget.inputs.remove(label);
              chipSelected.remove(label);
            });
            break;
        }
      },
      menuWidth: 60,
      pressType: PressType.longPress,
      actions: _data,
      child: InputChip(
        showCheckmark: false,
        backgroundColor: Colors.grey[200],
        labelStyle: TextStyle(fontSize: 17, color: Colors.black, fontStyle: FontStyle.normal),
        label: Text(
          label,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        padding: EdgeInsets.fromLTRB(6.0, 3.0, 6.0, 3.0),
        onSelected:(bool selected){
          setState(() {
            selected ? chipSelected.add(label) : chipSelected.remove(label);
          });
        },
      ),
    );
  }


  /**
   * textfield输入推荐项
   */
  _onTextChanged(String text){
    setState(() {
      _suggestion = tags.where((element) => element.toString().toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  /**
   * 悬浮推荐列表
   */
  OverlayEntry createSelectPopupWindow(){
    OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
      return new Positioned(
        width: MediaQuery.of(context).size.width,
        child: new CompositedTransformFollower(
          offset: Offset(0.0,1),
          link: layerLink,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 550,
            ),
            child: Material(
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 190,
                        //height: _suggestion?.length *56.0 ?? 0,
                        child: new ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          padding: EdgeInsets.all(0.0),
                          itemCount: _suggestion?.length ?? 0,
                          itemBuilder: (BuildContext context, int index){
                            return Container(
                              decoration: BoxDecoration(
                                border: Border(top: BorderSide(width: 1, color: Colors.grey[100]),
                                    bottom: BorderSide(width: 1, color: Colors.grey[100]))),
                              child: ListTile(
                                title: Container(
                                  child: SubstringHighlight(
                                    text: _suggestion[index].tagName,
                                    term: _textFieldController.text,
                                  ),
                                ),
                                leading: Image.asset("assets/icon_tag.png"),
                                onTap: (){
                                  setState(() {
                                    widget.inputs.add(_suggestion[index].tagName);
                                    focusNode.unfocus();
                                    _textFieldController.clear();
                                  });
                                },
                              ),
                            );
                          },
                          //separatorBuilder: (BuildContext context, int index) => Divider(height:1.0,color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
    return overlayEntry;
  }
}

/**
 * 选中超过5个标签，flutterToast提示
 */
void showMoreThan5TagsToast(){
  Fluttertoast.showToast(
    msg: "最多只能添加5个标签",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIos: 1,
    backgroundColor: Colors.black54,
    textColor: Colors.white,
    fontSize: 17.0,
  );
}

