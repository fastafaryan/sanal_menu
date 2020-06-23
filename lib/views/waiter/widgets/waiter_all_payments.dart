import 'package:flutter/material.dart';
import 'package:sanal_menu/controllers/waiter/waiter_payments_controller.dart';
import 'package:sanal_menu/views/waiter/widgets/payment_dialog.dart';

class WaiterAllPayments extends StatelessWidget {
  List<Payment> payments;
  WaiterAllPayments({this.payments});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 100, maxHeight: 500),
      child: Column(
        children: <Widget>[
          // Header
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "Payment Requests",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),

          // List of payment requests
          (payments == null || payments.length == 0)
              ? Center(
                  child: Text('No payment request found.'),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: payments != null ? payments.length : 0,
                    itemBuilder: (context, index) {
                      return FlatButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return PaymentDiaglog(
                                payment: payments[index],
                              );
                            },
                          );
                        },
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(payments[index].deviceName),
                                Text("\$" + payments[index].totalPrice.toString()),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
        ],
      ),
    );
  }
}
