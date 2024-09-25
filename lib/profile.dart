import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'dart:io';

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


        await _firestore.collection('users').doc(uid).update({
          'profilePic': downloadUrl,
        });
        setState(() {
          profilePicUrl = downloadUrl;
        });
        print('$profilePicUrl');
        _fetchUserData();
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
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundImage: profilePicUrl.isNotEmpty
                    ? NetworkImage(profilePicUrl)
                    : AssetImage('assets/user.webp') as ImageProvider,
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.2),
                child: profilePicUrl.isEmpty
                    ? Icon(
                        Icons.person,
                        size: 50,
                        color: Theme.of(context).primaryColor.withOpacity(0.7),
                      )
                    : null,
              ),
            ),
            SizedBox(height: 20),
            isUploading
                ? CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.camera_alt),
                    label: Text('Update Photo'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24.0),
                    ),
                  ),
            SizedBox(height: 20),
            Text(
              name.isNotEmpty ? name : 'Your Name',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            SizedBox(height: 10),
            Text(
              shopName.isNotEmpty ? 'Shop: $shopName' : 'Shop Name',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
            ),
            SizedBox(height: 10),
            Text(
              email.isNotEmpty ? email : 'Email',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
            SizedBox(height: 40),
            
          ],
        ),
      ),
    );
  }
}
