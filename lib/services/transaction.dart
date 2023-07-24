import 'package:cloud_firestore/cloud_firestore.dart';

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
    } catch (e) {
      print('Error creating transaction document: $e');
    }
  }
}
