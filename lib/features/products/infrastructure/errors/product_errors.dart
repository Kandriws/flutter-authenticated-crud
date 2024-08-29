class ProductNotFoundError implements Exception {
  final String message;

  ProductNotFoundError(this.message);
}
