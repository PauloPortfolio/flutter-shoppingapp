import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/num_extensions.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';

import '../../../core/custom_widgets/custom_alert_dialog.dart';
import '../../../core/custom_widgets/snackbar/simple_snackbar.dart';
import '../../../core/icons/modules/cart_icons.dart';
import '../../../core/properties/app_properties.dart';
import '../../../core/texts/general_words.dart';
import '../../../core/texts/messages.dart';
import '../../../core/texts/modules/cart_labels.dart';
import '../controller/cart_controller.dart';
import '../entity/cart_item.dart';

class DismissibleCartItem extends StatelessWidget {
  final CartItem _cartItem;
  final _controller = Get.find<CartController>();
  final _icons = Get.find<CartIcons>();
  final _messages = Get.find<Messages>();
  final _words = Get.find<GeneralWords>();
  final _labels = Get.find<CartLabels>();

  DismissibleCartItem.create(this._cartItem);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key(_cartItem.id),
        background: Container(
          child: _icons.CRT_ICO_DISM(),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          decoration: BoxDecoration(
              color: Theme.of(context).errorColor,
              borderRadius: BorderRadius.circular(2)),
        ),
        direction: DismissDirection.endToStart,
        //
        onDismissed: (direction) {
          _controller.removeCartItem(_cartItem);
          if (_controller.qtdeCartItemsObs.value.isEqual(0)) {
            SimpleSnackbar().show(_words.suces(), _messages.item_removed_cart());
            Future.delayed(Duration(milliseconds: DURATION)).then((value) => Get.back());
          }
        },
        //
        child: Card(
            elevation: 5,
            shadowColor: Colors.black,
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            child: Padding(
                padding: EdgeInsets.all(8),
                child: ListTile(
                    leading: CircleAvatar(
                        child: Padding(
                      padding: EdgeInsets.all(5),
                      child: FittedBox(child: Text('\$${_cartItem.price}')),
                      // child: Image.network(_cartItem.imageUrl, fit: BoxFit.cover),
                    )),
                    title: Text(_cartItem.title),
                    subtitle: Text('Total \$${(_cartItem.price).toStringAsFixed(2)}'),
                    trailing: Text('x${_cartItem.qtde}')))),
        //
        confirmDismiss: (direction) {
          return CustomAlertDialog.showOptionDialog(
            context,
            _labels.label_title_dialog_dismis(),
            '${_labels.label_message_dialog_dismis()}${_cartItem.title} from the cart?',
            _words.yes(),
            _words.no(),
            () => {},
            () => {},
          );
        });
  }
}