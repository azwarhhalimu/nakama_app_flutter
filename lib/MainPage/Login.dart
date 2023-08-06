import 'package:flutter/material.dart';
import 'package:nakama_app/Componen/Alert.dart';
import 'package:nakama_app/Componen/Height.dart';
import 'package:nakama_app/MainPage.dart';
import 'package:nakama_app/enviroment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  static String routeName = "/login";
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _formKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final password = TextEditingController();

  void _login() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    if (_formKey.currentState!.validate()) {
      var x = user.where((element) =>
          element["username"] == username.text &&
          element["password"] == password.text);
      if (!x.isEmpty) {
        alert(context, "Berhasil", "Login Sukses", [
          TextButton(
              onPressed: () async {
                await shared.setString("login", "ok");
                Navigator.pushNamed(context, MainPage.routeName);
              },
              child: Text("Lanjutkn"))
        ]);
      } else {
        alert(context, "Login gagal", "Username atau password tidak benar", [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                username.clear();
                password.clear();
              },
              child: Text("Coba Lagi"))
        ]);
      }
    }
  }

  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("assets/op.jpeg"),
              Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Login",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    Height(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Username"),
                          TextFormField(
                            controller: username,
                            validator: (value) {
                              if (value == "") {
                                return "Tidak boleh kosong";
                              }
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              hintText: "Username",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          Height(height: 20),
                          Text("Password"),
                          TextFormField(
                            controller: password,
                            validator: (value) {
                              if (value == "") {
                                return "Tidak boleh kosong";
                              }
                            },
                            obscuringCharacter: "*",
                            obscureText: showPassword,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showPassword =
                                          showPassword ? false : true;
                                    });
                                  },
                                  icon: Icon(!showPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility)),
                              prefixIcon: Icon(Icons.password),
                              hintText: "Password",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          Height(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {
                                  _login();
                                },
                                child: Text("Login")),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
