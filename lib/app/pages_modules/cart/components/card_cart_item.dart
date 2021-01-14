import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/texts_icons_provider/app_generic_words.dart';
import '../controller/cart_controller.dart';
import '../core/cart_texts_icons_provided.dart';
import '../entities/cart_item.dart';

class CardCartItem extends StatelessWidget {
  final CartItem _cartItem;
  final CartController _cartController = Get.find();

  CardCartItem(this._cartItem);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key(_cartItem.id),
        background: Container(
            child: CRT_ICO_DISM,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Theme.of(context).errorColor)),
        direction: DismissDirection.endToStart,
        //
        onDismissed: (direction) => _cartController.removeCartItem(_cartItem),
        //
        child: Card(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            child: Padding(
                padding: EdgeInsets.all(8),
                child: ListTile(
                    leading: CircleAvatar(
                        child: Padding(
                            padding: EdgeInsets.all(5),
                            child: FittedBox(
                                child: Text('\$${_cartItem.price}')))),
                    title: Text(_cartItem.title),
                    subtitle:
                        Text('Total \$${(_cartItem.price).toStringAsFixed(2)}'),
                    trailing: Text('x${_cartItem.qtde}')))),
        //
        confirmDismiss: (direction) {
          return showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                      title: Text(CRT_LBL_CONF_DISM),
                      content: Text('$CRT_MSG_CONF_DISM${_cartItem.title}'
                          ' from the cart?'),
                      actions: <Widget>[
                        _flattButton(YES, true, context),
                        _flattButton(NO, false, context)
                      ]));
        });
  }

  FlatButton _flattButton(String label, bool remove, BuildContext context) {
    var cartItemsTotal = _cartController.getQtdeCartItemsObs();
    return FlatButton(
      key: Key('btn${_cartItem.id}'),
      onPressed: () => Navigator.of(context).pop(remove),
      child: Text(label),
    );
  }
}
