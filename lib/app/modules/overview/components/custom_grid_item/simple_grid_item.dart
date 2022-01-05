import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';

import '../../../../core/custom_widgets/snackbar/button_snackbar.dart';
import '../../../../core/custom_widgets/snackbar/simple_snackbar.dart';
import '../../../../core/icons/modules/overview_icons.dart';
import '../../../../core/keys/modules/overview_keys.dart';
import '../../../../core/properties/app_properties.dart';
import '../../../../core/properties/app_routes.dart';
import '../../../../core/texts/general_words.dart';
import '../../../../core/texts/messages.dart';
import '../../../cart/controller/cart_controller.dart';
import '../../../inventory/entity/product.dart';
import '../../controller/overview_controller.dart';
import '../../service/i_overview_service.dart';
import 'icustom_grid_item.dart';

class SimpleGridItem extends StatelessWidget implements ICustomGridtile {
  final Product _product;
  final _icons = Get.find<OverviewIcons>();
  final _cartController = Get.find<CartController>();
  final _uniqueController = OverviewController(service: Get.find<IOverviewService>());
  final String index;
  final _messages = Get.find<Messages>();
  final _words = Get.find<GeneralWords>();

  SimpleGridItem(this._product, this.index);

  @override
  Widget build(BuildContext context) {
    _uniqueController.favoriteStatusObs.value = _product.isFavorite;
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Color.fromRGBO(220, 220, 220, 10)),
            borderRadius: BorderRadius.circular(10.0)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: customGridTile(context, _product, index, _uniqueController),
        ));
  }

  @override
  Widget customGridTile(
    context,
    Product product,
    String index,
    OverviewController uniqueController,
  ) {
    var fadeImage = FadeInImage(
      placeholder: AssetImage(IMAGE_PLACEHOLDER),
      image: NetworkImage(product.imageUrl),
      fit: BoxFit.cover,
    );

    return GridTile(
        child: GestureDetector(
            key: Key("$K_OV_ITM_DET_PAGE$index"),
            onTap: () => Get.toNamed('${AppRoutes.OVERVIEW_ITEM_DETAILS}${product.id}'),
            child: fadeImage),
        footer: GridTileBar(
            leading: Obx(
              () => _favButton(index, product, context),
            ),
            title: Text(product.title, key: Key("$K_OV_GRD_PRD_TIT$index")),
            trailing: _shopCartButton(index, product, context),
            backgroundColor: Colors.black87));
  }

  IconButton _shopCartButton(String index, Product product, context) {
    return IconButton(
        key: Key("$K_OV_GRD_CRT_BTN$index"),
        icon: _icons.ico_shopcart(),
        onPressed: () {
          _cartController.addCartItem(product);
          ButtonSnackbar(
            context: context,
            labelButton: _words.undo(),
            function: () => _cartController.addCartItemUndo(product),
          ).show(
            _words.done(),
            "${product.title}${_messages.item_cart_added()}",
          );
        },
        color: Theme.of(context).colorScheme.secondary);
  }

  IconButton _favButton(String index, Product product, context) {
    return IconButton(
        key: Key("$K_OV_GRD_FAV_BTN$index"),
        icon: _uniqueController.favoriteStatusObs.value
            ? _icons.ico_fav()
            : _icons.ico_nofav(),
        onPressed: () {
          _uniqueController.toggleFavoriteStatus(product.id!).then((response) {
            response
                ? SimpleSnackbar().show(_words.suces(), _messages.tog_status_suces())
                : SimpleSnackbar().show(_words.ops(), _messages.tog_status_error());
          });
        },
        color: Theme.of(context).colorScheme.secondary);
  }
}