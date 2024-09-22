import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import 'my_drawer.dart';

class AdminMenuPage extends StatefulWidget {
  const AdminMenuPage({super.key});

  @override
  _AdminMenuPageState createState() => _AdminMenuPageState();
}

class _AdminMenuPageState extends State<AdminMenuPage> {
  final ImagePicker _picker = ImagePicker(); // Initialize ImagePicker
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imagePathController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  final List<Map<String, dynamic>> _addons = [];
  final TextEditingController _addonNameController = TextEditingController();
  final TextEditingController _addonPriceController = TextEditingController();

  void _addAddon() {
    if (_addonNameController.text.isNotEmpty &&
        _addonPriceController.text.isNotEmpty) {
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

  void _removeAddon(int index) {
    setState(() {
      _addons.removeAt(index);
    });
  }

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

    int categoryIndex = _convertCategoryToIndex(category);

    Map<String, dynamic> foodItem = {
      'name': name,
      'description': description,
      'price': price,
      'imagePath': imagePath,
      'category': categoryIndex,
      'availableAddons': _addons.isNotEmpty
          ? _addons.map((addon) => {
        'name': addon['name'],
        'price': addon['price'],
      }).toList()
          : [],
    };

    try {
      await FirebaseFirestore.instance.collection('menu').add(foodItem);

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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add food item: $e')),
      );
    }
  }

  int _convertCategoryToIndex(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'burgers':
        return FoodCategory.burgers.index;
      case 'salads':
        return FoodCategory.salads.index;
      case 'sides':
        return FoodCategory.sides.index;
      case 'desserts':
        return FoodCategory.desserts.index;
      case 'drinks':
        return FoodCategory.drinks.index;
      default:
        return -1;
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePathController.text = pickedFile.path; // Update the image path
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Add Menu Item',
          style: TextStyle(color: Colors.blueAccent),
        ),
      ),
      backgroundColor: Colors.white,
      drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _imagePathController,
                      decoration: const InputDecoration(labelText: 'Image Path'),
                      readOnly: true,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: _pickImage,
                  ),
                ],
              ),
              TextField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 20),
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

// Enum representing food categories
enum FoodCategory {
  burgers,
  salads,
  sides,
  desserts,
  drinks,
}
