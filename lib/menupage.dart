import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminMenuPage extends StatefulWidget {
  const AdminMenuPage({super.key});

  @override
  _AdminMenuPageState createState() => _AdminMenuPageState();
}

class _AdminMenuPageState extends State<AdminMenuPage> {
  // Controllers for the food details
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imagePathController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  // List to hold the addon inputs
  final List<Map<String, dynamic>> _addons = [];
  final TextEditingController _addonNameController = TextEditingController();
  final TextEditingController _addonPriceController = TextEditingController();

  // Function to add an addon to the list
  void _addAddon() {
    if (_addonNameController.text.isNotEmpty && _addonPriceController.text.isNotEmpty) {
      setState(() {
        _addons.add({
          'name': _addonNameController.text,
          'price': double.tryParse(_addonPriceController.text) ?? 0.0
        });
        _addonNameController.clear();
        _addonPriceController.clear();
      });
    }
  }

  // Function to remove an addon from the list
  void _removeAddon(int index) {
    setState(() {
      _addons.removeAt(index);
    });
  }

  // Function to submit the form and add the food item to Firestore
  Future<void> _submitForm() async {
    if (_nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _imagePathController.text.isEmpty ||
        _categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    final String name = _nameController.text;
    final String description = _descriptionController.text;
    final double price = double.tryParse(_priceController.text) ?? 0.0;
    final String imagePath = _imagePathController.text;
    final String category = _categoryController.text;

    // Create a food item map
    Map<String, dynamic> foodItem = {
      'name': name,
      'description': description,
      'price': price,
      'imagePath': imagePath,
      'category': category,
      'availableAddons': _addons, // Ensure consistent naming with your model
    };

    // Add the food item to Firestore
    await FirebaseFirestore.instance.collection('menu').add(foodItem);

    // Clear form after submission
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _imagePathController.clear();
    _categoryController.clear();
    setState(() {
      _addons.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Food item added successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Menu Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input fields for food item details
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Food Name'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _imagePathController,
                decoration: const InputDecoration(labelText: 'Image Path'),
              ),
              TextField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),

              const SizedBox(height: 20),

              // Section to input addons
              const Text(
                'Add Addons',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _addonNameController,
                decoration: const InputDecoration(labelText: 'Addon Name'),
              ),
              TextField(
                controller: _addonPriceController,
                decoration: const InputDecoration(labelText: 'Addon Price'),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: _addAddon,
                child: const Text('Add Addon'),
              ),

              // Display the added addons in a list
              ListView.builder(
                shrinkWrap: true,
                itemCount: _addons.length,
                itemBuilder: (context, index) {
                  final addon = _addons[index];
                  return ListTile(
                    title: Text('${addon['name']}'),
                    subtitle: Text('Price: UGX ${addon['price']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeAddon(index),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Submit button
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit Food Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
