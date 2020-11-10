import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopingapp/app/pages_modules/pages_generic_components/custom_snackbar.dart';

import '../../../core/properties/app_routes.dart';
import '../../../core/texts_icons_provider/app_generic_words.dart';
import '../../cart/controller/cart_controller.dart';
import '../../managed_products/entities/product.dart';
import '../../pages_generic_components/custom_flushbar.dart';
import '../controller/overview_controller.dart';
import '../core/messages_snackbars_provided.dart';
import '../core/overview_texts_icons_provided.dart';
import '../core/overview_widget_keys.dart';

class OverviewGridItem extends StatelessWidget {
  final Product _product;
  final OverviewController _controller =
      OverviewController(service: Get.find());
  final CartController _cartController = Get.find();
  final String _index;

  OverviewGridItem(this._product, this._index);

  @override
  Widget build(BuildContext context) {
    _controller.favoriteStatusObs.value = _product.isFavorite;
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(220, 220, 220, 10)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: GridTile(
                child: GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.OVERVIEW_DETAIL,
                        arguments: _product.id),
                    child: Image.network(_product.imageUrl, fit: BoxFit.cover)),
                footer: GridTileBar(
                    leading: Obx(
                      () => IconButton(
                          key: Key("$OV001$_index"),
                          icon: _controller.favoriteStatusObs.value
                              ? OV_ICO_FAV
                              : OV_ICO_NOFAV,
                          onPressed: () {
                            _controller
                                .toggleFavoriteStatus(_product.id)
                                .then((returnedFavStatus) {
                              if (returnedFavStatus) {
                                CustomSnackbar.simple(
                                  context: context,
                                  message: TOGGLE_STATUS_SUCESS,
                                );
                              } else {
                                CustomSnackbar.simple(
                                  context: context,
                                  message: TOGGLE_STATUS_ERROR,
                                );
                              }
                            });
                          },
                          color: Theme.of(context).accentColor),
                    ),
                    title: Text(
                      _product.title,
                      key: Key("$OV003\_$_index"),
                    ),
                    trailing: IconButton(
                        key: Key("$OV002\_$_index"),
                        icon: OV_ICO_SHOP,
                        onPressed: () {
                          _cartController.addProductInTheCart(_product);
                          CustomSnackbar.button(
                              context: context,
                              title: DONE,
                              message: "${_product.title}$ITEMCART_ADDED",
                              label: "Undo",
                              function: () => _cartController
                                  .undoAddProductInTheCart(_product));
                        },
                        color: Theme.of(context).accentColor),
                    backgroundColor: Colors.black87))));
  }
}
                          // CustomFlushbar(
                          //   DONE,
                          //   "${_product.title}$ITEMCART_ADDED",
                          //   context,
                          // ).withButton(UNDO, () {
                          //   _cartController.undoAddProductInTheCart(_product);
                          // });
