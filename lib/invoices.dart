import 'package:flutter/material.dart';

class InvoicesPage extends StatelessWidget {
  final List<Map<String, String>> invoices;

  InvoicesPage({required this.invoices});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[200],
        title: Text('All Invoices'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: invoices.length,
        itemBuilder: (context, index) {
          final invoice = invoices[index];
          return ListTile(
            leading: Icon(Icons.insert_drive_file),
            title: Text(invoice['name']!),
            subtitle: Text('${invoice['date']}  ${invoice['invoice']}'),
            trailing: Text(invoice['amount']!,
                style: TextStyle(fontWeight: FontWeight.bold)),
          );
        },
      ),
    );
  }
}
