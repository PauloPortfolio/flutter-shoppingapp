import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shopingapp/app/core/components/keys/drawwer_keys.dart';
import 'package:shopingapp/app/core/texts_icons_provider/messages.dart';
import 'package:shopingapp/app/modules/inventory/components/inventory_item.dart';
import 'package:shopingapp/app/modules/inventory/core/inventory_keys.dart';
import 'package:shopingapp/app/modules/inventory/entities/product.dart';
import 'package:shopingapp/app/modules/inventory/view/inventory_add_edit_view.dart';
import 'package:shopingapp/app/modules/inventory/view/inventory_view.dart';
import 'package:shopingapp/app/modules/overview/components/overview_grid_item.dart';
import 'package:shopingapp/app/modules/overview/core/overview_widget_keys.dart';
import 'package:shopingapp/app/modules/overview/view/overview_view.dart';

import '../../../../app_tests_config.dart';
import '../../../../test_utils/test_utils.dart';
import '../../../../test_utils/view_test_utils.dart';

class InventoryViewTests {
  final _seek = Get.put(TestUtils());
  final _viewTestUtils = Get.put(ViewTestUtils());

  Future tapingBackButtonInInventoryView(tester) async {
    await _viewTestUtils.navigationBetweenViews(
      tester,
      from: InventoryView,
      to: OverviewView,
      trigger: BackButton,
      delaySeconds: DELAY,
    );
  }

  Future checkInventoryProductsAbsence(
    WidgetTester tester,
    int delaySeconds,
  ) async {
    await _viewTestUtils.openDrawerAndClickAnOption(
      tester,
      delaySeconds: delaySeconds,
      clickedKeyOption: DRAWER_INVENTORY_OPTION_KEY,
      scaffoldGlobalKey: DRAWWER_SCAFFOLD_GLOBALKEY,
    );

    _viewTestUtils.checkWidgetsQtdeInOneView(
      widgetView: InventoryView,
      widgetQtde: 0,
      widgetType: InventoryItem,
    );

    expect(_seek.text(NO_INVENTORY_PRODUCTS_FOUND_YET), findsOneWidget);

    await _viewTestUtils.navigationBetweenViews(
      tester,
      delaySeconds: delaySeconds,
      from: InventoryView,
      to: OverviewView,
      trigger: BackButton,
    );
  }

  Future refreshingInventoryView(tester) async {
    await tester.pump();

    _viewTestUtils.checkWidgetsQtdeInOneView(
      widgetView: OverviewView,
      widgetType: OverviewGridItem,
      widgetQtde: 4,
    );

    await _viewTestUtils.openDrawerAndClickAnOption(
      tester,
      delaySeconds: DELAY,
      clickedKeyOption: DRAWER_INVENTORY_OPTION_KEY,
      scaffoldGlobalKey: DRAWWER_SCAFFOLD_GLOBALKEY,
    );

    _viewTestUtils.checkWidgetsQtdeInOneView(
      widgetView: InventoryView,
      widgetType: InventoryItem,
      widgetQtde: 4,
    );

    //todo 01: provide the 'starting point' that will start the 'dragging' for the 'ref
    // resh' (for example: updateInventoryProduct + productToUpdate: product,)
    // "$OVERVIEW_GRID_ITEM_CART_BUTTON_KEY\0"
    // var dragInitialPointElement = _seek.key('$INVENTORY_ITEM_KEY${_prods[0].id}');
    // await tester.drag(dragInitialPointElement, Offset(0.0, -50.0));
    await tester.pump();
    await tester.pumpAndSettle(_seek.delay(1));

    expect(_seek.type(RefreshIndicator), findsNWidgets(1));
  }

