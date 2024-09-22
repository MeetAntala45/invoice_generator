import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data'; // Import this for Uint8List
import 'dart:io'; // Import for mobile devices

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String name = '';
  String shopName = '';
  String email = '';
  String profilePicUrl = '';
  bool isUploading = false;

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
          profilePicUrl = userDoc['profilePic'] ?? '';
        });
      }
    }
  }

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (kIsWeb) {
        // Web-specific code
        Uint8List imageBytes = await image.readAsBytes();
        _uploadProfilePicture(imageBytes); // For web
      } else {
        // Mobile-specific code
        File mobileImage = File(image.path);
        _uploadProfilePicture(mobileImage); // For mobile
      }
    }
  }

  // Function to upload image to Firebase Storage
  Future<void> _uploadProfilePicture(dynamic image) async {
    setState(() {
      isUploading = true;
    });

    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        String uid = currentUser.uid;
        Reference storageRef =
            _storage.ref().child('profilePictures').child('$uid.jpg');

        UploadTask uploadTask;
        if (kIsWeb) {
          // For Web: upload using raw byte data
          uploadTask = storageRef.putData(image);
        } else {
          // For Mobile: upload using local File
          uploadTask = storageRef.putFile(image);
        }

        TaskSnapshot taskSnapshot = await uploadTask;

        // Get the download URL
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        // Update Firestore with the new profile picture URL
        await _firestore.collection('users').doc(uid).update({
          'profilePic': downloadUrl,
        });

        // Update local state
        setState(() {
          profilePicUrl = downloadUrl;
        });
      }
    } catch (e) {
      print('Error uploading profile picture: $e');
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  // Function to delete profile picture
  Future<void> _deleteProfilePicture() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      String uid = currentUser.uid;

      try {
        // Delete from Firebase Storage
        await _storage.ref().child('profilePictures').child('$uid.jpg').delete();

        // Remove the profile picture URL from Firestore
        await _firestore.collection('users').doc(uid).update({
          'profilePic': FieldValue.delete(),
        });

        // Update local state
        setState(() {
          profilePicUrl = '';
        });
      } catch (e) {
        print('Error deleting profile picture: $e');
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
            isUploading
                ? CircularProgressIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Add or Change Photo Button
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: Icon(Icons.camera_alt),
                        label: Text('Change Photo'),
                      ),
                      SizedBox(width: 10),
                      // Delete Photo Button
                      profilePicUrl.isNotEmpty
                          ? ElevatedButton.icon(
                              onPressed: _deleteProfilePicture,
                              icon: Icon(Icons.delete),
                              label: Text('Delete Photo'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                            )
                          : Container(),
                    ],
                  ),
            SizedBox(height: 20),
            // Name
            Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium,
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
            // Shop Name
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
