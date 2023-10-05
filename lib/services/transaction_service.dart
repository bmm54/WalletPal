import 'package:bstable/services/auth_data.dart';
import 'package:bstable/sql/sql_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TransactionModel {
  final String senderName;
  final String senderId;
  final String receiverId;
  final double amount;
  final String time;
  final String status;

  TransactionModel({
    required this.senderName,
    required this.senderId,
    required this.receiverId,
    required this.amount,
    required this.time,
    required this.status,
  });

  // Convert Firestore snapshot to TransactionModel
  factory TransactionModel.fromSnapshot(DocumentSnapshot snapshot) {
    return TransactionModel(
      senderName: snapshot['senderName'],
      senderId: snapshot['senderId'],
      receiverId: snapshot['receiverId'],
      amount: snapshot['amount'],
      time: snapshot['time'],
      status: snapshot['status'],
    );
  }
}

class TransactionsService {
  static void createTransaction(String senderName, String senderId,
      String receiverId, String receiverName, double amount,String status) async {
    try {
      CollectionReference transactionsRef =
          FirebaseFirestore.instance.collection('transactions');
      DocumentReference docRef = await transactionsRef.add({
        'senderName': senderName,
        'senderId': senderId,
        'receiverId': receiverId,
        'time': DateTime.now().toString(),
        'amount': amount,
        'status': status,
      });

      String transactionId = docRef.id;
      print('Transaction document created with ID: $transactionId');
      docRef.isBlank!
          ? null
          : await SQLHelper.insertActivity(receiverName, "Sent", amount,status);
    } catch (e) {
      print(e);
    }
  }

  // Receiver listens for changes from Firestore
  static void startListeningForTransactions(receiverId) {
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
              transaction.senderName, "Received", transaction.amount,transaction.status,transaction.time);
          break;
        }
        for (final doc in snapshot.docs) {
          await doc.reference.delete();
          print("Deleted..........");
        }
      } else {
        print("there is no transactions");
      }
    });
  }
}
