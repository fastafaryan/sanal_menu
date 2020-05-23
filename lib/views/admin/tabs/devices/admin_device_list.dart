import 'package:sanal_menu/views/admin/tabs/devices/admin_edit_device.dart';
import 'package:flutter/material.dart';
import 'package:sanal_menu/views/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:sanal_menu/controllers/admin/admin_controller.dart';

class AdminDeviceList extends StatelessWidget {
  AsyncSnapshot snapshot;
  AdminDeviceList({this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              header1("Devices"),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => Provider.of<AdminController>(context, listen: false).switchTabBody('AddDevice'),
              ),
            ],
          ),
        ),
        (snapshot == null || snapshot.data == null || snapshot.data.length == 0)
            ? Center(
                child: Text('Nothing to display.'),
              )
            : Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, int index) {
                    return Card(
                      color: Colors.white,
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Name: ",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(snapshot.data[index].name),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Device ID: ",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(snapshot.data[index].id),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.delete_outline),
                                  onPressed: () async {
                                    String result =
                                        await AdminController().removeDevice(snapshot.data[index].id); // call addDevice function from controller
                                    Scaffold.of(context).showSnackBar(SnackBar(content: Text(result), backgroundColor: Colors.red[900],)); // display message about result
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  // Display popup on press
                                  onPressed: () async {
                                    final result = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AdminEditDevice(device: snapshot.data[index]);
                                      },
                                    );
                                    if (result != null)
                                      Scaffold.of(context).showSnackBar(SnackBar(content: Text(result))); // display message about result
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
      ],
    );
  }
}
