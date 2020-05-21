import 'package:sanal_menu/models/customer.dart';
import 'package:sanal_menu/models/order.dart';

class CustomerController {
  
  // ADD ITEM TO CATALOG
  Future addToCart(String itemID) async => Customer().addToCart(itemID);

  // MODIFY ORDER QUANTITY
  void modifyOrder(String orderID, int quantity) => Customer().modifyOrder(orderID, quantity);

  // REMOVE ORDER. CALLED INSIDE CART BEFORE ORDER WAS CONFIRMSED.
  void removeOrder(String orderID) => Customer().removeOrder(orderID);

  // COMFIRM ALL ORDERS INSIDE THE CART.
  void completeOrders(List<Order> orders) => Customer().completeOrders(orders);

  // CANCEL CONFIRMED ORDER
  void cancelOrder(Order order) => Customer().cancelOrder(order);
}
