
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopie/pages/admin/admin_homepage.dart';
import 'package:shopie/pages/staff/home_page.dart';

import 'log_in.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;

          if (user == null) {
            return LoginPage();
          } else {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> userDocSnapshot) {
                if (userDocSnapshot.connectionState == ConnectionState.done) {
                  if (userDocSnapshot.hasData && userDocSnapshot.data != null) {
                    String role = userDocSnapshot.data!.get('role');
                    if (role == 'Admin') {
                      return AdminHomePage();
                    } else {
                      return HomePage();
                    }
                  } else {
                    return LoginPage();
                  }
                }
                return Center(child: CircularProgressIndicator());
              },
            );
          }
        } else {
          return Scaffold(
            body: Center(),
          );
        }
      },
    );
  }
}

