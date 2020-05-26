import 'package:sanal_menu/models/order.dart';
import 'package:device_id/device_id.dart';

class CustomerController {
  Future addToCart(String itemID) async {
    // Create an instance for Order which will be added to cart.
    Order order = Order(
      deviceID: await DeviceId.getID,
      itemID: itemID,
      quantity: 1,
      status: 'InCart',
    );
    order.insert();
  }

  // MODIFY ORDER QUANTITY
  void modifyOrder(Order order, int quantity) {
    if (quantity == 0) {
      deleteOrder(order);
    } else {
      order.setQuantity(quantity);
      order.update();
    }
  }

  // CHECK ORDER STATUS AND IF IT IS NOT STARTED TO BE COOKED, DELETES ORDER.
  void deleteOrder(Order order) {
    if (order.status == 'Ordered' || order.status == 'InCart') order.delete();
  }

  // COMFIRM ALL ORDERS INSIDE THE CART.
  void completeOrders(List<Future<Order>> orders) {
    orders.forEach((futures) {
      futures.then((orders) {
        orders.setStatus('Ordered');
        orders.update();
      });
    });
  }
}