  Future updateInventoryProduct(
    tester, {
    String inputValidText,
    String fieldKey,
    int delaySeconds,
    Product productToUpdate,
    bool isUnitTest,
  }) async {
    delaySeconds ??= DELAY;

    var keyUpdateButton =
        _seek.key('$INVENTORY_UPDATEITEM_BUTTON_KEY${productToUpdate.id}');

    await _viewTestUtils.openDrawerAndClickAnOption(
      tester,
      delaySeconds: delaySeconds,
      clickedKeyOption: DRAWER_INVENTORY_OPTION_KEY,
      scaffoldGlobalKey: DRAWWER_SCAFFOLD_GLOBALKEY,
    );

    // 1) InventoryView
    //   -> Check 'CurrentTitle'
    //   -> Click in 'UpdateButton'
    //   -> Open InventoryAddEditView
    expect(_seek.type(InventoryView), findsOneWidget);
    expect(_seek.text(productToUpdate.title), findsWidgets);
    await tester.tap(keyUpdateButton);
    await tester.pump(_seek.delay(delaySeconds));

    // 2) InventoryAddEditView
    //   -> Checking View + Title-Form-Field
    await tester.pump();
    expect(_seek.type(InventoryAddEditView), findsOneWidget);
    expect(_seek.text(productToUpdate.title), findsWidgets);

    // 3) InventoryAddEditView
    //   -> Insert 'UpdatedValue' in Page-Form-Field
    //   -> Checking the change
    // await tester.tap(_seek.key(INVENTORY_ADDEDIT_VIEW_FIELD_TITLE_KEY));
    await tester.tap(_seek.key(fieldKey));
    await tester.enterText(_seek.key(fieldKey), inputValidText);
    await tester.pump(_seek.delay(delaySeconds));

    // 4) Save form
    //   -> Tap Saving:
    //      - ONLY IN FUNCTIONAL-TESTS: Backing to InventoryView automatically
    //   -> Test existence of INValidation messages
    //   -> Go to InventoryView + Checking UpdatedValue
    await tester.tap(_seek.key(INVENTORY_ADDEDIT_VIEW_SAVEBUTTON_KEY));
    await tester.pump(_seek.delay(delaySeconds));

    // 4.1) Save form
    //   -> Tap Saving:
    //      - UNIT-TESTS: DO NOT Backing to InventoryView automatically
    //        - THEREFORE: _unitTests DOES NOT EXECUTE THIS 'TEST-PHASE', because:
    //          - They uses MOCK-OBJECTS which are not 'PERSISTED' IN DB
    //          - Without 'PERSISTENCE' in DB InventoryAddEditView does not GO-BACK
    //          InventoryView automatically
    if (!isUnitTest) {
      await tester.pump(_seek.delay(delaySeconds));
      expect(_seek.type(InventoryView), findsOneWidget);
      expect(_seek.text(inputValidText), findsOneWidget);

      // 5) Click InventoryView-BackButton
      //   -> Go to OverviewView + UpdatedValue
      await _viewTestUtils.navigationBetweenViews(
        tester,
        delaySeconds: DELAY,
        from: InventoryView,
        to: OverviewView,
        trigger: BackButton,
      );
      expect(_seek.text(inputValidText), findsOneWidget);
    }
  }

