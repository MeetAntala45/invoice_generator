import 'package:flutter/material.dart';

class ViewInvoicePage extends StatelessWidget {
  final Map<String, dynamic> invoice;

  ViewInvoicePage({required this.invoice});

  @override
  Widget build(BuildContext context) {
    double totalAmount = 0;
    if (invoice['items'] != null) {
      totalAmount = (invoice['items'] as List<dynamic>)
          .fold(0, (sum, item) => sum + double.parse(item['price']));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Details'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Client Name: ${invoice['clientName']}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Email: ${invoice['email']}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Date: ${invoice['date']}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 20),
            Text(
              'Items',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...((invoice['items'] as List<dynamic>).map((item) {
              return ListTile(
                title: Text(item['name']),
                trailing: Text('\$${item['price']}'),
              );
            }).toList()),
            SizedBox(height: 20),
            Text(
              'Total Amount: \$${invoice['totalAmount']}',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Status: ${invoice['status'] == 'paid' ? 'Paid' : 'Unpaid'}',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: invoice['status'] == 'paid' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
