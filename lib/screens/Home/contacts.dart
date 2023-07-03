//import 'package:contacts_service/contacts_service.dart';
import 'package:fast_contacts/fast_contacts.dart';
//import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ui/styles/colors.dart';

class ContactsList extends StatefulWidget {
  static List contactInfo = [];
  const ContactsList({super.key});

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  TextEditingController searchController = TextEditingController();
  bool ready = false;
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];
  @override
  void initState() {
    super.initState();
    getContacts();
    filterContacts();
  }

  Future<List<Contact>> getContacts() async {
    bool isGranted = await Permission.contacts.isGranted;
    if (!isGranted) {
      isGranted = await Permission.contacts.request().isGranted;
    }
    if (isGranted) {
      List<Contact> _contacts = await FastContacts.getAllContacts();
        contacts = _contacts;
        ready = true;
      return _contacts;
    } else {
      return [];
    }
  }

  filterContacts() {
    List<Contact> _tempContacts = [];
    _tempContacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _tempContacts.retainWhere((contact) {
        String _searchTerm = searchController.text.toLowerCase();
        print("term: $_searchTerm");
        String _contactName = contact.displayName.toString().toLowerCase();
        print("name: $_contactName");
        return _contactName.contains(_searchTerm);
      });
      setState(() {
        filteredContacts = _tempContacts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    return Scaffold(
      body: !ready
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(0),
              child: ListView(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 60,
                          width: Get.width * 0.9,
                          child: TextField(
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.search),
                              hintText: "Search...",
                              focusColor: MyColors.purpule,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            controller: searchController,
                          ),
                        ),
                      ),
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: isSearching == true
                            ? filteredContacts.length
                            : contacts.length,
                        itemBuilder: (context, index) {
                          Contact contact = isSearching == true
                              ? filteredContacts[index]
                              : contacts[index];
                          print(isSearching);
                          if (contact.displayName.toString() != "null") {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                  onTap: () {
                                    ContactsList.contactInfo = [
                                      contact.displayName,
                                      contact.id
                                    ];
                                    Get.back();
                                  },
                                  title: Text(contact.displayName.toString()),
                                  leading: Container(
                                    height: 30,
                                    width: 30,
                                    child: Icon(
                                      Icons.account_circle,
                                      size: 50,
                                    ),
                                  )),
                            );
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



/*import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          FutureBuilder<List<Contact>>(
            future: getContacts(),
            builder: (context, AsyncSnapshot<List<Contact>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text("Loading..."),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              }
              if (snapshot.hasData) {
                List<Contact> contacts = snapshot.data!;
                return ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    Contact contact = contacts[index];
                    return ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text(contact.displayName ?? ""),
                      subtitle: Text(contact.phones.isNotEmpty
                          ? contact.phones.map((phone) => phone.number).toString() ?? ""
                          : ""),
                    );
                  },
                );
              }
              return Center(
                child: Text("No contacts found."),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<List<Contact>> getContacts() async {
    bool isGranted = await Permission.contacts.isGranted;
    if (!isGranted) {
      isGranted = (await Permission.contacts.request()).isGranted;
    }
    if (isGranted) {
      List<Contact> contacts = await FastContacts.getAllContacts();
      return contacts;
    } else {
      return [];
    }
  }
}
 */