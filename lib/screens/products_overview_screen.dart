import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum FilterOptions {
  Favourites,All
}

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsContainer = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('MyShop', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w800),),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions val){
              if (val == FilterOptions.Favourites){
                productsContainer.showFavouritesOnly();
              }else{
                productsContainer.showAll();
              }
            },
            itemBuilder: (_)=>[
              PopupMenuItem(child: Text('Only Favourites'), value: FilterOptions.Favourites),
              PopupMenuItem(child: Text('Show All'), value: FilterOptions.All),
            ],
            icon: Icon(Icons.more_horiz, color: Theme.of(context).primaryColor,),
          )
        ],
      ),
      body: ProductsGrid(),
    );
  }
}
