import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:shopingapp/app/modules/inventory/entities/product.dart';
import 'package:shopingapp/app/modules/inventory/service/i_inventory_service.dart';
import 'package:shopingapp/app/modules/overview/service/i_overview_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../config/inventory_test_config.dart';
import '../../../../data_builders/product_databuilder.dart';
import '../../../../mocked_datasource/products_mocked_datasource.dart';
import 'inventory_mocked_service.dart';

class InventoryServiceTests {
  static void unit() {
    late IOverviewService _overviewService;
    late IInventoryService _service, _injectService;

    var _product0 = ProductsMockedDatasource().products().elementAt(0);
    var _product1 = ProductsMockedDatasource().products().elementAt(1);
    var _products = ProductsMockedDatasource().products();
    var _newProduct = ProductDataBuilder().ProductFull();

    setUp(() {
      InventoryTestConfig().bindingsBuilderMockedRepo(isUnitTest: true);
      _overviewService = Get.find<IOverviewService>();
      _service = Get.find<IInventoryService>();
      _injectService = InventoryInjectMockedService();
    });

    test('Getting Products - ResponseType', () {
      _service.getProducts().then((value) {
        expect(value, isA<List<Product>>());
      });
    });

    test('Getting Products', () {
      _service.getProducts().then((productsReturned) {
        expect(productsReturned[0].id, _products.elementAt(0).id);
        expect(productsReturned[0].title, _products.elementAt(0).title);
      });
    });

    test('Getting LocalDataManagedProducts', () {
      _service.getProducts().then((_) {
        var list = _service.getLocalDataInventoryProducts();
        expect(list[0].id, _products.elementAt(0).id);
        expect(list[0].title, _products.elementAt(0).title);
      });
    });

    test('Adding Product', () {
      _service.addProduct(_product0).then((addedProduct) {
        // In addProduct, never the 'product to be added' has 'id'
        // expect(addedProduct.id, _product0.id);
        expect(addedProduct.title, _product0.title);
        expect(addedProduct.price, _product0.price);
        expect(addedProduct.description, _product0.description);
        expect(addedProduct.imageUrl, _product0.imageUrl);
        expect(addedProduct.isFavorite, _product0.isFavorite);
        expect(addedProduct, isIn(_service.getLocalDataInventoryProducts()));
      });
    });

    test('Adding Product in LocalDataManagedProducts', () {
      var productTest = ProductsMockedDatasource().product();

      _service.getProducts().then((_) {
        expect(_service.getLocalDataInventoryProducts().length, 4);

        _service.addLocalDataInventoryProducts(productTest);
        expect(_service.getLocalDataInventoryProducts().length, 5);
        expect(_service.getLocalDataInventoryProducts()[4].title, productTest.title);
      });
    });

    test('Getting ProductsQtde', () {
      _service.getProducts().then((response) {
        expect(response.length, _service.getProductsQtde());
      });
    });

    test('Getting ProductById', () {
      _service.getProducts().then((_) {
        expect(_service.getProductById(_product1.id!),
            isIn(_service.getLocalDataInventoryProducts()));
        expect(_service.getProductById(_product1.id!).title, _product1.title);
      });
    });

    test('Getting ProductById - Exception', () {
      _service.getProducts().then((_) {
        expect(
            () => _service.getProductById(_newProduct.id!), throwsA(isA<RangeError>()));
      });
    });

    test('Deleting a Product', () {
      _service.getProducts().then((_) {
        expect(_service.getProductById(_product1.id!),
            isIn(_service.getLocalDataInventoryProducts()));
        _service.deleteProduct(_product1.id!).then((response) {
          expect(response, 200);
        });
      });
    });

    test('Updating a Product', () {
      _overviewService.getProducts().then((_) {
        expect(
          _overviewService.getProductById(_product1.id!),
          isIn(_overviewService.getLocalDataAllProducts()),
        );
      });

      _service.getProducts().then((_) {
        expect(
          _service.getProductById(_product1.id!),
          isIn(_service.getLocalDataInventoryProducts()),
        );

        _service.updateProduct(_product1).then((response) {
          expect(response, 200);
        });
      });
    });

    test('Deleting a Product - Optimistic/Rollback', () {
      _service.getProducts().then((_) {
        expect(_service.getProductById(_product1.id!),
            isIn(_service.getLocalDataInventoryProducts()));
        _service.deleteProduct(_product1.id!).then((response) {
          expect(response, 200);
        });
      });
    });

    test('Deleting a Product(Inject) - Optimistic (Mocked)', () {
      when(_injectService.deleteProduct(_newProduct.id!))
          .thenAnswer((_) async => Future.value(404));

      when(_injectService.getLocalDataInventoryProducts()).thenReturn(_products);

      expect(_injectService.getLocalDataInventoryProducts(), _products);

      _injectService.deleteProduct(_newProduct.id!).then((response) {
        expect(response, 404);
      });
      //Rollback the localDataManagedProducts 'cause unsuccessful deleteProduct
      expect(_injectService.getLocalDataInventoryProducts(), _products);
    });

    test('Deleting a Product - Not found - Exception', () {
      _service.getProducts().then((_) {
        expect(_service.getProductById(_product1.id!),
            isIn(_service.getLocalDataInventoryProducts()));
        expect(() => _service.deleteProduct(_newProduct.id!), throwsA(isA<RangeError>()));
      });
    });

    test('Clearing LocalDataManagedProducts', () {
      _service.getProducts().then((response) {
        expect(_service.getLocalDataInventoryProducts(), isNot(isEmpty));
        _service.clearDataSavingLists();
        expect(_service.getLocalDataInventoryProducts(), isEmpty);
      });
    });
  }
}
