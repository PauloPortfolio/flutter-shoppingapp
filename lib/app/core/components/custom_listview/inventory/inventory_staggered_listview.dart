import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../modules/inventory/components/inventory_item.dart';
import '../../../../modules/inventory/entity/product.dart';
import '../../../properties/app_properties.dart';
import 'icustom_inventory_listview.dart';

class InventoryStaggeredListview implements ICustomInventoryListview {
  final itemCount;
  final delayMilliseconds;
  final double verticalOffset;

  InventoryStaggeredListview({
    this.itemCount = ITEM_COUNT,
    this.delayMilliseconds = DELAY_MILLISEC_LISTVIEW,
    this.verticalOffset = VERTICAL_OFFSET_LISTVIEW,
  });

  @override
  Widget create(List<Product> productsList) {
    return AnimationLimiter(
        child: ListView.builder(
            itemCount: productsList.length,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: Duration(milliseconds: delayMilliseconds),
                  child: SlideAnimation(
                      verticalOffset: verticalOffset,
                      child: FadeInAnimation(
                        child: InventoryItem(product: productsList.elementAt(index)),
                      )));
            }));
  }
}