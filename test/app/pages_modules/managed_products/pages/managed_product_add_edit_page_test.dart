import 'dart:io';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shopingapp/app/core/properties/theme/dark_theme_controller.dart';
import 'package:shopingapp/app/core/texts_icons_provider/pages/managed_products/managed_product_edit.dart';
import 'package:shopingapp/app/core/texts_icons_provider/pages/managed_products/managed_products.dart';
import 'package:shopingapp/app/core/texts_icons_provider/pages/pages_generic_components/drawwer.dart';
import 'package:shopingapp/app/pages_modules/cart/controller/cart_controller.dart';
import 'package:shopingapp/app/pages_modules/cart/core/cart_bindings.dart';
import 'package:shopingapp/app/pages_modules/custom_widgets/core/keys/custom_circ_progr_indicator_keys.dart';
import 'package:shopingapp/app/pages_modules/custom_widgets/core/keys/custom_drawer_widgets_keys.dart';
import 'package:shopingapp/app/pages_modules/custom_widgets/core/texts_icons/drawwer_texts_icons_provided.dart';
import 'package:shopingapp/app/pages_modules/managed_products/components/managed_product_item.dart';
import 'package:shopingapp/app/pages_modules/managed_products/controller/managed_products_controller.dart';
import 'package:shopingapp/app/pages_modules/managed_products/core/managed_products_widget_keys.dart';
import 'package:shopingapp/app/pages_modules/managed_products/core/messages/field_form_validation_provided.dart';
import 'package:shopingapp/app/pages_modules/managed_products/repo/i_managed_products_repo.dart';
import 'package:shopingapp/app/pages_modules/managed_products/service/i_managed_products_service.dart';
import 'package:shopingapp/app/pages_modules/managed_products/service/managed_products_service.dart';
import 'package:shopingapp/app/pages_modules/overview/components/overview_grid_item.dart';
import 'package:shopingapp/app/pages_modules/overview/controller/overview_controller.dart';
import 'package:shopingapp/app/pages_modules/overview/core/overview_widget_keys.dart';
import 'package:shopingapp/app/pages_modules/overview/repo/i_overview_repo.dart';
import 'package:shopingapp/app/pages_modules/overview/service/i_overview_service.dart';
import 'package:shopingapp/app/pages_modules/overview/service/overview_service.dart';
import 'package:shopingapp/app_driver.dart';

import '../../../../test_utils/custom_test_methods.dart';
import '../../../../test_utils/test_utils.dart';
import '../../overview/repo/overview_repo_mocks.dart';
import '../repo/managed_products_repo_mocks.dart';

