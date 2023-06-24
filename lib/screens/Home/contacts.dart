import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactsList extends StatefulWidget {
  static List contactInfo = [];
  ContactsList({super.key});

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  bool ready = false;
  List<Contact> contacts = [];
  @override
  void initState() {
    super.initState();
    getAllContacts();
  }

  getAllContacts() async {
    List<Contact> _contacts = await ContactsService.getContacts();
    ready = true;
    print("ready");
    setState(() {
      contacts = _contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !ready
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(0),
              child: ListView(
                children: [
                  Column(
                    children: [
                      Text("data"),
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: contacts.length,
                        itemBuilder: (context, index) {
                          Contact contact = contacts[index];
                          if (contact.displayName.toString() != "null") {
                            return ListTile(
                                onTap: () {
                                  ContactsList.contactInfo = [
                                    contact.displayName,
                                    contact.identifier
                                  ];
                                  Get.back();
                                },
                                title: Text(contact.displayName.toString()),
                                leading: Container(
                                  height: 30,
                                  width: 30,
                                  child: Icon(Icons.person),
                                ));
                          } else {
                            return SizedBox(
                              height: 0,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
