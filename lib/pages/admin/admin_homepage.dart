import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../login_signup/function/logout.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {

  void approveAdmin(QueryDocumentSnapshot<Map<String, dynamic>> data){
    FirebaseFirestore.instance.collection('usersData').doc(data.id).update({
      'isApproved' : true
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Approved successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to Approve data')),
      );
    });
  }
  void rejectAdmin(QueryDocumentSnapshot<Map<String, dynamic>> data){
    FirebaseFirestore.instance.collection('usersData').doc(data.id).update({
      'isApproved' : false
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rejected successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject data')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Page'),
        actions: [IconButton(icon: Icon(Icons.logout),onPressed: (){
          logout(context);
        },)],),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('usersData').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot documentSnapshot =
                          snapshot.data!.docs[index];
                          return Material(
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white24
                                    ),
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(child: Text(documentSnapshot['description'])),
                                                Expanded(child: Text(documentSnapshot['amount'])),
                                                Expanded(child: Text(documentSnapshot['incomeexpense'])),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              GestureDetector(onTap: (){
                                                if(documentSnapshot['isApproved'] == true){
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Already Approved')),
                                                  );
                                                }else{
                                                  approveAdmin(snapshot.data!.docs[index]);
                                                }
                                              }, child: Icon(Icons.check,color: Colors.green,)),
                                              SizedBox(width: 7,),
                                              GestureDetector(onTap: (){
                                                if(documentSnapshot['isApproved'] == false){
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Already rejected')),
                                                  );
                                                }else{
                                                  rejectAdmin(snapshot.data!.docs[index]);
                                                }
              
                                              }, child: Icon(Icons.close,color: Colors.red,)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                ],
                              )
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error.toString()}'),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Center(
                    child: Text('Something went wrong, please try again later.'),
                  );
                },
              ),
            ),
            ElevatedButton(onPressed: (){
              Navigator.pushNamed(context, 'overview');
            }, child: Text('See Overview'))
          ],
        ),
      ),
    );
  }
}
