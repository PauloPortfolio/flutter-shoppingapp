import 'package:get/get.dart';

import '../../../core/components/custom_appbar/filter_favorite_enum.dart';
import '../../inventory/entity/product.dart';
import '../service/i_overview_service.dart';

class OverviewController extends GetxController {
  final IOverviewService service;
  var overviewViewGridViewItemsObs = <Product>[].obs;
  var favoriteStatusObs = false.obs;

  // var overviewViewTitleObs = EnumFilter.All.obs;
  var appbarFilterPopupObs = EnumFilter.All.obs;

  OverviewController({required this.service});

  @override
  void onInit() {
    service.clearDataSavingLists();
    getProducts().then((response) => overviewViewGridViewItemsObs.assignAll(response));
    super.onInit();
  }

  void updateFilteredProductsObs() {
    overviewViewGridViewItemsObs.assignAll(service.getLocalDataAllProducts());
  }

  void deleteProduct(String productId) {
    service.deleteProductInLocalDataLists(productId);
  }

  void applyFilter(EnumFilter filter) {
    // var enumFilter = filter == EnumFilter.Fav ? EnumFilter.Fav : EnumFilter.All;

    // overviewViewTitleObs.value = filter;

    appbarFilterPopupObs.value = filter;

    overviewViewGridViewItemsObs.assignAll(filter == EnumFilter.Fav
        ? service.setProductsByFilter(EnumFilter.Fav)
        : service.setProductsByFilter(EnumFilter.All));
  }

  Future<bool> toggleFavoriteStatus(String id) {
    // @formatter:off
    var _previousStatus = getProductById(id).isFavorite;
    var futureReturn = service.toggleFavoriteStatus(id).then((returnedFavStatus) {
      if (_previousStatus != returnedFavStatus) {
        favoriteStatusObs.value = returnedFavStatus;
      } else {
        return false;
      }
      return true;
    });
    favoriteStatusObs.value = getProductById(id).isFavorite;
    return futureReturn;
    // @formatter:on
  }

  Product getProductById(String id) {
    return service.getProductById(id);
  }

  Future<List<Product>> getProducts() {
    return service.getProducts().then((response) => response);
  }

  int getFavoritesQtde() {
    return service.getFavoritesQtde();
  }

  int getProductsQtde() {
    return service.getProductsQtde();
  }

  bool getFavoriteStatusObs() {
    return favoriteStatusObs.value;
  }

  List<Product> getFilteredProductsObs() {
    return overviewViewGridViewItemsObs.toList();
  }
}