import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanal_menu/controllers/base_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:device_id/device_id.dart';

class AdminController extends BaseController with ChangeNotifier {
  int _tabIndex = 0;
  int _navBarIndex = 0;

  int get getTabIndex => _tabIndex;
  int get getNavBarIndex => _navBarIndex;

  void switchTab(int index) {
    _tabIndex = index;
    _navBarIndex = index;
    notifyListeners();
  }

  void changeTabBody(Widget widget) {}

  void switchTabBody(String tab) {
    int index = 0;
    if (tab == 'Users') index = 0;
    if (tab == 'Items') index = 1;
    if (tab == 'Devices') index = 2;
    if (tab == 'AddEditUser') index = 3;
    if (tab == 'AddEditItem') index = 4;
    if (tab == 'AddDevice') index = 5;
    _tabIndex = index;
    notifyListeners();
  }

  

  // Add a new device record to DB
  Future addDevice(String name) async {
    // get device ID
    String deviceID = await DeviceId.getID;

    // query db if same device record exists
    QuerySnapshot query = await devicesCollection.where('id', isEqualTo: deviceID).getDocuments();

    // check query result and perform action base on that
    if (query.documents.isEmpty) {
      devicesCollection.add({'id': deviceID, 'name': name});
      return {'type': MessageTypes.success, 'message': "Device added."};
    } else {
      return {'type': MessageTypes.error, 'message': "Device already exists."};
    }
  }

  // Deletes device record from DB. Returns display message.
  Future<String> removeDevice(String deviceID) async {
    // get corresponding record in DB
    QuerySnapshot query = await devicesCollection.where('id', isEqualTo: deviceID).getDocuments();
    // check if record exists in DB
    if (query.documents.isEmpty) return "There is no such device.";
    // check if duplicate records exists. This shold not happen. If exists, check insert queries
    if (query.documents.length > 1) return "Duplicate records found.";
    // get document id then use it for deletion.
    String id = query.documents.first.documentID;
    devicesCollection.document(id).delete();
    return "Device removed.";
  }

  // Add a new device record to DB
  Future editDeviceName(String deviceID, String name) async {
    // query db if same device record exists
    QuerySnapshot query = await devicesCollection.where('id', isEqualTo: deviceID).getDocuments();

    // return error message if record does not exist
    if (query.documents.isEmpty) return "Cihaz bulunamadı.";
    if (query.documents.length > 1) return "Birden fazla aynı cihaz tanımlaması bulundu lütfen sistem yöneticiniz ile irtibat kurunuz.";

    // update data
    devicesCollection.document(query.documents.first.documentID).updateData({'name': name});
    return "Kayıt güncellendi.";
  }
}
