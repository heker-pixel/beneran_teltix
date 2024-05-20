import 'package:flutter/material.dart';
import 'db_helper.dart';

class TicketStockPage extends StatefulWidget {
  @override
  _TicketStockPageState createState() => _TicketStockPageState();
}

class _TicketStockPageState extends State<TicketStockPage> {
  final DBHelper dbHelper = DBHelper();
  final TextEditingController ticketNameController = TextEditingController();
  final TextEditingController ticketAmountController = TextEditingController();
  List<Map<String, dynamic>> ticketStocks = [];
  bool isUpdating = false;
  int? updatingTicketStockId;

  @override
  void initState() {
    super.initState();
    fetchTicketStocks();
  }

  Future<void> fetchTicketStocks() async {
    final data = await dbHelper.queryAll('ticket_stocks');
    setState(() {
      ticketStocks = data;
    });
  }

  Future<void> addTicketStock() async {
    await dbHelper.insert('ticket_stocks', {
      'namaTiket': ticketNameController.text,
      'jumlah': int.parse(ticketAmountController.text),
    });
    ticketNameController.clear();
    ticketAmountController.clear();
    fetchTicketStocks();
  }

  Future<void> updateTicketStock(int id) async {
    await dbHelper.update(
        'ticket_stocks',
        {
          'namaTiket': ticketNameController.text,
          'jumlah': int.parse(ticketAmountController.text),
        },
        'id = ?',
        [id]);
    ticketNameController.clear();
    ticketAmountController.clear();
    fetchTicketStocks();
    setState(() {
      isUpdating = false;
      updatingTicketStockId = null;
    });
  }

  Future<void> deleteTicketStock(int id) async {
    await dbHelper.delete('ticket_stocks', 'id = ?', [id]);
    fetchTicketStocks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket Stock'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: ticketStocks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(ticketStocks[index]['namaTiket']),
                  subtitle: Text('Available: ${ticketStocks[index]['jumlah']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            ticketNameController.text =
                                ticketStocks[index]['namaTiket'];
                            ticketAmountController.text =
                                ticketStocks[index]['jumlah'].toString();
                            isUpdating = true;
                            updatingTicketStockId = ticketStocks[index]['id'];
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deleteTicketStock(ticketStocks[index]['id']);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: ticketNameController,
                  decoration: InputDecoration(labelText: 'Ticket Name'),
                ),
                TextField(
                  controller: ticketAmountController,
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (isUpdating && updatingTicketStockId != null) {
                      updateTicketStock(updatingTicketStockId!);
                    } else {
                      addTicketStock();
                    }
                  },
                  child: Text(
                      isUpdating ? 'Update Ticket Stock' : 'Add Ticket Stock'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
