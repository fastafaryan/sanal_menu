import 'package:flutter/material.dart';
import 'package:sanal_menu/models/item.dart';
import 'package:sanal_menu/views/shared/popup.dart';
import 'package:sanal_menu/views/shared/constants.dart';

class Grid extends StatelessWidget {
  Item item;
  bool isAsset = false; // used to display image as asset while uploading image.
  bool isPreview = false; // used for disabling modifier in admin ui.

  Grid({this.item, this.isAsset, this.isPreview});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // IF ITEM IS NULL SHOW EMPTY CARD. CREATED FOR EMPTY CREATION PAGE PREVIEWS
    if (item == null) {
      return Card(
        child: Container(
          height: 500,
          width: 500,
          child: Center(
            child: Text("Nothing to display."),
          ),
        ),
      );
    }

    return Container(
      height: 500,
      width: 500,
      decoration: BoxDecoration(
        border: Border.all(width: .25, color: Colors.grey),
      ),
      child: FlatButton(
        padding: EdgeInsets.all(0),
        // Display popup on press
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Popup(
                item: item,
                isPreview: isPreview,
              );
            },
          );
        },
        child: GridTile(
          child: Container(
            child: FittedBox(
              fit: BoxFit.fill,
              child: (item.image == null) ? Image.asset('assets/no-preview.png') : (isAsset ? Image.asset(item.image) : Image.network(item.image)),
            ),
          ),
          footer: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                // display name
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                // display price
                Text(
                  item.price.toString() + " TL",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
