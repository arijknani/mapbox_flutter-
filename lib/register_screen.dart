import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mapbox/signin_screen.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final _emailController = TextEditingController();
  final _passwordController =TextEditingController();
  final _nameController = TextEditingController();
   late Object error ;
  bool _isObscure = true;
  bool loading =true;

  void _handleSignUpError(FirebaseAuthException e) {
    String MessageToDisplay;
    switch (e.code) {
      case 'email-already-in-use':
        MessageToDisplay = 'this email is already in use ';
        break;
      case 'invalid-email':
        MessageToDisplay = 'The email you entered is invalid';
        break;
      case 'operation-not-allowed':
        MessageToDisplay = 'This operation is not allowed';
        break;
      case 'weak-password':
        MessageToDisplay = 'The password you entered is too weak';
        break;
      default:
        MessageToDisplay = 'an unknown error occured';
        break;
    }
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Sign up failed'),
          content: Text(MessageToDisplay),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ok'),
            )
          ],
        ));
  }

  Future _SignUp() async {
    setState(() {
      loading = true;
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      await FirebaseFirestore.instance.collection('users');

      await FirebaseFirestore.instance.collection('users').add({
        'name' : _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'id': FirebaseFirestore.instance.collection('users').doc('my-id')
      });

      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Sign up succeeded'),
            content: const Text(
                'Your account was created ,you can now log in'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyLogin()),
                    );
                  },
                  child: const Text('ok'))
            ],
          ));
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      _handleSignUpError(e);
      setState(() {
        loading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    Future showError(Object error) async {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "Error",
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
          ),
          content: Text(error.toString()),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "ok",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }



    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/register.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Container(
            padding: const EdgeInsets.only(left: 35, top: 80),
            child: const Text(
              "Create\nAccount",
              style: TextStyle(color: Colors.white, fontSize: 33),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  right: 35,
                  left: 35,
                  top: MediaQuery.of(context).size.height * 0.27),
              child: Column(children: [
                TextField(
                  // onChanged: (value){
                  //   _nameController.text=value;
                  // },
                  controller: _nameController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    hintText: 'Name',
                    hintStyle: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                   // onChanged: (value){
                   //   _emailController.text=value;
                   // },
                  controller: _emailController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  // onChanged: (value){
                  //   _passwordController.text=value;
                  // },
                  controller: _passwordController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure =! _isObscure;
                          });
                        },
                        icon: Icon(
                            _isObscure ? Icons.visibility : Icons.visibility_off
                        )),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xff4c505b),
                        child: IconButton(
                          color: Colors.white,
                          onPressed: ()  {
                            _SignUp();
                            Navigator.push(context,
                                    MaterialPageRoute(builder: (context)=> MyLogin())
                                );


                          },
                          icon: const Icon(Icons.arrow_forward),
                        ),
                      ),
                    ]),
                const SizedBox(
                  height: 40,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MyLogin())
                          );
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ]),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}



