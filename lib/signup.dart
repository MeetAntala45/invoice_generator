import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _shopNameController = TextEditingController();
  final _profilePicController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _signup() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Create the user with email and password
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Store additional user information in Firestore
        await _firestore.collection('users').doc(userCredential.user?.uid).set({
          'name': _nameController.text,
          'shopName': _shopNameController.text,
          'email': _emailController.text,
          //'profilePic': _profilePicController.text,
        });

        // Navigate to the login screen
        Navigator.pushReplacementNamed(context, '/login');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    hintStyle: TextStyle(color: Theme.of(context).hintColor),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).hintColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _shopNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your shop name',
                    hintStyle: TextStyle(color: Theme.of(context).hintColor),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).hintColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Shop name cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(color: Theme.of(context).hintColor),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).hintColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(color: Theme.of(context).hintColor),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).hintColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // TextFormField(
                //   controller: _profilePicController,
                //   decoration: InputDecoration(
                //     hintText: 'Enter profile picture URL',
                //     hintStyle: TextStyle(color: Theme.of(context).hintColor),
                //     filled: true,
                //     fillColor: Theme.of(context).cardColor,
                //     enabledBorder: OutlineInputBorder(
                //       borderSide: BorderSide(color: Theme.of(context).hintColor),
                //     ),
                //     focusedBorder: OutlineInputBorder(
                //       borderSide: BorderSide(color: Theme.of(context).primaryColor),
                //     ),
                //   ),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Profile picture URL cannot be empty';
                //     }
                //     return null;
                //   },
                // ),
                // SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Sign Up', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
