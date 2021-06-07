import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/products-details';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute
        .of(context)
        .settings
        .arguments as String;
    Product product =
    Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      /*appBar: AppBar(
        title: Text(product.title),
      ),*/
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                title: Text(product.title), background: Hero(
              tag: product.id,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),),
          ),
          SliverList(delegate: SliverChildListDelegate([
            SizedBox(
              height: 10,
            ),
            Text(
              'KES: ${product.price}',
              style: TextStyle(color: Colors.grey, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                product.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            SizedBox(height: 800,)
          ]))
        ],
      ),
    );
  }
}
