import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewInvoicePage extends StatelessWidget {
  final Map<String, dynamic> invoice;

  ViewInvoicePage({required this.invoice});

  @override
  Widget build(BuildContext context) {
    double totalAmount = 0;
    if (invoice['items'] != null) {
      totalAmount = (invoice['items'] as List<dynamic>).fold(0, (sum, item) {
        int quantity = int.parse(item['quantity']);
        double price = double.parse(item['price']);
        return sum + (price * quantity);
      });
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
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Divider(thickness: 2),
            Table(
              columnWidths: {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
              },
              border: TableBorder.all(color: const Color.fromARGB(255, 199, 199, 199), width: 1),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: const Color.fromARGB(255, 112, 112, 112)),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Item Name', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                ...invoice['items'].map<TableRow>((item) {
                  int quantity = int.parse(item['quantity']);
                  double price = double.parse(item['price']);
                  double itemTotal = price * quantity;

                  return TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(item['name']),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(quantity.toString()),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('\$${price.toStringAsFixed(2)}'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('\$${itemTotal.toStringAsFixed(2)}'),
                    ),
                  ]);
                }).toList(),
              ],
            ),
            Divider(thickness: 2),
            SizedBox(height: 16),
            Text(
              'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
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
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Implement download functionality here
                    },
                    icon: Icon(Icons.download),
                    label: Text('Download'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Implement share functionality here
                    },
                    icon: Icon(Icons.share),
                    label: Text('Share via Email'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
