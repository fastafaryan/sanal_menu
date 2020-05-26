import 'package:sanal_menu/views/shared/modifier.dart';
import 'package:flutter/material.dart';
import 'package:sanal_menu/models/item.dart';

class Popup extends StatelessWidget {
  Item item;
  bool isPreview;
  Popup({this.item, this.isPreview});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 800, minWidth: 600),
          child: Container(
            width: 500,
            height: 900,
            child: ListView(children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                //mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Photo
                  AspectRatio(
                    aspectRatio: 1,
                    child: FittedBox(
                      child: Image.network(item.image),
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 15.0, 0, 0),
                        child: Text(
                          item.name,
                          style: Theme.of(context).textTheme.title
                        ),
                      ),
                    ],
                  ),

                  // Description
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 15.0, 0, 10),
                    child: Text(
                      item.desc != null ? item.desc : 'No description found.',
                      style: Theme.of(context).textTheme.bodyText2
                    ),
                  ),
                  if (!isPreview)
                    Modifier(item: item),
                ],
              ),
            ]),
          ),
        ));
  }
}
