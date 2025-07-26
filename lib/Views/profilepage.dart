import 'package:flutter/material.dart';
import 'package:kuantan_tour_app/JsonModels/users.dart';
import 'package:kuantan_tour_app/SQLite/sqlite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  void fetchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');

    if (id != null) {
      final db = await DatabaseHelper.instance.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'user',
        where: 'userid = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        final Map<String, dynamic> userData = maps.first;
        final Users user = Users.fromMap(userData);

        print(user);

        setState(() {
          _nameController.text = user.name ?? '';
          _emailController.text = user.email ?? '';
          _phoneController.text = user.phone.toString();
          _passwordController.text = user.password;
        });
      } else {
        // Handle error: User not found
      }
    } else {
      // Handle error: User ID not found in SharedPreferences
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!isValidEmail(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  // You can add more phone number validation logic here if needed
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  // You can add more password validation logic here if needed
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateProfile();
                  }
                },
                child: const Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');

    if (id != null) {
      final db = await DatabaseHelper.instance.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'user',
        where: 'userid = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        final Map<String, dynamic> userData = maps.first;
        final Users existingUser = Users.fromMap(userData);

        final updatedUser = Users(
          userId: existingUser.userId,
          username: existingUser.username, // Preserve existing username
          name: _nameController.text,
          email: _emailController.text,
          phone: int.parse(_phoneController.text),
          password: _passwordController.text,
        );

        await db.update(
          'user',
          updatedUser.toMap(),
          where: 'userid = ?',
          whereArgs: [id],
        );

        // Show feedback dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Update Successful'),
            content: const Text('Your Profile has been updated!'),
            actions: [
              TextButton(
                onPressed: () {
                  // Navigate to another screen or close the dialog
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
