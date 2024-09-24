import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data'; // For Uint8List
import 'dart:io'; // For mobile devices

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
        Uint8List imageBytes = await image.readAsBytes();
        _uploadProfilePicture(imageBytes); // For web
      } else {
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
          uploadTask = storageRef.putData(image);
        } else {
          uploadTask = storageRef.putFile(image);
        }

        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        // Update Firestore with the new profile picture URL
        await _firestore.collection('users').doc(uid).update({
          'profilePic': downloadUrl,
        });
        // Update local state
        setState(() {
          profilePicUrl = downloadUrl;
        });
        print('$profilePicUrl');

      }
    } catch (e) {
      print('Error uploading profile picture: $e');
    } finally {
      setState(() {
        isUploading = false;
      });
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
            // Larger Profile Picture
            CircleAvatar(
              radius: 70, // Increased radius
              backgroundImage: profilePicUrl.isNotEmpty
                  ? NetworkImage(profilePicUrl)
                  : AssetImage('assets/user.webp') as ImageProvider,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
              onBackgroundImageError: (_, __) {
                // Error handling if image fails to load
                print('Error loading profile picture.');
              },
            ),
            SizedBox(height: 20),
            isUploading
                ? CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.camera_alt),
                    label: Text('Update Photo'),
                  ),
            SizedBox(height: 20),
            // Name
            Text(
              name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10),
            // Shop Name
            Text(
              'Shop: $shopName',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 10),
            // Email
            Text(
              email,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
