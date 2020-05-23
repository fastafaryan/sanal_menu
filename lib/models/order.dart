import 'package:sanal_menu/controllers/stream_controller.dart';

class Order {
  Order({this.id, this.deviceID, this.itemID, this.quantity, this.status, this.assignnee, this.creationTime}) {
    StreamController().getItemByID(itemID).then((item) {
      this.name = item.name;
    });
  }

  String id;
  String deviceID;
  String itemID;
  int quantity;
  String status;
  String assignnee;
  bool isSelected = false;
  String name = "Unknown";
  DateTime creationTime;

  void toggleSelection() {
    isSelected = !isSelected;
  }

  String getCreationTime() {
    String hour = creationTime.toLocal().hour.toString() + ":" + creationTime.toLocal().minute.toString();
    //String day = creationTime.toLocal().day.toString() + "." + creationTime.toLocal().month.toString() + "." + creationTime.toLocal().year.toString();
    return hour;
  }
}
