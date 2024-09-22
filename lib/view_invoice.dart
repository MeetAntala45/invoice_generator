import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Email: ${invoice['email']}',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(invoice['date']))}',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Items',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(thickness: 2),
            Expanded(
              child: ListView.builder(
                itemCount: (invoice['items'] as List<dynamic>).length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(invoice['items'][index]['name']),
                    trailing: Text('\$${invoice['items'][index]['price']}'),
                  );
                },
              ),
            ),
            Divider(thickness: 2),
            SizedBox(height: 16),
            Text(
              'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Status: ${invoice['status'] == 'paid' ? 'Paid' : 'Unpaid'}',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: invoice['status'] == 'paid' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Implement download functionality here
                  },
                  icon: Icon(Icons.download),
                  label: Text('Download'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Implement share functionality here
                  },
                  icon: Icon(Icons.share),
                  label: Text('Share via Email'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
