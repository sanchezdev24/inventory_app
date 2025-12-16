import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/http_client.dart';
import '../models/product_model.dart';

/// Remote data source for products
abstract class ProductRemoteDataSource {
  /// Get all products from API
  Future<List<ProductModel>> getProducts();

  /// Get product by ID
  Future<ProductModel> getProductById(int id);
}

/// Implementation of remote data source
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final HttpClient client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await client.get(ApiConstants.products);
    final List<dynamic> jsonList = response as List<dynamic>;
    return jsonList
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final response = await client.get('${ApiConstants.productById}$id');
    return ProductModel.fromJson(response as Map<String, dynamic>);
  }
}