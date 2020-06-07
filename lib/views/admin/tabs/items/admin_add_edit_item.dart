import 'package:sanal_menu/controllers/admin/admin_item_controller.dart';
import 'package:sanal_menu/controllers/admin/admin_controller.dart';
import 'package:sanal_menu/views/shared/constants.dart';
import 'package:sanal_menu/views/shared/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sanal_menu/models/item.dart';
import 'package:provider/provider.dart';
import 'dart:io'; // for File class

/** 
 * UI for both adding and editing item. 
 * Calls addEditItem funtion of AdminItemController on submit.
 * Distinction from adding or editing is made inside addEditItem function based on item existance.
 */

class AdminAddEditItem extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Item item = Provider.of<AdminItemController>(context).item;
    File imageFile = Provider.of<AdminItemController>(context).imageFile;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // HEADER
          Row(
            children: <Widget>[
              // GO BACK BUTTON
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Provider.of<AdminController>(context, listen: false).switchTabBody('Items');
                },
              ),
            ],
          ),
          Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    // NAME
                    TextFormField(
                      initialValue: item != null ? item.name : '',
                      decoration: inputDecoration.copyWith(labelText: "Name"),
                      validator: (val) => val.isEmpty ? 'Obligatory field' : null,
                      onChanged: (val) => Provider.of<AdminItemController>(context, listen: false).setName(val),
                    ),
                    SizedBox(height: 10),

                    // PRICE
                    TextFormField(
                      initialValue: item != null ? item.price.toString() : '',
                      decoration: inputDecoration.copyWith(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                      onChanged: (val) => Provider.of<AdminItemController>(context, listen: false).setPrice(double.parse(val)),
                      // Only numbers can be entered
                    ),

                    SizedBox(height: 10),

                    // DESCRIPTION
                    TextFormField(
                      initialValue: item != null ? item.desc : '',
                      decoration: inputDecoration.copyWith(labelText: 'Description'),
                      keyboardType: TextInputType.text,
                      onChanged: (val) => Provider.of<AdminItemController>(context, listen: false).setDesc(val),
                    ),

                    SizedBox(height: 10),

                    // SELECT PHOTO BUTTON
                    FlatButton(
                      child: imageFile == null ? Text('Select an image') : Text('Select another image'),
                      onPressed: () {
                        Provider.of<AdminItemController>(context, listen: false).pickImage();
                      },
                    ),

                    // PREVIEW
                    (imageFile != null)
                        ? Grid(
                            item: item,
                            isAsset: true,
                            isPreview: true,
                          )
                        : Grid(
                            item: item,
                            isAsset: false,
                            isPreview: true,
                          ),

                    // SUBMIT BUTTON
                    RaisedButton(
                      child: Text('Add', style: Theme.of(context).textTheme.button),
                      onPressed: () async {
                        String result = await Provider.of<AdminItemController>(context, listen: false).addEditItem();
                        // Switch tab body back to list.
                        Provider.of<AdminController>(context, listen: false).switchTabBody('Items');
                        // Display meesage based on result
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(result),
                          backgroundColor: Colors.green,
                        )); // display message about result
                      },
                    ),

                    SizedBox(height: 10),

                    // ERROR DISPLAY
                    Text(
                      Provider.of<AdminItemController>(context, listen: true).error,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
