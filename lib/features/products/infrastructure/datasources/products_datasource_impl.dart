import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/errors/product_errors.dart';
import 'package:teslo_shop/features/products/infrastructure/mappers/product_mapper.dart';

class ProductsDatasourceImpl extends ProductsDatasource {
  late final Dio dio;
  final String accessToken;

  ProductsDatasourceImpl({required this.accessToken})
      : dio = Dio(BaseOptions(
          baseUrl: Environment.apiUrl,
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ));

  Future<String> _uploadFile(String path) async {
    try {
      final fileName = path.split('/').last;

      final FormData data = FormData.fromMap({
        'file': await MultipartFile.fromFile(path, filename: fileName),
      });

      final response = await dio.post('/files/product', data: data);

      return response.data['image'];
    } catch (e) {
      throw Exception();
    }
  }

  Future<List<String>> _uploadImages(List<String> images) async {
    try {
      final imagesToUpload =
          images.where((image) => image.contains('/')).toList();
      final imagesToIgnore =
          images.where((image) => !image.contains('/')).toList();

      final List<Future<String>> imagesJob =
          imagesToUpload.map(_uploadFile).toList();

      final newImages = await Future.wait(imagesJob);
      return [...imagesToIgnore, ...newImages];
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> product) async {
    try {
      final String? productId = product['id'];
      final String method = (productId == null) ? 'POST' : 'PATCH';
      final String url =
          (productId == null) ? '/products' : '/products/$productId';

      product.remove('id');
      product['images'] = await _uploadImages(product['images']);

      final response = await dio.request(
        url,
        data: product,
        options: Options(method: method),
      );

      final productRes = ProductMapper.jsonToEntity(response.data);

      return productRes;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await dio.get('/products/$id');

      return ProductMapper.jsonToEntity(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ProductNotFoundError('Product with id $id not found');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Product>> getProductsByPage(
      {int limit = 10, int offset = 0}) async {
    final response = await dio.get<List>('/products', queryParameters: {
      'limit': limit,
      'offset': offset,
    });
    final List<Product> products = [];
    for (final productJson in response.data!) {
      products.add(ProductMapper.jsonToEntity(productJson));
    }
    return products;
  }

  @override
  Future<List<Product>> getProductsByTerm(String term) {
    // TODO: implement getProductsByTerm
    throw UnimplementedError();
  }
}
