import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';

final productProvider = StateNotifierProvider.autoDispose
    .family<ProductNotifier, ProductState, String>((ref, productId) {
  final productRepository = ref.watch(productRepositoryProvider);
  return ProductNotifier(
    productId: productId,
    productRepository: productRepository,
  );
});

class ProductNotifier extends StateNotifier<ProductState> {
  final String productId;
  final ProductsRepository productRepository;
  ProductNotifier({
    required this.productId,
    required this.productRepository,
  }) : super(ProductState(id: productId)) {
    loadProduct();
  }
  Product _newEmptyProduct() {
    return Product(
      id: 'new',
      title: '',
      price: 0,
      description: 'description',
      slug: '',
      stock: 0,
      sizes: [],
      gender: 'men',
      tags: [],
      images: [],
    );
  }

  Future<void> loadProduct() async {
    try {
      if (productId == 'new') {
        state = state.copyWith(
          isLoading: false,
          product: _newEmptyProduct(),
        );
        return;
      }

      final product = await productRepository.getProductById(productId);
      state = state.copyWith(product: product, isLoading: false);
    } catch (e) {
      print(e);
    }
  }
}

class ProductState {
  final String id;
  final Product? product;
  final bool isLoading;
  final bool isSaving;

  ProductState({
    required this.id,
    this.product,
    this.isLoading = true,
    this.isSaving = false,
  });

  ProductState copyWith({
    String? id,
    Product? product,
    bool? isLoading,
    bool? isSaving,
  }) {
    return ProductState(
      id: id ?? this.id,
      product: product ?? this.product,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
