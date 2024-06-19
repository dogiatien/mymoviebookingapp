import 'dart:ffi';
import 'package:flutter/material.dart';
import 'admin_dashboard.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const Color _selectedColor = Colors.black;
  static const Color _unSelectedColor = Colors.grey;

  Color _emailTFColor = _unSelectedColor;
  Color _passwordColor = _unSelectedColor;

   // ignore: prefer_final_fields
   FocusNode _emailTFFocusNode = FocusNode();
   // ignore: prefer_final_fields
   FocusNode _passwordTFFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailTFFocusNode.addListener(_onEmailTFFocusChange);
    _passwordTFFocusNode.addListener(_onPasswordTFFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _emailTFFocusNode.removeListener(_onEmailTFFocusChange);
    _emailTFFocusNode.dispose();
    _passwordTFFocusNode.removeListener(_onPasswordTFFocusChange);
    _passwordTFFocusNode.dispose();
  }

  void _onEmailTFFocusChange() {
    setState(() {
      _emailTFFocusNode.hasFocus
          ? _emailTFColor = _selectedColor
          : _emailTFColor = _unSelectedColor;
    });
  }

  void _onPasswordTFFocusChange() {
    setState(() {
      _passwordTFFocusNode.hasFocus
          ? _passwordColor = _selectedColor
          : _passwordColor = _unSelectedColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset:false,
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 80, 16, 36),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                 'lib/images/logo.png',
                  width: 260,
                  height: 260,
                ),
                const SizedBox(
                  height: 64,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      border: Border.all(color: _emailTFColor),
                      borderRadius: BorderRadius.circular(40)),
                  child: SizedBox(
                    height: 60,
                    child:
                  TextField(
                    
                    focusNode: _emailTFFocusNode,
                    decoration: InputDecoration(
                        labelText: "Email or Phonenumber.",
                        labelStyle: TextStyle(color: _emailTFColor),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(left: 16,top:8),
                        ),
                        
                  ),
                  ),
                ),
                const SizedBox(height: 24,),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      border: Border.all(color: _emailTFColor),
                      borderRadius: BorderRadius.circular(40)),
                           child: SizedBox(
                    height: 60,
                  
                  child: TextField(
                    focusNode: _passwordTFFocusNode,
                    obscureText:true,
                    decoration: InputDecoration(
                        labelText: "Password.",
                        labelStyle: TextStyle(color: _passwordColor),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(left: 16,top:8),
                        ),
                  ),
                           ),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextButton(onPressed: (){
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => AdminDashboard(),
                    ),
                  );
                }, child: const Text('Forget Password')),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 164, 165, 165)),
                    ),
                    onPressed: () {
                     
                    },
                    child: const Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
