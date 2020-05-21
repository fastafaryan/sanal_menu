import 'package:cloud_firestore/cloud_firestore.dart';

class Device {
  String id;
  String name;
  
  // Constructor
  Device({this.id, this.name});

  // Create class from snapshot
  Device.fromSnapshot(DocumentSnapshot snapshot) {
    Device(
      id: snapshot.data['id'] ?? '',
      name: snapshot.data['name'] ?? '',
    );
  }

  
}
