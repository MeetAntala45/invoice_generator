import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String name = '';
  String shopName = '';
  String email = '';
  String profilePicUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      String uid = currentUser.uid;
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        setState(() {
          name = userDoc['name'];
          shopName = userDoc['shopName'];
          email = userDoc['email'];
          // profilePicUrl = userDoc['profilePic'] ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 50,
              backgroundImage: profilePicUrl.isNotEmpty
                  ? NetworkImage(profilePicUrl)
                  : AssetImage('assets/user.webp') as ImageProvider,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
            ),
            SizedBox(height: 20),
            // Name
            Text(
              name,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          
            SizedBox(height: 20),
            // Email
            Card(
              color: Theme.of(context).cardColor,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(Icons.email, color: Theme.of(context).primaryColor),
                title: Text(
                  email,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              color: Theme.of(context).cardColor,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(Icons.store, color: Theme.of(context).primaryColor),
                title: Text(
                  'Shop: $shopName',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
