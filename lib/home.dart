import 'package:flutter/material.dart';
import 'invoice.dart';
import 'view_invoice.dart';
import 'profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> recentTransactions = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String shopName = '';

  @override
  void initState() {
    super.initState();
    _fetchRecentInvoices();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (userDoc.exists) {
        setState(() {
          shopName = userDoc['shopName'];
        });
      }
    }
  }

  Future<void> _fetchRecentInvoices() async {
    User? user = _auth.currentUser;
    String? uid = user?.uid;

    if (uid != null) {
      try {
        QuerySnapshot snapshot = await _firestore
            .collection('invoices')
            .where('shopkeeperId', isEqualTo: uid) // Fetch invoices for the logged-in user
            .orderBy('invoiceData.date', descending: true) // Order by date, most recent first
            .get();

        setState(() {
          recentTransactions = snapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return {
              'clientName': data['invoiceData']['clientName'],
              'email': data['invoiceData']['email'],
              'items': data['invoiceData']['items'],
              'status': data['invoiceData']['status'],
              'date': data['invoiceData']['date'], // ISO date string
              'totalAmount': data['invoiceData']['totalAmount'],
              'shopName': data['invoiceData']['shopName'],
            };
          }).toList();
        });
      } catch (e) {
        print('Error fetching invoices: $e');
      }
    }
  }

  void _addInvoice(Map<String, dynamic> invoice) {
    setState(() {
      recentTransactions.add(invoice);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(shopName),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Menu',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                _auth.signOut();
                Navigator.of(context).pop(); // Close the drawer
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Click Here to Generate New Invoice',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewInvoicePage(onSubmit: _addInvoice),
                    ),
                  );
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      child: Icon(
                        Icons.note_add,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('New Invoice', style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildRecentTransactions(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 243, 243, 243),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Invoices',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: recentTransactions.length,
                itemBuilder: (context, index) {
                  return _buildTransactionItem(recentTransactions[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> invoice) {
    return Card(
      color: Color.fromARGB(255, 233, 233, 233),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          invoice['clientName'],
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Color.fromARGB(255, 0, 0, 0),
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(invoice['date']))}', // Format the date
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
            ),
            Text(
              'Total: \u{20B9}${invoice['totalAmount'].toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
            ),
          ],
        ),
        trailing: Text(
          invoice['status'] == 'paid' ? 'Paid' : 'Unpaid',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: invoice['status'] == 'paid' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewInvoicePage(invoice: invoice),
            ),
          );
        },
      ),
    );
  }
}
