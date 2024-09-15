import 'package:flutter/material.dart';

class NewInvoicePage extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  NewInvoicePage({required this.onSubmit});

  @override
  _NewInvoicePageState createState() => _NewInvoicePageState();
}

class _NewInvoicePageState extends State<NewInvoicePage> {
  final _formKey = GlobalKey<FormState>();
  final _clientNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateController = TextEditingController();
  List<Map<String, String>> items = [];
  final _itemNameController = TextEditingController();
  final _itemPriceController = TextEditingController();
  String _status = 'unpaid'; // New status field

  void _addItem() {
    if (_itemNameController.text.isNotEmpty && _itemPriceController.text.isNotEmpty) {
      setState(() {
        items.add({
          'name': _itemNameController.text,
          'price': _itemPriceController.text,
        });
        _itemNameController.clear();
        _itemPriceController.clear();
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      double totalAmount = items.fold(0, (sum, item) => sum + double.parse(item['price']!));
      Map<String, dynamic> invoice = {
        'clientName': _clientNameController.text,
        'email': _emailController.text,
        'date': _dateController.text,
        'items': items,
        'totalAmount': totalAmount,
        'status': _status, // Add status
      };
      widget.onSubmit(invoice);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Invoice'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).hintColor),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
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
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).hintColor),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter email';
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    labelStyle: TextStyle(color: Theme.of(context).hintColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).hintColor),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter date';
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
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).hintColor),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                TextFormField(
                  controller: _itemPriceController,
                  decoration: InputDecoration(
                    labelText: 'Item Price',
                    labelStyle: TextStyle(color: Theme.of(context).hintColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).hintColor),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addItem,
                  child: Text('Add Item'),
                ),
                SizedBox(height: 20),
                ...items.map((item) => ListTile(
                      title: Text(item['name']!),
                      subtitle: Text('\$${item['price']}'),
                    )),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    labelStyle: TextStyle(color: Theme.of(context).hintColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).hintColor),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(child: Text('Unpaid'), value: 'unpaid'),
                    DropdownMenuItem(child: Text('Paid'), value: 'paid'),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _status = value!;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Save Invoice'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
