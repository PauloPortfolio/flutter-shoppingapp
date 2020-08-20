import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/properties/app_routes.dart';
import '../controller/managed_products_controller.dart';
import '../core/texts_icons_provided/managed_product_item_texts_icons_provided.dart';

class ManagedProductItem extends StatelessWidget {
  final String _id;
  final String _title;
  final String _imageUrl;

  ManagedProductItem(this._id, this._title, this._imageUrl);

  final ManagedProductsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(_imageUrl)),
        title: Text(_title),
        trailing: Container(
            width: 100,
            child: Row(children: <Widget>[
              IconButton(
                  icon: MAN_PROD_ITEM_EDIT_ICO,
                  onPressed: () => Get.toNamed(
                      AppRoutes.MAN_PROD_ADD_EDIT_ROUTE,
                      arguments: _id),
                  color: Theme.of(context).errorColor),
              IconButton(
                  icon: MAN_PROD_ITEM_DELETE_ICO,
                  onPressed: () => controller.deleteManagedProduct(_id),
                  color: Theme.of(context).errorColor),
            ])));
  }
}
