import 'package:flutter/material.dart';
import 'package:sanal_menu/controllers/customer_controller.dart';
import 'package:sanal_menu/controllers/base_controller.dart';
import 'package:provider/provider.dart';

class OrderSummary extends StatelessWidget {
  AsyncSnapshot snapshot;
  OrderSummary({this.snapshot});
  double totalPrice = 0;
  List<String> orderIDs = List<String>();

  @override
  Widget build(BuildContext context) {
    if (snapshot.data == null || snapshot.data.length == 0) {
      return Center(
        child: Text('Nothing to diplay.'),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      height: 50,
      child: ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (_, int index) {
          return FutureBuilder(
              future: snapshot.data[index], // a previously-obtained Future<String> or null
              builder: (context, order) {
                if (order == null || order.data == null) {
                  return Center(
                    child: Text('Nothing to diplay.'),
                  );
                }

                if (!orderIDs.contains(order.data.id)) {
                  totalPrice += order.data.itemPrice * order.data.quantity;
                  orderIDs.add(order.data.id);
                }

                if (index == snapshot.data.length - 1)
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Total Price: \$" + totalPrice.toString(),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      FutureBuilder(
                          future: CustomerController().isRequestedPayment(),
                          builder: (context, isPaying) {
                            if (isPaying.data == true)
                              return RaisedButton(
                                onPressed: () async {
                                  Map result = await CustomerController().cancelPaymentRequest();
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(result['message']),
                                    backgroundColor: result['type'] == MessageTypes.error ? Colors.red[900] : Colors.green,
                                  ));
                                },
                                child: Text("Cancel Order Request", style: Theme.of(context).textTheme.button),
                              );

                            return RaisedButton(
                              onPressed: () async {
                                Map result = await CustomerController().requestPayment();
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(result['message']),
                                  backgroundColor: result['type'] == MessageTypes.error ? Colors.red[900] : Colors.green,
                                ));
                              },
                              child: Text("Request Payment", style: Theme.of(context).textTheme.button),
                              elevation: 0,
                            );
                          }),
                    ],
                  );
                else
                  return Container();
              });
        },
      ),
    );
  }
}
