import 'package:flutter/material.dart';
import 'package:sanal_menu/controllers/waiter/waiter_payments_controller.dart';
import 'package:sanal_menu/views/waiter/widgets/payment_dialog.dart';

class WaiterAssignedPayments extends StatelessWidget {
  List<Payment> assignedPayments;
  WaiterAssignedPayments({this.assignedPayments});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 100, maxHeight: 250),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "Assigned Payments",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          (assignedPayments == null || assignedPayments.length == 0)
              ? Center(
                  child: Text('No payment assignment found.'),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: assignedPayments != null ? assignedPayments.length : 0,
                    itemBuilder: (context, index) {
                      return FlatButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return PaymentDiaglog(
                                payment: assignedPayments[index],
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
                                Text(assignedPayments[index].deviceName),
                                Text("\$" + assignedPayments[index].totalPrice.toString()),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
