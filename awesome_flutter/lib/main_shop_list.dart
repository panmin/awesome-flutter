import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: ShopList(products: [
    Product('Eggs'),
    Product('Flour'),
    Product('Chocolate chips'),
  ])));
}

class Product {
  final String name;

  Product(this.name);
}

typedef void CartChangedCallback(Product product, bool inCart);

class ShopItem extends StatelessWidget {
  final Product product;
  final bool inCart;
  final CartChangedCallback onCartChanged;

  const ShopItem({Key key, this.product, this.inCart, this.onCartChanged}) : super(key: key);

  Color _getColor(BuildContext context) {
    return inCart ? Colors.black54 : Theme
        .of(context)
        .primaryColor;
  }

  TextStyle _getTextStyle(BuildContext context) {
    if (!inCart) return null;
    return TextStyle(color: Colors.black54, decoration: TextDecoration.lineThrough);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
        child: Text(product.name[0]),
      ),
      title: Text(product.name, style: _getTextStyle(context)),
    );
  }
}

class ShopList extends StatefulWidget {
  final List<Product> products;

  const ShopList({Key key, this.products}) : super(key: key);

  @override
  _ShopListState createState() => _ShopListState();
}

class _ShopListState extends State<ShopList> {
  Set<Product> _shoppingCart = Set<Product>();

  void _handleCartChanged(Product product, bool inCart) {
    setState(() {
      if (!inCart)
        _shoppingCart.add(product);
      else
        _shoppingCart.remove(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: widget.products.map((product) {
          return ShopItem(product: product, inCart: _shoppingCart.contains(product), onCartChanged: _handleCartChanged);
        }).toList(),
      ),
    );
  }
}
