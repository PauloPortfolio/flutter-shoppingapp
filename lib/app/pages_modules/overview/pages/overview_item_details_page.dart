import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/i_overview_controller.dart';
import '../core/overview_widget_keys.dart';

class OverviewItemDetailsPage extends StatelessWidget {
  final String _id = Get.arguments;
  final IOverviewController controller;

  OverviewItemDetailsPage({this.controller});

  @override
  Widget build(BuildContext context) {
    var _item = controller.getProductById(_id);
    return Scaffold(
        appBar: AppBar(title: Text(_item.title)),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                _item.imageUrl,
                fit: BoxFit.cover,
                key: Key(K_OV_ITM_DET_PAGE_IMG),
              )),
          SizedBox(height: 10),
          Text('\$${_item.price}'),
          SizedBox(height: 10),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(_item.description,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1))
        ])));
  }
}
