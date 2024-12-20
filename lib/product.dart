import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

const String baseURL = 'csci410fall2023.atwebpages.com';

class Product {
  final int _id;
  final String _name;
  final int _quantity;
  final double _price;
  final String _category;

  Product(this._id, this._name, this._quantity, this._price, this._category);

  @override
  String toString() {
    return 'PID: $_id Name:${_name.toUpperCase()}\nQuantity: $_quantity Price: $_price';
  }
}

List<Product> _products = [];

List<String> categories = [
  'drinks',
  'cheese',
  'cosmetics',
  'electronics'
];

void updateProducts(Function(bool) f) async {
  try {
    _products.clear();
    final url = Uri.http(baseURL, 'getProducts.php');
    final response = await http.get(url).timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      for (var row in jsonResponse) {
        Product p = Product(int.parse(row['pid']), row['name'], int.parse(row['quantity']),
            double.parse(row['price']), row['category']);
        _products.add(p);
        f(true);
      }
    }
  }
  catch(e) {
    f(false);
  }
}

String getProducts(String category) {
  String res = '';
  for (var product in _products) {
    if (product._category == category) {
      res += '\n${product.toString()}\n';
    }
  }
  return res;
}

class CategoriesDropDown extends StatefulWidget {
  final Function(String) f;

  const CategoriesDropDown({required this.f, super.key});

  @override
  State<CategoriesDropDown> createState() => _CategoriesDropDownState();
}

class _CategoriesDropDownState extends State<CategoriesDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
        initialSelection: categories[0],
        onSelected: (category) => widget.f(category as String),
        dropdownMenuEntries: categories.map((category) => DropdownMenuEntry(value: category, label: category.toUpperCase())).toList()
    );
  }
}



