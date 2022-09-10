import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/seller.dart';
import 'seller_details.dart';

class ProfileScreen extends StatefulWidget {
  //ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final CollectionReference _sellers =
      FirebaseFirestore.instance.collection('sellers');
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sellers'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _sellers.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  //final sellers = snapshot.data!;
                  //print('sellers : ${sellers.length}');
                  return ListView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SellerDetailsScreen(
                                    about: documentSnapshot['about'],
                                    email: documentSnapshot['email'],
                                    rate: documentSnapshot['rate'],
                                    orangeType: documentSnapshot['orange'],
                                  )),
                        ),
                        child: Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            title: Text(documentSnapshot['email']),
                            subtitle: Text(
                                'Rate of orange per kg - ${documentSnapshot['rate']}'),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          // SizedBox(
          //   height: 20,
          // ),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15)),
              onPressed: () => FirebaseAuth.instance.signOut(),
              child: Text('Log Out'),
            ),
          )
        ],
      ),
      // SizedBox(
      //   height: 20,
      // ),
      // Container(
      //   width: double.infinity,
      //   child: ElevatedButton(
      //     style: ElevatedButton.styleFrom(
      //         padding: EdgeInsets.symmetric(vertical: 15)),
      //     onPressed: () => FirebaseAuth.instance.signOut(),
      //     child: Text('Log Out'),
      //   ),
      // )
    );
  }

  Stream<List<Seller>> readUsers() => FirebaseFirestore.instance
      .collection('sellers')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Seller.fromJSON(doc.data())).toList());
}