  Future checkInputInjectionOrInputValidation(
    tester, {
    String injectionTextOrInvalidText,
    String fieldKey,
    String shownValidationErrorMessage,
    int delaySeconds,
    Product productToUpdate,
    bool isUnitTest,
  }) async {
    delaySeconds ??= DELAY;

    var keyUpdateButton =
        _seek.key('$INVENTORY_UPDATEITEM_BUTTON_KEY${productToUpdate.id}');

    await _viewTestUtils.openDrawerAndClickAnOption(
      tester,
      delaySeconds: delaySeconds,
      clickedKeyOption: DRAWER_INVENTORY_OPTION_KEY,
      scaffoldGlobalKey: DRAWWER_SCAFFOLD_GLOBALKEY,
    );

    // 1) InventoryView
    //   -> Check 'CurrentTitle'
    //   -> Click in 'UpdateButton'
    //   -> Open InventoryAddEditView
    expect(_seek.type(InventoryView), findsOneWidget);
    expect(_seek.text(productToUpdate.title), findsWidgets);
    await tester.tap(keyUpdateButton);
    await tester.pump(_seek.delay(delaySeconds));

    // 2) InventoryAddEditView
    //   -> Checking View + Title-Form-Field
    await tester.pump();
    expect(_seek.type(InventoryAddEditView), findsOneWidget);
    expect(_seek.text(productToUpdate.title), findsWidgets);

    for (var i = 1; i <= 2; i++) {
      var isPriceField = fieldKey == INVENTORY_ADDEDIT_VIEW_FIELD_PRICE_KEY;
      var isUrlField = fieldKey == INVENTORY_ADDEDIT_VIEW_FIELD_URL_KEY;

      injectionTextOrInvalidText = i == 1
          ? injectionTextOrInvalidText
          : isPriceField
              ? '99.99'
              : isUrlField
                  ? 'https://images.freeimages.com/images/large-previews/294/tomatoes-1326096.jpg'
                  : 'validTexts';

      // 3) InventoryAddEditView
      //   -> Insert 'UpdatedValue' in Page-Form-Field
      //   -> Checking the change
      // await tester.tap(_seek.key(INVENTORY_ADDEDIT_VIEW_FIELD_TITLE_KEY));
      await tester.tap(_seek.key(fieldKey));
      await tester.enterText(_seek.key(fieldKey), injectionTextOrInvalidText);
      await tester.pump(_seek.delay(delaySeconds));

      // 4) Save form
      //   -> Tap Saving:
      //      - ONLY IN FUNCTIONAL-TESTS: Backing to InventoryView automatically
      //   -> Test existence of INValidation messages
      //   -> Go to InventoryView + Checking UpdatedValue
      await tester.tap(_seek.key(INVENTORY_ADDEDIT_VIEW_SAVEBUTTON_KEY));
      await tester.pump(_seek.delay(delaySeconds));

      if (i == 1) expect(_seek.text(shownValidationErrorMessage), findsWidgets);

      await tester.pump(_seek.delay(delaySeconds));
    }

    // 4.1) Save form
    //   -> Tap Saving:
    //      - UNIT-TESTS: DO NOT Backing to InventoryView automatically
    //        - THEREFORE: _unitTests DOES NOT EXECUTE THIS 'TEST-PHASE', because:
    //          - They uses MOCK-OBJECTS which are not ' ACTUAL PERSISTED' IN DB
    //          - Without 'PERSISTENCE' in DB, InventoryAddEditView does not GO-BACK TO
    //          InventoryView automatically
    if (!isUnitTest) {
      await tester.pump(_seek.delay(delaySeconds));
      expect(_seek.type(InventoryView), findsOneWidget);

      // 5) Click InventoryView-BackButton
      //   -> Go to OverviewView + UpdatedValue
      await _viewTestUtils.navigationBetweenViews(
        tester,
        delaySeconds: DELAY,
        from: InventoryView,
        to: OverviewView,
        trigger: BackButton,
      );
    }
  }

  Future deleteInventoryProduct(
    tester, {
    int initialQtde,
    int finalQtde,
    String keyDeleteButton,
    Type widgetTypeToDelete,
  }) async {
    await tester.pump();

    await _viewTestUtils.openDrawerAndClickAnOption(
      tester,
      delaySeconds: DELAY,
      clickedKeyOption: DRAWER_INVENTORY_OPTION_KEY,
      scaffoldGlobalKey: DRAWWER_SCAFFOLD_GLOBALKEY,
    );

    _viewTestUtils.checkWidgetsQtdeInOneView(
      widgetView: InventoryView,
      widgetQtde: initialQtde,
      widgetType: widgetTypeToDelete,
    );

    await tester.tap(_seek.key(keyDeleteButton));
    await tester.pump();
    await tester.pumpAndSettle(_seek.delay(DELAY));

    _viewTestUtils.checkWidgetsQtdeInOneView(
      widgetView: InventoryView,
      widgetQtde: finalQtde,
      widgetType: widgetTypeToDelete,
    );

    await _viewTestUtils.navigationBetweenViews(
      tester,
      delaySeconds: DELAY,
      from: InventoryView,
      to: OverviewView,
      trigger: BackButton,
    );

    _viewTestUtils.checkWidgetsQtdeInOneView(
      widgetView: OverviewView,
      widgetQtde: 1,
      widgetType: OverviewGridItem,
    );
  }

  Future checkInventoryProducts(tester, int ProductsQtde) async {
    await tester.pump();

    await _viewTestUtils.openDrawerAndClickAnOption(
      tester,
      delaySeconds: DELAY,
      clickedKeyOption: DRAWER_INVENTORY_OPTION_KEY,
      scaffoldGlobalKey: DRAWWER_SCAFFOLD_GLOBALKEY,
    );

    _viewTestUtils.checkWidgetsQtdeInOneView(
      widgetView: InventoryView,
      widgetType: InventoryItem,
      widgetQtde: ProductsQtde,
    );
  }
}