class ManagedProductsAddEditPageTest {
  static void functional() {
    var _seek = TestUtils();

    var drawerTitle = _seek.text(DRAWER_COMPONENT_TITLE_APPBAR);
    var drawerManProdOption = _seek.key(DRAWWER_MANAGED_PRODUCTS_OPTION);
    var drawerOvViewOption = _seek.key(DRAWWER_OVERVIEW_OPTION);

    var manProdPageTitle = _seek.text(MANAGED_PRODUCTS_PAGE_TITLE);

    var ovViewScaffGlobalKey = OVERVIEW_PAGE_SCAFFOLD_GLOBALKEY;
    var manProdScaffGlobalKey = MANAGED_PRODUCTS_PAGE_SCAFFOLD_GLOBALKEY;

    var manProdAddEditPageTitle =
        _seek.text(MANAGED_PRODUCTS_ADDEDIT_TITLEPAGE_ADD);
    var fldTitle = _seek.text(MANAGED_PRODUCTS_ADDEDIT_FIELD_TITLE);
    var fldPrice = _seek.text(MANAGED_PRODUCTS_ADDEDIT_FIELD_PRICE);
    var fldDescr = _seek.text(MANAGED_PRODUCTS_ADDEDIT_FIELD_DESCRIPT);
    var fldImgUrl = _seek.text(MANAGED_PRODUCTS_ADDEDIT_FIELD_IMAGE_URL);
    var fldImgTitle = _seek.text(MANAGED_PRODUCTS_ADDEDIT_IMAGE_TITLE);
    var manProdPageAddProductButton =
        _seek.key(MANAGED_PRODUCTS_APPBAR_ADDBUTTON_KEY);
    var saveProductButton = _seek.key(MANAGED_PRODUCTS_ADDEDIT_SAVEBUTTON_KEY);
    var fieldFormTitle = _seek.key(MANAGED_PRODUCTS_ADDEDIT_FIELD_TITLE_KEY);
    var fieldFormPrice = _seek.key(MANAGED_PRODUCTS_ADDEDIT_FIELD_PRICE_KEY);
    var fieldFormDescr = _seek.key(MANAGED_PRODUCTS_ADDEDIT_FIELD_DESCRIPT_KEY);
    var fieldFormImgUrl = _seek.key(MANAGED_PRODUCTS_ADDEDIT_FIELD_URL_KEY);
    var customCircProgrIndic = _seek.key(CUSTOM_CIRC_PROGR_INDICATOR_KEY);

    var fakeTitle, fakePrice, fakeDesc, fakeImgUrl, invalidText;
    var _binding;

    void _getBinding(IManagedProductsRepo mock) {
      Get.reset();
      _binding = BindingsBuilder(() {
        Get.lazyPut<DarkThemeController>(() => DarkThemeController());

        // Get.lazyPut<IManagedProductsRepo>(() => ManagedProductsMockRepo());
        Get.lazyPut<IManagedProductsRepo>(() => mock);

        Get.lazyPut<IManagedProductsService>(
          () => ManagedProductsService(
              repo: Get.find<IManagedProductsRepo>(),
              overviewService: Get.find<IOverviewService>()),
        );

        Get.lazyPut<ManagedProductsController>(
          () => ManagedProductsController(
              service: Get.find<IManagedProductsService>()),
        );

        Get.lazyPut<IOverviewRepo>(() => OverviewMockRepo());
        Get.lazyPut<IOverviewService>(
          () => OverviewService(repo: Get.find<IOverviewRepo>()),
        );
        Get.lazyPut<OverviewController>(
          () => OverviewController(service: Get.find<IOverviewService>()),
        );

        CartBindings().dependencies();
      });
    }

    setUp(() {
      expect(Get.isPrepared<IOverviewRepo>(), isFalse);
      expect(Get.isPrepared<IOverviewService>(), isFalse);
      expect(Get.isPrepared<OverviewController>(), isFalse);
      expect(Get.isPrepared<CartController>(), isFalse);

      expect(Get.isPrepared<IManagedProductsRepo>(), isFalse);
      expect(Get.isPrepared<IManagedProductsService>(), isFalse);
      expect(Get.isPrepared<ManagedProductsController>(), isFalse);

      _getBinding(ManagedProductsMockRepo());
      _binding.builder();

      expect(Get.isPrepared<IOverviewRepo>(), isTrue);
      expect(Get.isPrepared<IOverviewService>(), isTrue);
      expect(Get.isPrepared<OverviewController>(), isTrue);
      expect(Get.isPrepared<CartController>(), isTrue);

      expect(Get.isPrepared<IManagedProductsRepo>(), isTrue);
      expect(Get.isPrepared<IManagedProductsService>(), isTrue);
      expect(Get.isPrepared<ManagedProductsController>(), isTrue);

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

      expect(Get.isRegistered<IManagedProductsRepo>(), isTrue);
      expect(Get.isRegistered<IManagedProductsService>(), isTrue);
      expect(Get.isRegistered<ManagedProductsController>(), isTrue);
    }

    void _expectTestingPageFieldsExistence() {
      expect(fldTitle, findsOneWidget);
      expect(fldPrice, findsOneWidget);
      expect(fldDescr, findsOneWidget);
      expect(fldImgUrl, findsOneWidget);
      expect(fldImgTitle, findsOneWidget);
    }

    Future _openAndTestManagedProductsAddEditPage(tester) async {
      //a) Click in OverviewPage Drawer
      //   -> check  the 04 'OverviewGridItem'
      //   -> Open Drawer
      expect(_seek.type(OverviewGridItem), findsNWidgets(4));
      ovViewScaffGlobalKey.currentState.openDrawer();
      await tester.pump();
      await tester.pump(_seek.delay(1));
      expect(ovViewScaffGlobalKey.currentState.isDrawerOpen, isTrue);

      expect(_seek.text(DRAWER_COMPONENT_TITLE_APPBAR), findsOneWidget);

      //b) In the Drawer
      //   -> Click Managed Product Option
      //      -> open 'Managed Products Page'
      //      -> check  the 04 'ManagedProductItem'
      await tester.tap(drawerManProdOption);
      await tester.pump();
      await tester.pump(_seek.delay(1));
      // expect(ovViewScaffGlobalKey.currentState.isDrawerOpen, isFalse);
      expect(_seek.type(ManagedProductItem), findsNWidgets(4));

      //c) Managed Products Page:
      //   -> Click AddProductButton
      //      -> Open 'ManProductsAddEditPage' (To enter New Product Features)
      await tester.tap(manProdPageAddProductButton);
      await tester.pump();
      await tester.pump(_seek.delay(1));
      expect(manProdAddEditPageTitle, findsOneWidget);
    }

    void _createFakeDataToTestTheManProdAddEditPAgeFormFields() {
      invalidText = "d";
      // fakeTitle = Faker().randomGenerator.string(10, min: 5);
      fakeTitle = "xxxxxx";
      fakePrice =
          Faker().randomGenerator.decimal(min: 20).toPrecision(2).toString();
      // fakeDesc = Faker().randomGenerator.string(30, min: 10);
      fakeDesc = "xxxxxxxxxxxxxx";
      fakeImgUrl =
          "https://images.freeimages.com/images/large-previews/eae/clothes-3-1466560.jpg";
    }

    Future _loadFormFields(WidgetTester tester, String title, String price,
        String descr, String imgUrl) async {
      await tester.enterText(fieldFormTitle, title);
      await tester.enterText(fieldFormPrice, price);
      await tester.enterText(fieldFormDescr, descr);
      await tester.enterText(fieldFormImgUrl, imgUrl);

      await tester.pump();
      await tester.pump(_seek.delay(2));
    }

    void _expectTestingINValidationMessages(Matcher matcher) {
      expect(_seek.text(INVALID_TITLE_MSG), matcher);
      expect(_seek.text(INVALID_PRICE_MSG), matcher);
      expect(_seek.text(INVALID_DESCR_MSG), matcher);
      expect(_seek.text(INVALID_URL_MSG), matcher);
    }

    testWidgets('Adding a product', (tester) async {
      await tester.pumpWidget(AppDriver());
      await tester.pump();
      _isInstancesRegistred();

      await _openAndTestManagedProductsAddEditPage(tester);
      _createFakeDataToTestTheManProdAddEditPAgeFormFields();
      await _loadFormFields(tester, fakeTitle, fakePrice, fakeDesc, fakeImgUrl);

      await tester.tap(saveProductButton);
      await tester.pump();
      await tester.pump(_seek.delay(3));

      expect(manProdPageTitle, findsOneWidget);
      expect(_seek.type(ManagedProductItem), findsNWidgets(5));
      expect(ovViewScaffGlobalKey.currentState.isDrawerOpen, isFalse);

      /*MISTAKE:
      Here, we have manProdScaffGlobalKey.GlobalKey.currentState.openDrawer()
      so...
      It is a mistake use ovViewScaffGlobalKey.currentState.openDrawer() when
       you are testing..thats the why the problem is happen
      * */
      ovViewScaffGlobalKey.currentState.openDrawer();
      expect(ovViewScaffGlobalKey.currentState.isDrawerOpen, isTrue);
      await tester.pump();
      await tester.pump(_seek.delay(2));

      // expect(_seek.text(DRAWER_COMPONENT_TITLE_APPBAR), findsOneWidget);

      // await tester.tap(saveProductButton);
      // await tester.pump();
      // await tester.pump(_seek.delay(1));
      // expect(_seek.type(OverviewGridItem), findsNWidgets(5));
    });

    testWidgets('Open Managed Product AddEdit Page', (tester) async {
      await tester.pumpWidget(AppDriver());
      await tester.pump();
      _isInstancesRegistred();

      await _openAndTestManagedProductsAddEditPage(tester);

      _expectTestingPageFieldsExistence();
    });

    testWidgets('Fullfilling fields with previewImageUrl', (tester) async {
      await tester.pumpWidget(AppDriver());
      await tester.pump();
      _isInstancesRegistred();

      _createFakeDataToTestTheManProdAddEditPAgeFormFields();

      await _openAndTestManagedProductsAddEditPage(tester);

      await _loadFormFields(tester, fakeTitle, fakePrice, fakeDesc, fakeImgUrl);

      await tester.pump();
      await tester.pump(_seek.delay(2));

      _seek.imagesTotal(0);
      await tester.tap(fieldFormDescr);
      await tester.pump();
      await tester.pump(_seek.delay(2));
      _seek.imagesTotal(1);

      await tester.tap(saveProductButton);
      await tester.pump();
      await tester.pump(_seek.delay(3));

      _expectTestingINValidationMessages(findsNothing);
    });

    testWidgets('Fullfilling fields testing INValidation', (tester) async {
      await tester.pumpWidget(AppDriver());
      await tester.pump();
      _isInstancesRegistred();

      _createFakeDataToTestTheManProdAddEditPAgeFormFields();

      await _openAndTestManagedProductsAddEditPage(tester);

      await _loadFormFields(
          tester, invalidText, invalidText, invalidText, invalidText);

      await tester.tap(saveProductButton);
      await tester.pump();
      await tester.pump(_seek.delay(1));

      _expectTestingINValidationMessages(findsOneWidget);

      expect(manProdAddEditPageTitle, findsOneWidget);
    });

    testWidgets('Testing Page BackButton', (tester) async {
      await tester.pumpWidget(AppDriver());
      await tester.pump();
      _isInstancesRegistred();

      _createFakeDataToTestTheManProdAddEditPAgeFormFields();

      await _openAndTestManagedProductsAddEditPage(tester);

      expect(_seek.type(BackButton), findsOneWidget);
      await tester.pump();
      await tester.tap(_seek.type(BackButton));
      await tester.pump();
      await tester.pump(_seek.delay(2));
      expect(manProdPageTitle, findsOneWidget);
    });

    testWidgets('Open Page with NO products in DB', (tester) async {
      _getBinding(ManagedProductsMockRepoFail());
      _binding.builder();

      await tester.pumpWidget(AppDriver());
      await tester.pump();

      _isInstancesRegistred();

      expect(drawerTitle, findsNothing);
      ovViewScaffGlobalKey.currentState.openDrawer();
      await tester.pump();
      await tester.pump(_seek.delay(1));
      expect(drawerTitle, findsOneWidget);

      await tester.tap(drawerManProdOption);
      await tester.pump();
      await tester.pump(_seek.delay(1));
      expect(manProdPageTitle, findsOneWidget);
      expect(customCircProgrIndic, findsOneWidget);

      await tester.tap(manProdPageAddProductButton);
      await tester.pump();
      await tester.pump(_seek.delay(1));
      expect(manProdAddEditPageTitle, findsOneWidget);

      _expectTestingPageFieldsExistence();
    });
  }
}
