import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shopingapp/app/core/properties/theme/dark_theme_controller.dart';
import 'package:shopingapp/app/core/texts_icons_provider/app_generic_words.dart';
import 'package:shopingapp/app/core/texts_icons_provider/app_messages.dart';
import 'package:shopingapp/app/core/texts_icons_provider/pages/cart.dart';
import 'package:shopingapp/app/core/texts_icons_provider/pages/overview.dart';
import 'package:shopingapp/app/pages_modules/cart/components/card_cart_item.dart';
import 'package:shopingapp/app/pages_modules/cart/controller/cart_controller.dart';
import 'package:shopingapp/app/pages_modules/cart/core/cart_widget_keys.dart';
import 'package:shopingapp/app/pages_modules/cart/repo/cart_repo.dart';
import 'package:shopingapp/app/pages_modules/cart/repo/i_cart_repo.dart';
import 'package:shopingapp/app/pages_modules/cart/service/cart_service.dart';
import 'package:shopingapp/app/pages_modules/cart/service/i_cart_service.dart';
import 'package:shopingapp/app/pages_modules/custom_widgets/core/keys/custom_circ_progr_indicator_keys.dart';
import 'package:shopingapp/app/pages_modules/managed_products/entities/product.dart';
import 'package:shopingapp/app/pages_modules/orders/repo/i_orders_repo.dart';
import 'package:shopingapp/app/pages_modules/orders/service/i_orders_service.dart';
import 'package:shopingapp/app/pages_modules/orders/service/orders_service.dart';
import 'package:shopingapp/app/pages_modules/overview/controller/overview_controller.dart';
import 'package:shopingapp/app/pages_modules/overview/core/overview_widget_keys.dart';
import 'package:shopingapp/app/pages_modules/overview/repo/i_overview_repo.dart';
import 'package:shopingapp/app/pages_modules/overview/service/i_overview_service.dart';
import 'package:shopingapp/app/pages_modules/overview/service/overview_service.dart';
import 'package:shopingapp/app_driver.dart';

import '../../../test_utils/custom_test_methods.dart';
import '../../../test_utils/test_utils.dart';
import '../orders/repo/orders_repo_mocks.dart';
import '../overview/repo/overview_repo_mocks.dart';

