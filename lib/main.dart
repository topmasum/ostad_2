import 'package:flutter/material.dart';

void main() {
  runApp(const ContactApp());
}

class ContactApp extends StatelessWidget {
  const ContactApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact List',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Rounded AppBar using ClipRRect
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), // Top-left corner rounded
                topRight: Radius.circular(30), // Top-right corner rounded
              ),
              child: Container(
                height: 100,
                // Taller app bar
                color: Colors.grey[600],
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(bottom: 15),
                child: const Text(
                  'Contact List',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),


            Padding(
              padding: const EdgeInsets.only(top: 110),
              child: ContactListPage(), // Your page content
            ),
          ],
        ),
      ),
    );
  }
}
class Contact {
  final String name;
  final String number;

  Contact(this.name, this.number);
}

class ContactListPage extends StatefulWidget {
  const ContactListPage({super.key});

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final List<Contact> _contacts = [];

  void _addContact() {
    final name = _nameController.text.trim();
    final number = _numberController.text.trim();
    if (name.isNotEmpty && number.isNotEmpty) {
      setState(() {
        _contacts.add(Contact(name, number));
      });
      _nameController.clear();
      _numberController.clear();
    }
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmation"),
        content: const Text("Are you sure for Delete?"),
        actions: [
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () => Navigator.pop(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              setState(() {
                _contacts.removeAt(index);
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile(int index) {
    final contact = _contacts[index];
    return Card(
      child: ListTile(
        onLongPress: () => _showDeleteDialog(index),
        leading: const Icon(Icons.person),
        title: Text(
          contact.name,
          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(contact.number),
        trailing: const Icon(Icons.call, color: Colors.blue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact List')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name',border: OutlineInputBorder(), ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Number',border: OutlineInputBorder(), ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _addContact,
              child: const Text('Add',style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(40),
                backgroundColor: Colors.grey[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _contacts.isEmpty
                  ? const Center(child: Text('No contacts yet.'))
                  : ListView.builder(
                itemCount: _contacts.length,
                itemBuilder: (context, index) => _buildContactTile(index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
