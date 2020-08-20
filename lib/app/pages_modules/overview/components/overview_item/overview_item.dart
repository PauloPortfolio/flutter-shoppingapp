import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/properties/app_properties.dart';
import '../../../../core/properties/app_routes.dart';
import '../../../../texts_icons_provider/app_generic_words.dart';
import '../../../cart/controller/cart_controller.dart';
import '../../../managed_products/entities/product.dart';
import '../../../pages_generic_components/custom_flush_notifier.dart';
import '../../core/messages_provided/message_flush_notifier_provided.dart';
import '../../core/overview_texts_icons_provided.dart';
import 'overview_item_controller.dart';

class OverviewItem extends StatelessWidget {
  final Product _product;

  OverviewItem(this._product);

  final OverviewItemController _overviewItemController =
      OverviewItemController();

  final CartController _cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    _overviewItemController.favoriteStatus.value = _product.isFavorite;
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(220, 220, 220, 10)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: GridTile(
                child: GestureDetector(
                    onTap: () => Get.toNamed(
                        '$AppRoutes.OVERVIEW_DETAIL_ROUTE${_product.id}'),
                    child: Image.network(_product.imageUrl, fit: BoxFit.cover)),
                footer: GridTileBar(
                    leading: Obx(
                      () => IconButton(
                          icon: _overviewItemController.favoriteStatus.value
                              ? OVERV_ICO_FAV
                              : OVERV_ICO_NOFAV,
                          onPressed: () => _overviewItemController
                              .toggleFavoriteStatus(_product.id),
                          color: Theme.of(context).accentColor),
                    ),
                    title: Text(_product.title),
                    trailing: IconButton(
                        icon: OVERV_ICO_SHOP,
                        onPressed: () {
                          _cartController.addProductInTheCart(_product);
                          FlushNotifier(DONE, _product.title + ITEMCART_ADDED,
                                  INTERVAL, context)
                              .withButton(UNDO, () {
                            _cartController.undoAddProductInTheCart(_product);
                          });
                        },
                        color: Theme.of(context).accentColor),
                    backgroundColor: Colors.black87))));
  }
}
