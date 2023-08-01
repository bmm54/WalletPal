import 'package:bstable/sql/sql_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TransactionModel {
  final String senderId;
  final String receiverId;
  final double amount;
  final String time;

  TransactionModel({
    required this.senderId,
    required this.receiverId,
    required this.amount,
    required this.time,
  });

  // Convert Firestore snapshot to TransactionModel
  factory TransactionModel.fromSnapshot(DocumentSnapshot snapshot) {
    return TransactionModel(
      senderId: snapshot['senderId'],
      receiverId: snapshot['receiverId'],
      amount: snapshot['amount'],
      time: snapshot['time'],
    );
  }
}

class Transactions {
  static void createTransaction(
      String senderId, String receiverId, double amount) async {
    try {
      CollectionReference transactionsRef =
          FirebaseFirestore.instance.collection('transactions');
      DocumentReference docRef = await transactionsRef.add({
        'senderId': senderId,
        'receiverId': receiverId,
        'time': DateTime.now().toString(),
        'amount': amount,
      });

      String transactionId = docRef.id;
      print('Transaction document created with ID: $transactionId');
      docRef.isBlank!
          ? null
          : await SQLHelper.insertActivity("Sent", "expense", amount);
    } catch (e) {
      print(e);
    }
  }

  // Receiver listens for changes from Firestore
  static void startListeningForTransactions(String receiverId) {
    FirebaseFirestore.instance
        .collection('transactions')
        .where('receiverId', isEqualTo: receiverId)
        .snapshots()
        .listen((QuerySnapshot snapshot) async {
      final transactions = snapshot.docs
          .map((DocumentSnapshot doc) => TransactionModel.fromSnapshot(doc))
          .toList();
      if (transactions.isNotEmpty) {
        print("transaction received");
        print(transactions.toString());
        for (final transaction in transactions) {
          await SQLHelper.insertActivity(
              "Received", "income", transaction.amount);
        }
        for (final doc in snapshot.docs) {
          await doc.reference.delete();
        }
      } else {
        print("there is no transactions");
      }
    });
  }
}
