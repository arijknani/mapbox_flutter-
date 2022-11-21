import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mapbox/myhomepage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController =TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController= TextEditingController();

  final Stream<QuerySnapshot> users =
    FirebaseFirestore.instance.collection('users').snapshots();
  int index = 0;

  int indice(){

    return index;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
            'Profile',
          style: TextStyle(
            fontSize: 25,
            color: Colors.black
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body:
         Stack(
          children: [
            Container(
              color: Colors.white,
              height: double.infinity,
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 250,
                left: 20 ,
                right: 20,
              ),
            ),
            Container(
              width: double.infinity,
              height: 190,
              margin: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 20
              ),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(90, 20, 20, 20),
                    blurRadius: 0.8,
                    offset: Offset(9,9),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 45,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 45,
                      backgroundImage: AssetImage('assets/profile_image.jpg'),
                    ),
                  ),
                   const SizedBox(height: 3),
                  StreamBuilder<QuerySnapshot>(
                    stream: users ,
                    builder: (
                        BuildContext context ,
                        AsyncSnapshot <QuerySnapshot>  snapshot) {
                      if(snapshot.hasError ){
                        return const Text('something went wrong');
                      }
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return const Text('loading..');
                      }
                      final data = snapshot.requireData;
                      return Text(
                                data.docs[indice()]['name'].toString(),
                                style: const TextStyle(
                                   color: Colors.grey,
                                     fontSize: 18,
                                     fontWeight: FontWeight.bold,
                                   ),
                            );
                    }


                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 210),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: users ,
                    builder: (
                        BuildContext context ,
                        AsyncSnapshot <QuerySnapshot>  snapshot){
                      if(snapshot.hasError ){
                        return const Text('something went wrong');
                      }
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return const Text('loading..');
                      }
                      final data = snapshot.requireData;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: TextFormField(
                          controller: nameController,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            counterStyle:  const TextStyle(
                              color: Colors.black,
                            ),
                            focusColor: Colors.black,
                            icon: const Icon(Icons.person),
                            hintText: data.docs[indice()]['name'].toString(),
                            hintStyle: const TextStyle(
                                color:Colors.black
                            ),
                          ),
                        ),
                      );
                    }
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: users ,
                        builder: (
                            BuildContext context ,
                            AsyncSnapshot <QuerySnapshot>  snapshot){
                          if(snapshot.hasError ){
                            return const Text('something went wrong');
                          }
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return const Text('loading..');
                          }
                          final data = snapshot.requireData;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: TextFormField(
                              controller: emailController ,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                counterStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                                focusColor: Colors.black,
                                icon: const Icon(Icons.email),
                                hintText: data.docs[indice()]['email'].toString(),
                                hintStyle: const TextStyle(
                                    color:Colors.black
                                ),
                              ),
                            ),
                          );
                        }
                      ),
                    StreamBuilder<QuerySnapshot>(
                        stream: users ,
                        builder: (
                            BuildContext context ,
                            AsyncSnapshot <QuerySnapshot>  snapshot){
                          if(snapshot.hasError ){
                            return const Text('something went wrong');
                          }
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return const Text('loading..');
                          }
                          final data = snapshot.requireData;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: TextFormField(
                              controller: passwordController,
                              style:  const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                counterStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                                focusColor: Colors.black,
                                icon: const Icon(Icons.lock),
                                hintText: data.docs[indice()]['password'].toString(),
                                hintStyle: const TextStyle(
                                    color:Colors.black
                                ),
                              ),
                            ),
                          );
                        }
                    ),



                    Container(
                      margin: EdgeInsets.only(
                        top: 30,
                        left: 145,
                      ),
                      height: 55,
                      width: 100,
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(90, 20, 20, 20),
                            blurRadius: 10,
                            offset: Offset(6,6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red, // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: (){
                          final docUser =FirebaseFirestore.instance
                              .collection('users')
                              .doc('Yr5EJczac1E2Hy0utxBS');
                          docUser.update({
                            'name' : nameController.text,
                            // 'email' : emailController.text,
                            // 'password' : passwordController.text,

                          });
                        } ,
                        child: Text('Update'),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),

    );
  }
}

