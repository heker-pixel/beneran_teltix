import 'package:flutter/material.dart';
import 'db_helper.dart';

class PrintTicketsPage extends StatefulWidget {
  @override
  _PrintTicketsPageState createState() => _PrintTicketsPageState();
}

class _PrintTicketsPageState extends State<PrintTicketsPage> {
  final DBHelper dbHelper = DBHelper();
  List<Map<String, dynamic>> printedTickets = [];

  @override
  void initState() {
    super.initState();
    fetchPrintedTickets();
  }

  Future<void> fetchPrintedTickets() async {
    final data = await dbHelper.queryAll('printed_tickets');
    setState(() {
      printedTickets = data;
    });
  }

  Future<void> deletePrintedTicket(int id) async {
    await dbHelper.delete('printed_tickets', 'id = ?', [id]);
    fetchPrintedTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Printed Tickets'),
      ),
      body: ListView.builder(
        itemCount: printedTickets.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(printedTickets[index]['namaTiket']),
            subtitle: Text(
                'Ticket Code: ${printedTickets[index]['kodeTiket']} - Date: ${printedTickets[index]['date']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                deletePrintedTicket(printedTickets[index]['id']);
              },
            ),
          );
        },
      ),
    );
  }
}
