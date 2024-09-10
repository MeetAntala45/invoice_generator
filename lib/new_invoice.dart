import 'package:flutter/material.dart';

class NewInvoicePage extends StatefulWidget {
  final Function(Map<String, String>) onSubmit;

  NewInvoicePage({required this.onSubmit});

  @override
  _NewInvoicePageState createState() => _NewInvoicePageState();
}

class _NewInvoicePageState extends State<NewInvoicePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit({
        'name': _nameController.text,
        'date': DateTime.now().toString().split(' ')[0],
        'invoice': 'INV-${DateTime.now().millisecondsSinceEpoch}',
        'amount': '₹${_amountController.text}',
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[200],
        title: Text('New Invoice'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Customer Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
