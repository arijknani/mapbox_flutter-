import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mapbox/myhomepage.dart';
import 'package:mapbox/register_screen.dart';
import 'package:mapbox/reset_password.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final TextEditingController _passwordController = TextEditingController() ;
  final TextEditingController _emailController = TextEditingController();
  late Object error ;
  bool _isObscure = true;
  
  
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

  Future<User?> loginUsinEmailPassword(
      String email, String password, BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      var errorCode = e.code;
      var errorMessage = e.message;
      if (e.code == "user-not-found") {
        showError("no user found for that email");
      } else if (errorCode == 'auth/wrong-password') {
        showError('wrong password');
      } else {
        showError(errorMessage!);
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {


    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/login.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Container(
            padding: const EdgeInsets.only(left: 35, top: 80),
            child: const Text(
              "Welcome\nBack",
              style: TextStyle(color: Colors.white, fontSize: 33),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  right: 35,
                  left: 35,
                  top: MediaQuery.of(context).size.height * 0.5),
              child: Column(children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
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
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
                        color: Color(0xff4c505b),
                        fontSize: 27,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color(0xff4c505b),
                      child: IconButton(
                        color: Colors.white,
                        onPressed: () {
                         loginUsinEmailPassword(
                             _emailController.text,
                             _passwordController.text,
                             context);
                         Navigator.push(
                             context, 
                         MaterialPageRoute(builder: (context)=> MyHomePage()));

                        },
                        icon: const Icon(Icons.arrow_forward),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const MyRegister()));
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                            color: Color(0xff4c505b),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, 
                              MaterialPageRoute(builder: (context) => const MyResetPassword())
                          );
                        },
                        child: const Text(
                          'Forgot Password',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                            color: Color(0xff4c505b),
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