// ignore_for_file: iterable_contains_unrelated_type

import 'package:bstable/models/expense_model.dart';
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
  final String? SenderImageUrl;

  TransactionModel({
    required this.senderName,
    required this.senderId,
    required this.receiverId,
    required this.amount,
    required this.time,
    required this.status,
    this.SenderImageUrl,
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
      SenderImageUrl: snapshot['image_url'],
    );
  }
}

class TransactionsService {
  updateTransactionsInfos(uid, name, amount, status, imageUrl, category) async {
    if (await SQLHelper.contactExists(uid)) {
      await SQLHelper.updateTransactionContact(amount, category, status, uid);
    } else {
      await SQLHelper.createTransactionContact(uid, name, imageUrl)
          .then((value) async {
        await SQLHelper.updateTransactionContact(amount, category, status, uid);
      });
    }
  }

  Future<void> createTransaction(
      String senderName,
      String senderId,
      String receiverId,
      String receiverName,
      double amount,
      String status,
      String? imageUrl,
      receiverImage) async {
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
        'image_url': imageUrl
      });

      String transactionId = docRef.id;
      print('Transaction document created with ID: $transactionId');
      docRef.isBlank!
          ? null
          : await SQLHelper.insertTransaction(receiverName, "Sent", amount,
              status, DateTime.now().toString(), receiverImage);
      await updateTransactionsInfos( receiverId, receiverName, amount,
              status, receiverImage, "Sent");
    } catch (e) {
      print(e);
    }
  }

  // Receiver listens for changes from Firestore
  void startListeningForTransactions(receiverId) {
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
          await SQLHelper.insertTransaction(
              transaction.senderName,
              "Received",
              transaction.amount,
              transaction.status,
              transaction.time,
              transaction.SenderImageUrl);
          await updateTransactionsInfos(
              transaction.senderId,
              transaction.senderName,
              transaction.amount,
              transaction.status,
              transaction.SenderImageUrl,
              "Received");

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
