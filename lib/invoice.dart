import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewInvoicePage extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  NewInvoicePage({required this.onSubmit});

  @override
  _NewInvoicePageState createState() => _NewInvoicePageState();
}

class _NewInvoicePageState extends State<NewInvoicePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _clientNameController = TextEditingController();
  final _emailController = TextEditingController();
  List<Map<String, dynamic>> items = [];
  final _itemNameController = TextEditingController();
  final _itemPriceController = TextEditingController();
  final _itemQuantityController = TextEditingController(text: '1'); // Default quantity to 1
  String _status = 'unpaid';
  User? user;
  String? uid;
  String? shopName;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    uid = user?.uid;

    if (uid != null) {
      _fetchShopName();
    }
  }

  Future<void> _fetchShopName() async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        setState(() {
          shopName = userDoc['shopName'];
        });
      }
    } catch (e) {
      print('Error fetching shopName: $e');
    }
  }

  void _addItem() {
    if (_itemNameController.text.isNotEmpty &&
        _itemPriceController.text.isNotEmpty &&
        _itemQuantityController.text.isNotEmpty) {
      setState(() {
        items.add({
          'name': _itemNameController.text,
          'price': _itemPriceController.text,
          'quantity': _itemQuantityController.text,
        });
        _itemNameController.clear();
        _itemPriceController.clear();
        _itemQuantityController.text = '1';
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        double totalAmount = items.fold(0, (sum, item) {
          double price = double.parse(item['price']!);
          int quantity = int.parse(item['quantity']!);
          return sum + (price * quantity);
        });

        Map<String, dynamic> invoiceData = {
          'clientName': _clientNameController.text,
          'email': _emailController.text,
          'items': items,
          'status': _status,
          'date': DateTime.now().toIso8601String(),
          'totalAmount': totalAmount,
          'shopName': shopName,
        };

        await _firestore.collection('invoices').add({
          'shopkeeperId': uid,
          'invoiceData': invoiceData,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invoice saved successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save invoice: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Invoice'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _clientNameController,
                  decoration: InputDecoration(
                    labelText: 'Client Name',
                    labelStyle: TextStyle(color: Theme.of(context).hintColor),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).hintColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter client name';
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Theme.of(context).hintColor),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).hintColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter email';
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'Add Items',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _itemNameController,
                  decoration: InputDecoration(
                    labelText: 'Item Name',
                    labelStyle: TextStyle(color: Theme.of(context).hintColor),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).hintColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                ),
                TextFormField(
                  controller: _itemPriceController,
                  decoration: InputDecoration(
                    labelText: 'Item Price',
                    labelStyle: TextStyle(color: Theme.of(context).hintColor),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).hintColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _itemQuantityController,
                  decoration: InputDecoration(
                    labelText: 'Item Quantity',
                    labelStyle: TextStyle(color: Theme.of(context).hintColor),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).hintColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Add Item',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                ...items.map((item) => ListTile(
                      title: Text(item['name']!),
                      subtitle: Text(
                          '\u{20B9}${item['price']} x ${item['quantity']} = \u{20B9}${(double.parse(item['price']!) * int.parse(item['quantity']!)).toStringAsFixed(2)}'),
                    )),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    labelStyle: TextStyle(color: Theme.of(context).hintColor),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).hintColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: <String>['paid', 'unpaid']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _status = newValue!;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Submit Invoice',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
