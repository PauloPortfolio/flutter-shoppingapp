import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/properties/app_properties.dart';
import '../../orders/core/messages_snackbars_provided.dart';
import '../../pages_generic_components/custom_circ_progres_indicator.dart';
import '../../pages_generic_components/custom_snackbar.dart';
import '../components/card_cart_item.dart';
import '../controller/cart_controller.dart';
import '../core/cart_texts_icons_provided.dart';

class CartPage extends StatelessWidget {
  final CartController controller;

  CartPage({this.controller});

  @override
  Widget build(BuildContext context) {
    var fullSizeLessAppbar = MediaQuery.of(context).size;
    int currentQtdeCart = controller.qtdeCartItems();

    return Scaffold(
        appBar: AppBar(title: Text(CRT_TIT_APPBAR), actions: [
          IconButton(
              icon: CRT_ICO_CLEAR,
              onPressed: controller.clearCart,
              tooltip: CRT_ICO_CLEAR_TOOLT)
        ]),
        body: Container(
            width: fullSizeLessAppbar.width,
            height: fullSizeLessAppbar.height,
            child: LayoutBuilder(builder: (_, cons) {
              var consHeight = cons.maxHeight;
              var consWidth = cons.maxWidth;
              return Column(children: [
                Card(
                    margin: EdgeInsets.all(consWidth * 0.04),
                    child: Padding(
                        padding: EdgeInsets.all(consWidth * 0.02),
                        child: Container(
                            height: consHeight * 0.1,
                            child: Row(children: [
                              Container(
                                  width: consWidth * 0.15,
                                  child: Text(CRT_LBL_CARD,
                                      style: TextStyle(fontSize: 20))),
                              Container(
                                  width: consWidth * 0.25,
                                  child: Chip(
                                      label: Text(
                                          controller.amountCartItems.value
                                              .toStringAsFixed(2),
                                          style:
                                              TextStyle(color: Colors.white)),
                                      backgroundColor:
                                          Theme.of(context).primaryColor)),
                              SizedBox(width: consWidth * 0.18),
                              Container(
                                  width: consWidth * 0.3,
                                  height: consHeight * 0.08,
                                  child: Obx(() => controller.qtdeCartItems() !=
                                          currentQtdeCart
                                      ? CustomCircularProgressIndicator.radius(
                                          consWidth * 0.3)
                                      : _addOrderButton()))
                            ])))),
                SizedBox(height: consHeight * 0.01),
                Expanded(
                    child: ListView.builder(
                        itemCount: controller.getAllCartItems().length,
                        itemBuilder: (ctx, item) {
                          return CardCartItem(controller
                              .getAllCartItems()
                              .values
                              .elementAt(item));
                        }))
              ]);
            })));
  }

  Builder _addOrderButton() {
    return Builder(builder: (_context) {
      return FlatButton(
          child: Text(CRT_LBL_ORD,
              style: TextStyle(color: Theme.of(_context).primaryColor)),
          onPressed: () {
            controller
                .addOrder(controller.getAllCartItems().values.toList(),
                    controller.amountCartItems.value)
                .then((_) {
                  controller.clearCart();
                  controller.recalcQtdeAndAmountCart();
                  SimpleSnackbar(SUCES_ORD_ADD, _context).show();
                })
                .whenComplete(() =>
                    Future.delayed(Duration(milliseconds: DURATION))
                        .then((value) => Get.back()))
                .catchError(
                    (onError) => SimpleSnackbar(ERROR_ORD, _context).show());
          });
    });
  }
}
