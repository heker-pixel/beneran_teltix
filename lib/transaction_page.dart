import 'package:flutter/material.dart';
import 'db_helper.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final DBHelper dbHelper = DBHelper();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ticketNameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    final data = await dbHelper.queryAll('transactions');
    setState(() {
      transactions = data;
    });
  }

  Future<void> addTransaction() async {
    final ticketStock = (await dbHelper.queryAll('ticket_stocks')).firstWhere(
      (stock) => stock['namaTiket'] == ticketNameController.text,
      orElse: () => {'jumlah': 0},
    );

    if (ticketStock['jumlah'] >= int.parse(amountController.text)) {
      await dbHelper.update(
        'ticket_stocks',
        {'jumlah': ticketStock['jumlah'] - int.parse(amountController.text)},
        'id = ?',
        [ticketStock['id']],
      );

      await dbHelper.insert('transactions', {
        'kodeTransaksi': 'TX-${DateTime.now().millisecondsSinceEpoch}',
        'email': emailController.text,
        'namaTiket': ticketNameController.text,
        'date': DateTime.now().toIso8601String(),
        'amount': int.parse(amountController.text),
      });

      for (int i = 0; i < int.parse(amountController.text); i++) {
        await dbHelper.insert('printed_tickets', {
          'kodeTiket': 'TK-${DateTime.now().millisecondsSinceEpoch + i}',
          'namaTiket': ticketNameController.text,
          'date': DateTime.now().toIso8601String(),
        });
      }

      fetchTransactions();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Transaction successful!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Not enough tickets available')));
    }

    emailController.clear();
    ticketNameController.clear();
    amountController.clear();
  }

  Future<void> deleteTransaction(int id) async {
    await dbHelper.delete('transactions', 'id = ?', [id]);
    fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(transactions[index]['namaTiket']),
                  subtitle: Text(
                      'User: ${transactions[index]['email']} - Date: ${transactions[index]['date']} - Amount: ${transactions[index]['amount']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteTransaction(transactions[index]['id']);
                    },
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
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: ticketNameController,
                  decoration: InputDecoration(labelText: 'Ticket Name'),
                ),
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: addTransaction,
                  child: Text('Add Transaction'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
