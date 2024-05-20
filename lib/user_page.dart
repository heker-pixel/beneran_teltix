import 'package:flutter/material.dart';
import 'db_helper.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final DBHelper dbHelper = DBHelper();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController levelController = TextEditingController();
  List<Map<String, dynamic>> users = [];
  bool isUpdating = false;
  int? updatingUserId;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final data = await dbHelper.queryAll('users');
    setState(() {
      users = data;
    });
  }

  Future<void> addUser() async {
    await dbHelper.insert('users', {
      'email': emailController.text,
      'password': passwordController.text,
      'level': levelController.text,
    });
    emailController.clear();
    passwordController.clear();
    levelController.clear();
    fetchUsers();
  }

  Future<void> updateUser(int id) async {
    await dbHelper.update(
        'users',
        {
          'email': emailController.text,
          'password': passwordController.text,
          'level': levelController.text,
        },
        'id = ?',
        [id]);
    emailController.clear();
    passwordController.clear();
    levelController.clear();
    fetchUsers();
    setState(() {
      isUpdating = false;
      updatingUserId = null;
    });
  }

  Future<void> deleteUser(int id) async {
    await dbHelper.delete('users', 'id = ?', [id]);
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(users[index]['email']),
                  subtitle: Text('Level: ${users[index]['level']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            emailController.text = users[index]['email'];
                            passwordController.text = users[index]['password'];
                            levelController.text = users[index]['level'];
                            isUpdating = true;
                            updatingUserId = users[index]['id'];
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deleteUser(users[index]['id']);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                TextField(
                  controller: levelController,
                  decoration: InputDecoration(labelText: 'Level (admin/user)'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (isUpdating && updatingUserId != null) {
                      updateUser(updatingUserId!);
                    } else {
                      addUser();
                    }
                  },
                  child: Text(isUpdating ? 'Update User' : 'Add User'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
