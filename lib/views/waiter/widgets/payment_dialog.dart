import 'package:flutter/material.dart';
import 'package:sanal_menu/controllers/waiter/waiter_payments_controller.dart';
import 'package:provider/provider.dart';
import 'package:sanal_menu/views/shared/constants.dart';

class PaymentDiaglog extends StatelessWidget {
  Payment payment;
  PaymentDiaglog({this.payment});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Text(
            payment.deviceName,
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              itemCount: payment.orders.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(payment.orders[index].itemName),
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "Quantity: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(payment.orders[index].quantity.toString()),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "Item price: \$",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(payment.orders[index].itemPrice.toString()),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Total payment: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("\$" + payment.totalPrice.toString()),
            ],
          ),

          //

          FutureBuilder(
            future: Provider.of<WaiterPaymentsController>(context).isAssignedPayment(payment),
            builder: (context, isAssigned) {
              if (isAssigned == null || isAssigned.data == null) return loadingCircle();
              if (isAssigned.data == true)
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        Provider.of<WaiterPaymentsController>(context, listen: false).cancelPayment(payment);
                      },
                      child: Text(
                        "Cancel",
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                    SizedBox(width: 10),
                    RaisedButton(
                      onPressed: () {
                        Provider.of<WaiterPaymentsController>(context, listen: false).setPaymentDone(payment);
                      },
                      child: Text(
                        "Set as Done",
                        style: Theme.of(context).textTheme.button,
                      ),
                    )
                  ],
                );
              else
                return RaisedButton(
                  onPressed: () {
                    Provider.of<WaiterPaymentsController>(context, listen: false).startPayment(payment);
                  },
                  child: Text(
                    "Start payment",
                    style: Theme.of(context).textTheme.button,
                  ),
                );
            },
          ),
        ],
      ),
    );
  }
}
