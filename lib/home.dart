import 'package:flutter/material.dart';
import 'product.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _load = false;
  String _filteredProducts = '';

  void update(bool success) {
    setState(() {
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('failed to load data')));
      }
      _load = true;
      _filteredProducts = getProducts('drinks');
    });
  }

  void updateCategory(String category) {
    setState(() {
      _filteredProducts = getProducts(category);
    });
  }

  @override
  void initState() {
    updateProducts(update);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show Items'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white
      ),
      body: _load ? Center(child: Column(children: [
        const SizedBox(height: 10),
        const Text('Select Category', style: const TextStyle(fontSize: 20)),
        CategoriesDropDown(f: updateCategory),
        const SizedBox(height: 10),
        Container(color: Colors.black,
        child: Text(_filteredProducts, style: const TextStyle(fontSize: 18, color: Colors.white)))
      ]))
          : const Center(child: CircularProgressIndicator())
    );
  }
}
