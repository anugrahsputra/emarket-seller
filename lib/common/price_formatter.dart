class PriceFormatter {
  static String format(int price) {
    final formattedPrice = price.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.');
    return 'Rp. $formattedPrice';
  }
}
