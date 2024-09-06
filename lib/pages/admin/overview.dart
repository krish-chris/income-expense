import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  double totalIncome = 0.0;
  double totalExpense = 0.0;

  @override
  void initState() {
    super.initState();
    calculateTotals();
  }

  Future<void> calculateTotals() async {
    try {
      double income = 0.0;
      double expense = 0.0;

      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('usersData').get();

      for (var documentSnapshot in snapshot.docs) {
        if (documentSnapshot['isApproved'] == true) {
          String amountStr = documentSnapshot['amount'];
          double amount = double.parse(amountStr);

          if (documentSnapshot['incomeexpense'] == 'income') {
            income += amount;
          } else if (documentSnapshot['incomeexpense'] == 'expense') {
            expense += amount;
          }
        }
      }

      setState(() {
        totalIncome = income;
        totalExpense = expense;
      });
    } catch (e) {
      print('Error calculating totals: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('usersData').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                        snapshot.data!.docs[index];

                        if (documentSnapshot['isApproved'] == true) {
                          return Material(
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white24,
                                  ),
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            documentSnapshot['description'],
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            documentSnapshot['amount'],
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            documentSnapshot['incomeexpense'],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    );
                  }

                  return const Center(
                    child: Text('No data available'),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text('Total income is \$$totalIncome'),
                  Text('Total expense is \$$totalExpense'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
