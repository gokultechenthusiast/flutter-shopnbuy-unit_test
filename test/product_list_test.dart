import 'package:flutter_test/flutter_test.dart';
import 'package:shopnbuy/core/models/product.dart';
import 'package:shopnbuy/core/services/api.dart';
import 'package:shopnbuy/core/viewmodels/cart_model.dart';
import 'package:shopnbuy/core/viewmodels/product_list_model.dart';
import 'package:shopnbuy/helpers/dependency_assembly.dart';

class MockAPI extends API {
  @override
  Future<List<Product>> getProducts() {
    return Future.value([
      Product(
        id: 1,
        name: "MacBook Pro 16-inch model",
        price: 2399,
        imageUrl: "imageUrl",
      ),
      Product(
        id: 2,
        name: "AirPods Pro",
        price: 249,
        imageUrl: "imageUrl",
      ),
    ]);
  }
}

final Product mockProduct =
    Product(id: 1, name: "Product1", price: 111, imageUrl: "imageUrl");

void main() {
  ProductListModel productListViewModel;
  CartModel cartViewModel;
  setUpAll(() {
    ///The test suite runs separately from main() in main.dart,
    ///so you need to call setupDependencyAssembler() to inject your dependencies.
    setupDependencyAssembler();

    ///You create an instance of ProductListModel using GetIt.
    productListViewModel = dependencyAssembler<ProductListModel>();

    /// You create and assign an instance of the MockAPI class you defined above.
    productListViewModel.api = MockAPI();

    cartViewModel = dependencyAssembler<CartModel>();
  });

  group("ProductViewModel", () {
    test("should load a list of products from firebase", () async {
      /// Since the function passed to the test method is marked as async,
      /// each line in the closure runs synchronously, so you start by
      /// calling getProducts().
      await productListViewModel.getProducts();

      /// You then assert the length of the list based on the mock
      /// data you supplied in the MockAPI.
      expect(productListViewModel.products.length, 2);
      expect(
          productListViewModel.products[0].name, 'MacBook Pro 16-inch model');
      expect(productListViewModel.products[0].price, 2399);
      expect(productListViewModel.products[1].name, 'AirPods Pro');
      expect(productListViewModel.products[1].price, 249);
    });

    test("should increase cart count by 1 when user adds a product", () {
      cartViewModel.addToCart(mockProduct);
      expect(cartViewModel.cartSize, 1);
    });
  });
}
