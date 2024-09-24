import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class ViewInvoicePage extends StatelessWidget {
  final Map<String, dynamic> invoice;

  ViewInvoicePage({required this.invoice});

  @override
  Widget build(BuildContext context) {
    double totalAmount = 0;
    if (invoice['items'] != null) {
      totalAmount = (invoice['items'] as List<dynamic>).fold(0, (sum, item) {
        int quantity = int.parse(item['quantity'] ?? '0');
        double price = double.parse(item['pricePerQuantity'] ?? '0');
        return sum + (price * quantity);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(invoice['shopName'] ?? 'Shop Name'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Client Name: ${invoice['clientName'] ?? 'N/A'}',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 8),
            Text(
              'Email: ${invoice['email'] ?? 'N/A'}',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
               'Date: ${invoice['date'] != null ? DateFormat('dd/MM/yyyy').format(DateTime.parse(invoice['date'])) : 'N/A'}',
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
                      child: Text('Price per Quantity', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                ...?invoice['items']?.map<TableRow>((item) {
                  int quantity = int.parse(item['quantity'] ?? '0');
                  double price = double.parse(item['pricePerQuantity'] ?? '0');
                  double itemTotal = price * quantity;

                  return TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(item['name'] ?? 'N/A'),
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
                })?.toList() ?? [],
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
            SizedBox(height: 8),
            Text(
              'Shopkeeper: ${invoice['shopkeeperName'] ?? 'N/A'}',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _downloadPdf(invoice);
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
                      _sharePdf(invoice);
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

  // Generate and Download PDF
  Future<void> _downloadPdf(Map<String, dynamic> invoice) async {
    final pdf = _generatePdf(invoice);
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  // Share PDF
  Future<void> _sharePdf(Map<String, dynamic> invoice) async {
    final pdf = _generatePdf(invoice);
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'invoice.pdf');
  }

  // PDF Generator
  pw.Document _generatePdf(Map<String, dynamic> invoice) {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Top Header with Shop Name and Invoice
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    invoice['shopName'] ?? 'Shop Name',
                    style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    'Invoice',
                    style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              
              // Invoice to Client and Date
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Invoice to:', style: pw.TextStyle(fontSize: 18)),
                      pw.Text(invoice['clientName'] ?? 'Client Name', style: pw.TextStyle(fontSize: 16)),
                      pw.Text(invoice['email'] ?? 'Email', style: pw.TextStyle(fontSize: 16)),
                    ],
                  ),
                  pw.Text(
                    'Date: ${invoice['date'] ?? 'N/A'}',
                    style: pw.TextStyle(fontSize: 16),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              
              // Table for Items
              pw.Table.fromTextArray(
                headers: ['Item Name', 'Quantity', 'Price', 'Total'],
                data: [
                  ...invoice['items'].map<List<dynamic>>((item) {
                    return [
                      item['name'] ?? 'N/A',
                      item['quantity'] ?? '0',
                      '\$${item['pricePerQuantity'] ?? '0'}',
                      '\$${(double.parse(item['pricePerQuantity'] ?? '0') * int.parse(item['quantity'] ?? '0')).toStringAsFixed(2)}',
                    ];
                  }).toList()
                ],
              ),
              pw.SizedBox(height: 20),
              
              // Subtotal and Thank You
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text('Subtotal: \$${invoice['totalAmount'] ?? '0.00'}', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 40),
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text('Thank you!', style: pw.TextStyle(fontSize: 18)),
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }
}
