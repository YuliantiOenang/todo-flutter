import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:users/model/user.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _addUser(User user) async {
    await _firestore.collection('users').add(user.toMap());
  }

  Future<void> _updateUser(User user) async {
    await _firestore.collection('users').doc(user.id).update(user.toMap());
  }

  Future<void> _deleteUser(String docId) async {
    await _firestore.collection('users').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              User user = User.fromMap(
                doc.data() as Map<String, dynamic>,
                doc.id,
              );

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text(user.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.title),
                      Text(user.company),
                    ],
                  ),
                  onTap: () => _showEditUserDialog(user),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteUser(user.id!),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddUserDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showEditUserDialog(User user) {
    String name = user.name;
    String title = user.title;
    String company = user.company;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit User'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  autofocus: true,
                  controller: TextEditingController(text: name),
                  onChanged: (value) => name = value,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter name',
                  ),
                ),
                TextField(
                  controller: TextEditingController(text: title),
                  onChanged: (value) => title = value,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter title',
                  ),
                ),
                TextField(
                  controller: TextEditingController(text: company),
                  onChanged: (value) => company = value,
                  decoration: const InputDecoration(
                    labelText: 'Company',
                    hintText: 'Enter company name',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (name.isNotEmpty) {
                  final updatedUser = User(
                    id: user.id,
                    name: name,
                    title: title,
                    company: company,
                  );
                  _updateUser(updatedUser);
                  Navigator.pop(context);
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showAddUserDialog() {
    String name = '';
    String title = '';
    String company = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New User'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  autofocus: true,
                  onChanged: (value) => name = value,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter name',
                  ),
                ),
                TextField(
                  onChanged: (value) => title = value,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter title',
                  ),
                ),
                TextField(
                  onChanged: (value) => company = value,
                  decoration: const InputDecoration(
                    labelText: 'Company',
                    hintText: 'Enter company name',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (name.isNotEmpty) {
                  final user = User(
                    name: name,
                    title: title,
                    company: company,
                  );
                  _addUser(user);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
