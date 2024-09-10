import 'package:flutter/material.dart';
import 'new_invoice.dart';
import 'invoices.dart';
import 'profile.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> recentTransactions = [];

  void _addInvoice(Map<String, String> invoice) {
    setState(() {
      recentTransactions.add(invoice);
    });
  }

  void _navigateTo(String route) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          switch (route) {
            case 'invoices':
              return InvoicesPage(invoices: recentTransactions);
            case 'profile':
              return ProfilePage();
            case 'login':
              return LoginPage();
            default:
              return HomePage();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF3F6),
      appBar: AppBar(
        title: Text('Invoice Generator'),
        backgroundColor: Colors.blueGrey[200],
        elevation: 0,
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
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () => _navigateTo('dashboard'),
            ),
            ListTile(
              leading: Icon(Icons.receipt_long),
              title: Text('View Invoices'),
              onTap: () => _navigateTo('invoices'),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () => _navigateTo('profile'),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
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
              style: TextStyle(
                fontSize: 18,
              ),
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
                    Text(
                      'New Invoice',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      width: double.infinity, 

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Invoices',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          ...recentTransactions.map((invoice) => _buildTransactionItem(
                invoice['name']!,
                invoice['date']!,
                invoice['invoice']!,
                invoice['amount']!,
              )),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
      String name, String date, String invoice, String amount) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue.withOpacity(0.1),
        child: Icon(
          Icons.insert_drive_file,
          color: Colors.blue,
        ),
      ),
      title: Text(name),
      subtitle: Text('$date • $invoice'),
      trailing: Text(
        amount,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