class CartPageTest {
  static void functional() {
    TestUtils _seek;

    final binding = BindingsBuilder(() {
      Get.lazyPut<DarkThemeController>(() => DarkThemeController());

      Get.lazyPut<IOverviewRepo>(() => OverviewMockRepo());
      Get.lazyPut<IOverviewService>(
          () => OverviewService(repo: Get.find<IOverviewRepo>()));
      Get.lazyPut<OverviewController>(
          () => OverviewController(service: Get.find<IOverviewService>()));

      Get.lazyPut<IOrdersRepo>(() => OrdersMockRepo());
      Get.lazyPut<IOrdersService>(() => OrdersService(repo: Get.find()));

      Get.lazyPut<ICartRepo>(() => CartRepo());
      Get.lazyPut<ICartService>(() => CartService(repo: Get.find()));
      Get.lazyPut<CartController>(() => CartController(
            cartService: Get.find(),
            ordersService: Get.find(),
          ));
    });

    setUp(() {
      expect(Get.isPrepared<IOverviewRepo>(), isFalse);
      expect(Get.isPrepared<IOverviewService>(), isFalse);
      expect(Get.isPrepared<OverviewController>(), isFalse);
      expect(Get.isPrepared<CartController>(), isFalse);
      binding.builder();
      expect(Get.isPrepared<IOverviewRepo>(), isTrue);
      expect(Get.isPrepared<IOverviewService>(), isTrue);
      expect(Get.isPrepared<OverviewController>(), isTrue);
      expect(Get.isPrepared<CartController>(), isTrue);

      HttpOverrides.global = null;
      _seek = TestUtils();
    });

    tearDown(() {
      CustomTestMethods.globalTearDown();
      _seek = null;
    });

    void _isInstancesRegistred() {
      expect(Get.isRegistered<IOverviewRepo>(), isTrue);
      expect(Get.isRegistered<IOverviewService>(), isTrue);
      expect(Get.isRegistered<OverviewController>(), isTrue);
      expect(Get.isRegistered<CartController>(), isTrue);
    }

    List<Product> _prods() {
      return Get.find<IOverviewService>().localDataAllProducts;
    }

    testWidgets('Adding products + Checking Appbar CartIcon text Qtde',
        (tester) async {
      await tester.pumpWidget(AppDriver());
      await tester.pump();
      _isInstancesRegistred();

      var CartIconKey = _seek.key("$OVERVIEW_GRID_ITEM_CART_BUTTON_KEY\0");

      expect(_seek.text("0"), findsOneWidget);
      await tester.tap(CartIconKey);
      await tester.pumpAndSettle(_seek.delay(1));
      expect(_seek.text("1"), findsOneWidget);
      await tester.tap(CartIconKey);
      await tester.pumpAndSettle(_seek.delay(1));
      expect(_seek.text("2"), findsOneWidget);
    });

    testWidgets('Adding products + Checking Appbar CartIcon text Qtde',
        (tester) async {
      await tester.pumpWidget(AppDriver());
      await tester.pump();
      _isInstancesRegistred();

      var CartIconKey = _seek.key("$OVERVIEW_GRID_ITEM_CART_BUTTON_KEY\0");

      expect(_seek.text("0"), findsOneWidget);
      await tester.tap(CartIconKey);
      await tester.pumpAndSettle(_seek.delay(1));
      expect(_seek.text("1"), findsOneWidget);
      await tester.tap(CartIconKey);
      await tester.pumpAndSettle(_seek.delay(1));
      expect(_seek.text("2"), findsOneWidget);
    });

    testWidgets('Adding a product', (tester) async {
      await tester.pumpWidget(AppDriver());
      await tester.pump();
      _isInstancesRegistred();

      var CartIconProduct1 = _seek.key("$OVERVIEW_GRID_ITEM_CART_BUTTON_KEY\0");
      var snackbartext1 = _seek.text(_prods()[1].title.toString());
      var cartButtonPage = _seek.key(OVERVIEW_PAGE_SHOPCART_APPBAR_BUTTON_KEY);

      //1) ADDING A PRODUCT IN THE CART
      expect(_seek.text("0"), findsOneWidget);
      await tester.tap(CartIconProduct1);
      await tester.pumpAndSettle(_seek.delay(1));
      expect(_seek.text("1"), findsOneWidget);
      expect(snackbartext1, findsOneWidget);

      //2) CLICKING CART-BUTTON AND CHECK THE CART
      await tester.tap(cartButtonPage);
      await tester.pump();
      await tester.pumpAndSettle(_seek.delay(1));
      expect(_seek.text(CART_TITLE_PAGE), findsOneWidget);
      expect(_seek.text(_prods()[0].title), findsOneWidget);
      expect(_seek.text(_prods()[0].price.toString()), findsOneWidget);
      expect(_seek.text('x1'), findsOneWidget);
    });

    testWidgets('Dismissing/Deleting "ONE" added product', (tester) async {
      await tester.pumpWidget(AppDriver());
      await tester.pump();
      _isInstancesRegistred();

      var cartIconProduct1 = _seek.key("$OVERVIEW_GRID_ITEM_CART_BUTTON_KEY\0");
      var cartIconProduct2 = _seek.key("$OVERVIEW_GRID_ITEM_CART_BUTTON_KEY\1");
      var cartItemTitleProduct1 = _seek.text(_prods()[0].title.toString());
      var cartItemTitleProduct2 = _seek.text(_prods()[1].title.toString());
      var keyCartItemProduct1 = _seek.key('${_prods()[0].id}');
      var typeCardCartItem = _seek.type(CardCartItem);
      var cartPageButton = _seek.key(OVERVIEW_PAGE_SHOPCART_APPBAR_BUTTON_KEY);
      var cartPageTitle = _seek.text(CART_TITLE_PAGE);

      //1) ADDING A PRODUCT IN THE CART
      await tester.tap(cartIconProduct1);
      await tester.pumpAndSettle(_seek.delay(1));
      expect(_seek.text("1"), findsOneWidget);
      expect(cartItemTitleProduct1, findsOneWidget);
      await tester.tap(cartIconProduct2);
      await tester.pumpAndSettle(_seek.delay(1));
      expect(_seek.text("2"), findsOneWidget);
      expect(cartItemTitleProduct2, findsOneWidget);

      //2) CLICKING CART-PAGE-BUTTON AND CHECK THE CART
      await tester.tap(cartPageButton);
      await tester.pump();
      await tester.pumpAndSettle(_seek.delay(1));
      expect(cartPageTitle, findsOneWidget);
      expect(typeCardCartItem, findsNWidgets(2));

      //3) DISMISSING(LEFT DRAGGING) THE PRODUCT 01
      expect(cartItemTitleProduct1, findsOneWidget);
      expect(cartItemTitleProduct2, findsOneWidget);
      await tester.drag(keyCartItemProduct1, Offset(-500.0, 0.0));
      await tester.pump();
      await tester.pumpAndSettle(_seek.delay(1));
      expect(_seek.type(AlertDialog), findsOneWidget);
      expect(_seek.text(CART_LABEL_ALERTDIALOG_DISMIS_CONFIRM), findsOneWidget);
      await tester.tap(_seek.text(NO));
      await tester.pump();
      await tester.pumpAndSettle(_seek.delay(1));
      expect(typeCardCartItem, findsNWidgets(2));
      await tester.drag(keyCartItemProduct1, Offset(-500.0, 0.0));
      await tester.pump();
      await tester.pumpAndSettle(_seek.delay(1));
      expect(_seek.type(AlertDialog), findsOneWidget);
      expect(_seek.text(CART_LABEL_ALERTDIALOG_DISMIS_CONFIRM), findsOneWidget);
      await tester.tap(_seek.text(YES));
      await tester.pump();
      await tester.pumpAndSettle(_seek.delay(1));
      expect(typeCardCartItem, findsNWidgets(1));
    });

    testWidgets('Dismissing/Deleting "TWO" added product', (tester) async {
      await tester.pumpWidget(AppDriver());
      await tester.pump();
      _isInstancesRegistred();

      var cartIconProduct1 = _seek.key("$OVERVIEW_GRID_ITEM_CART_BUTTON_KEY\0");
      var cartIconProduct2 = _seek.key("$OVERVIEW_GRID_ITEM_CART_BUTTON_KEY\1");
      var cartItemTitleProduct1 = _seek.text(_prods()[0].title.toString());
      var cartItemTitleProduct2 = _seek.text(_prods()[1].title.toString());
      var keyCartItemProduct1 = _seek.key('${_prods()[0].id}');
      var keyCartItemProduct2 = _seek.key('${_prods()[1].id}');
      var typeCardCartItem = _seek.type(CardCartItem);
      var cartPageButton = _seek.key(OVERVIEW_PAGE_SHOPCART_APPBAR_BUTTON_KEY);
      var cartPageTitle = _seek.text(CART_TITLE_PAGE);
      var overviewPageTitle = _seek.text(OVERVIEW_TITLE_PAGE_ALL);

      //1) ADDING A PRODUCT IN THE CART
      expect(overviewPageTitle, findsOneWidget);
      await tester.tap(cartIconProduct1);
      await tester.pumpAndSettle(_seek.delay(1));
      expect(_seek.text("1"), findsOneWidget);
      expect(cartItemTitleProduct1, findsOneWidget);
      await tester.tap(cartIconProduct2);
      await tester.pumpAndSettle(_seek.delay(1));
      expect(_seek.text("2"), findsOneWidget);
      expect(cartItemTitleProduct2, findsOneWidget);

      //2) CLICKING CART-PAGE-BUTTON AND CHECK THE CART
      await tester.tap(cartPageButton);
      await tester.pump();
      await tester.pumpAndSettle(_seek.delay(1));
      expect(cartPageTitle, findsOneWidget);
      expect(typeCardCartItem, findsNWidgets(2));

      //3) DISMISSING(LEFT DRAGGING) THE PRODUCT 01
      await tester.drag(keyCartItemProduct1, Offset(-500.0, 0.0));
      await tester.pump();
      await tester.pumpAndSettle(_seek.delay(1));
      expect(_seek.type(AlertDialog), findsOneWidget);
      expect(_seek.text(CART_LABEL_ALERTDIALOG_DISMIS_CONFIRM), findsOneWidget);
      await tester.tap(_seek.text(YES));
      await tester.pump();
      await tester.pumpAndSettle(_seek.delay(1));
      expect(typeCardCartItem, findsNWidgets(1));
      expect(cartItemTitleProduct2, findsOneWidget);

      //4) DISMISSING(LEFT DRAGGING) THE PRODUCT 02
      await tester.drag(keyCartItemProduct2, Offset(-500.0, 0.0));
      await tester.pump();
      await tester.pumpAndSettle(_seek.delay(1));
      expect(_seek.type(AlertDialog), findsOneWidget);
      expect(_seek.text(CART_LABEL_ALERTDIALOG_DISMIS_CONFIRM), findsOneWidget);
      await tester.tap(_seek.text(YES));
      await tester.pump();
      // await tester.pumpAndSettle(_seek.delay(1));
      expect(cartItemTitleProduct2, findsNothing);
      expect(find.text(CART_NO_CARTITEMS_ANYMORE), findsOneWidget);
    });

    testWidgets('No products in the Cart, blocking access to Cart Page',
        (tester) async {
      await tester.pumpWidget(AppDriver());
      await tester.pump();
      _isInstancesRegistred();

      var cartButtonPage = _seek.key(OVERVIEW_PAGE_SHOPCART_APPBAR_BUTTON_KEY);

      //1) ADDING A PRODUCT IN THE CART
      expect(_seek.text("0"), findsOneWidget);
      await tester.pumpAndSettle(_seek.delay(1));

      //2) CLICKING CART-BUTTON AND CHECK THE CART
      await tester.tap(cartButtonPage);
      await tester.pump();
      await tester.pumpAndSettle(_seek.delay(1));
      expect(_seek.text(NO_ITEM_CART_IN_THE_SHOPCART_YET), findsOneWidget);
    });

    testWidgets('Acessing Cart Page + Testing two product added',
        (tester) async {
      await tester.pumpWidget(AppDriver());
      await tester.pump();
      _isInstancesRegistred();

      var CartIconProduct1 = _seek.key("$OVERVIEW_GRID_ITEM_CART_BUTTON_KEY\0");
      var CartIconProduct2 = _seek.key("$OVERVIEW_GRID_ITEM_CART_BUTTON_KEY\1");
      var snackbartext1 = _seek.text(_prods()[0].title.toString());
      var snackbartext2 = _seek.text(_prods()[1].title.toString());
      var cartButtonPage = _seek.key(OVERVIEW_PAGE_SHOPCART_APPBAR_BUTTON_KEY);

      //1) ADDING TWO PRODUCT IN THE CART
      expect(_seek.text("0"), findsOneWidget);
      await tester.tap(CartIconProduct1);
      await tester.tap(CartIconProduct1);
      await tester.pumpAndSettle(_seek.delay(1));
      expect(_seek.text("2"), findsOneWidget);
      expect(snackbartext1, findsOneWidget);
      await tester.tap(CartIconProduct2);
      await tester.tap(CartIconProduct2);
      await tester.pumpAndSettle(_seek.delay(1));
      expect(_seek.text("4"), findsOneWidget);
      expect(snackbartext2, findsOneWidget);

      //2) CLICKING CART-BUTTON AND CHECK THE CART
      await tester.tap(cartButtonPage);
      await tester.pump();
      await tester.pumpAndSettle(_seek.delay(1));
      expect(_seek.text(CART_TITLE_PAGE), findsOneWidget);
      expect(_seek.text(_prods()[0].title), findsOneWidget);
      expect(_seek.text('\$${_prods()[0].price}'), findsOneWidget);
      expect(_seek.text(_prods()[1].title), findsOneWidget);
      expect(_seek.text('\$${_prods()[1].price}'), findsOneWidget);
      expect(_seek.text('x2'), findsNWidgets(2));
    });

    testWidgets('checking Amount Cart', (tester) async {
      await tester.pumpWidget(AppDriver());
      await tester.pump();
      _isInstancesRegistred();

      var cartController = Get.find<CartController>();
      var CartIconProduct1 = _seek.key("$OVERVIEW_GRID_ITEM_CART_BUTTON_KEY\0");
      var snackbartext1 = _seek.text(_prods()[1].title.toString());
      var cartButtonPage = _seek.key(OVERVIEW_PAGE_SHOPCART_APPBAR_BUTTON_KEY);

      //1) ADDING TWO PRODUCT IN THE CART
      expect(_seek.text("0"), findsOneWidget);
      await tester.tap(CartIconProduct1);
      await tester.tap(CartIconProduct1);
      await tester.pumpAndSettle(_seek.delay(1));
      expect(_seek.text("2"), findsOneWidget);
      expect(snackbartext1, findsOneWidget);

      //2) CLICKING CART-BUTTON AND CHECK THE AMOUNT CART
      await tester.tap(cartButtonPage);
      await tester.pump();
      await tester.pumpAndSettle(_seek.delay(1));
      expect(_seek.text(CART_TITLE_PAGE), findsOneWidget);
      expect(_seek.text(cartController.getAmountCartItemsObs().toString()),
          findsOneWidget);
    });

    testWidgets('Ordering Cart Products - Order Now button', (tester) async {
      await tester.pumpWidget(AppDriver());
      await tester.pump();
      _isInstancesRegistred();

      var CartIconProduct1 = _seek.key("$OVERVIEW_GRID_ITEM_CART_BUTTON_KEY\0");
      var snackbartext1 = _seek.text(_prods()[1].title.toString());
      var snackbartext2 = _seek.text(ORDER_ADDITION_DONE_SUCESSFULLY);
      var cartButtonPage = _seek.key(OVERVIEW_PAGE_SHOPCART_APPBAR_BUTTON_KEY);
      var orderNowButton = _seek.key(CART_PAGE_ORDERSNOW_BUTTON_KEY);
      var customCircProgrIndic = _seek.key(CUSTOM_CIRC_PROGR_INDICATOR_KEY);

      //1) ADDING ONE PRODUCT IN THE CART
      expect(_seek.text("0"), findsOneWidget);
      await tester.tap(CartIconProduct1);
      await tester.pumpAndSettle(_seek.delay(1));
      expect(_seek.text("1"), findsOneWidget);
      expect(snackbartext1, findsOneWidget);

      //2) CLICKING CART-BUTTON-PAGE AND CHECK THE AMOUNT CART
      await tester.tap(cartButtonPage);
      await tester.pump();
      await tester.pumpAndSettle(_seek.delay(1));
      expect(_seek.text(CART_TITLE_PAGE), findsOneWidget);
      expect(_seek.text(_prods()[0].title), findsOneWidget);

      //3) CLICKING ORDER-NOW-BUTTON AND GO BACK TO THE PREVIOUS PAGE
      expect(orderNowButton, findsOneWidget);
      await tester.tap(orderNowButton);
      await tester.pump();
      await tester.pump(_seek.delay(1));
      expect(orderNowButton, findsNothing);
      expect(customCircProgrIndic, findsOneWidget);
      expect(snackbartext2, findsOneWidget);
      await tester.pump();
      await tester.pump(_seek.delay(1));
      expect(_seek.text(OVERVIEW_TITLE_PAGE_ALL), findsOneWidget);
    });
  }
}
