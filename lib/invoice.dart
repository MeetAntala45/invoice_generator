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
  final _itemQuantityController = TextEditingController(text: '1');
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
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  controller: _clientNameController,
                  label: 'Client Name',
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter client name' : null,
                ),
                SizedBox(height: 20),
                _buildTextField(
                  controller: _emailController,
                  label: 'Client Email',
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter email' : null,
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Add Items',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                _buildTextField(
                  controller: _itemNameController,
                  label: 'Item Name',
                ),
                SizedBox(height: 20),
                _buildTextField(
                  controller: _itemPriceController,
                  label: 'Item Price',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                _buildTextField(
                  controller: _itemQuantityController,
                  label: 'Item Quantity',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Add Item',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                ...items
                    .map((item) => ListTile(
                          title: Text(item['name']!),
                          subtitle: Text(
                            '\u{20B9}${item['price']} x ${item['quantity']} = \u{20B9}${(double.parse(item['price']!) * int.parse(item['quantity']!)).toStringAsFixed(2)}',
                          ),
                        ))
                    .toList(),
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: _buildInputDecoration('Status'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _status = newValue!;
                    });
                  },
                  items: <String>['unpaid', 'paid']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Save Invoice',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _buildInputDecoration(label),
      validator: validator,
      keyboardType: keyboardType,
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: const Color.fromARGB(255, 66, 66, 66)),
      filled: true,
      fillColor: Colors.grey[200],
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: const Color.fromARGB(255, 113, 113, 113)),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
