import 'package:flutter/material.dart';
import 'package:toko_komputer/core/model/product_model.dart';
import 'package:indonesia/indonesia.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key key,
    this.product
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Image.network(
            product.images.length > 0 ? product.images[0] : "",
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700
                  ),
                ),
                Text(
                  rupiah(product.sellPrice),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}