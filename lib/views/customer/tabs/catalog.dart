import 'package:flutter/material.dart';
import 'package:sanal_menu/views/shared/grid.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Catalog extends StatelessWidget {
  AsyncSnapshot snapshot;
  Catalog({this.snapshot});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return SpinKitRing(
        color: Colors.black,
        size: 50.0,
      );
    }
    if (snapshot.data == null || snapshot.data.length == 0) {
      return Center(
        child: Text('Nothing to display here'),
      );
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: .9,
      ),
      itemCount: snapshot.data.length,
      itemBuilder: (_, int index) {
        return Grid(
          item: snapshot.data[index],
          isAsset: false,
          isPreview: false,
        );
      },
    );
  }
}
