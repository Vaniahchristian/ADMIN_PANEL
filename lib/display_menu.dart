import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DisplayMenuPage extends StatelessWidget {
  const DisplayMenuPage({super.key});

  // Function to retrieve menu items from Firestore
  Stream<QuerySnapshot> getMenuItems() {
    return FirebaseFirestore.instance.collection('menu').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Menu'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getMenuItems(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // If the snapshot has data, display it in a list
          final menuItems = snapshot.data?.docs ?? [];

          if (menuItems.isEmpty) {
            return const Center(
              child: Text('No menu items found.'),
            );
          }

          return ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final menuItem = menuItems[index];
              final String name = menuItem['name'] ?? 'Unknown';
              final String description = menuItem['description'] ?? 'No description';
              final double price = menuItem['price'] ?? 0.0;
              final String imagePath = menuItem['imagePath'] ?? '';
              final List<dynamic> addons = menuItem['addons'] ?? [];

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: imagePath.isNotEmpty
                      ? Image.network(
                    imagePath,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                      : const Icon(Icons.fastfood),
                  title: Text(name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(description),
                      Text('Price: UGX $price'),
                      const SizedBox(height: 5),
                      const Text(
                        'Addons:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      for (var addon in addons)
                        Text(
                          '${addon['name']} - UGX ${addon['price']}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
