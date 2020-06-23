import 'package:sanal_menu/models/device.dart';
import 'package:sanal_menu/models/user.dart';
import 'package:sanal_menu/models/item.dart';
import 'package:sanal_menu/controllers/admin/admin_controller.dart';
import 'package:sanal_menu/views/admin/tabs/devices/admin_device_list.dart';
import 'package:sanal_menu/views/admin/tabs/devices/admin_add_device.dart';
import 'package:sanal_menu/views/admin/tabs/items/admin_add_edit_item.dart';
import 'package:sanal_menu/views/admin/tabs/items/admin_item_list.dart';
import 'package:sanal_menu/views/admin/tabs/users/admin_add_edit_user.dart';
import 'package:sanal_menu/views/admin/tabs/users/admin_user_list.dart';
import 'package:flutter/material.dart';
import 'package:sanal_menu/views/shared/constants.dart';
import 'package:provider/provider.dart';

class AdminHome extends StatelessWidget {

  Stream<List<User>> usersStream = AdminController().users;
  Stream<List<Item>> itemStream = AdminController().items;
  Stream<List<Device>> devicesStream = AdminController().devices;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
          stream: itemStream,
          builder: (context, items) {
            return StreamBuilder(
              stream: usersStream,
              builder: (context, users) {
                return StreamBuilder(
                  stream: devicesStream,
                  builder: (context, devices) {
                    // List of tabs
                    final List<Widget> _children = [
                      // Visible tabs
                      AdminUserList(snapshot: users),
                      AdminItemList(snapshot: items),
                      AdminDeviceList(snapshot: devices),

                      // Hidden tabs
                      AdminAddEditUser(), // index 3
                      AdminAddEditItem(), // index 4
                      AdminAddDevice(), // index 5
                    ];

                    return Scaffold(
                      appBar: appBarAuth(context),
                      body: _children[Provider.of<AdminController>(context).getTabIndex],
                      bottomNavigationBar: BottomNavigationBar(
                        type: BottomNavigationBarType.fixed,
                        onTap: Provider.of<AdminController>(context, listen: false).switchTab,
                        currentIndex: Provider.of<AdminController>(context).getNavBarIndex,
                        items: [
                          BottomNavigationBarItem(
                            icon: new Icon(Icons.people),
                            title: new Text('Users'),
                          ),
                          BottomNavigationBarItem(
                            icon: new Icon(Icons.local_dining),
                            title: new Text('Menu'),
                          ),
                          BottomNavigationBarItem(
                            icon: new Icon(Icons.devices),
                            title: new Text('Devices'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      
  }
}
