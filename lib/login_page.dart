import 'package:flutter/material.dart';
import 'dart:html'; // Import dart:html for localStorage in web

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailText = TextEditingController();
  final TextEditingController passwordText = TextEditingController();
  bool isRememberMeChecked = false;

  // Define valid users as a map
  Map<String, String> validUsers = {
    "devadathcr7007@gmail.com": "Devadath@123",
    "devadathcr61@gmail.com": "Deva@123",
  };

  @override
  void initState() {
    super.initState();
    _loadSession(); // Load session when the screen initializes
  }

  // Load session if available from localStorage
  void _loadSession() {
    String? storedUsername = window.localStorage['username'];
    String? storedPassword = window.localStorage['password'];
    if (storedUsername != null && storedPassword != null) {
      setState(() {
        emailText.text = storedUsername;
        passwordText.text = storedPassword;
        isRememberMeChecked = true; // Set checkbox based on session
      });
    }
  }

  // Save session to localStorage
  void _saveSession() {
    if (isRememberMeChecked) {
      window.localStorage['username'] = emailText.text;
      window.localStorage['password'] = passwordText.text;
      print('Session saved: ${window.localStorage['username']}'); // Debugging
    } else {
      window.localStorage.remove('username');
      window.localStorage.remove('password');
    }
  }

  void _onLoginPressed() {
    String enteredEmail = emailText.text;
    String enteredPassword = passwordText.text;

    // Debugging: Print the entered credentials
    print("Entered Email: $enteredEmail");
    print("Entered Password: $enteredPassword");

    // Check if entered credentials are valid
    if (validUsers.containsKey(enteredEmail) &&
        validUsers[enteredEmail] == enteredPassword) {
      _saveSession(); // Save session if login is successful
      Navigator.pushReplacementNamed(
          context, '/home'); // Navigate to home screen
    } else {
      // Handle invalid login
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid username or password")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/images/png-clipart-computer-icons-login-scalable-graphics-email-accountability-blue-logo-thumbnail.png'))),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 500,
              child: TextField(
                controller: emailText,
                decoration: const InputDecoration(
                  label: Text(
                    'Email',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 500,
              child: TextField(
                controller: passwordText,
                obscureText: true,
                decoration: const InputDecoration(
                  label: Text(
                    'Password',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: _onLoginPressed, child: const Text('Login')),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: isRememberMeChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isRememberMeChecked = value!;
                    });
                  },
                ),
                const SizedBox(width: 15),
                const Text(
                  'Remember me',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w800,
                      fontSize: 16),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
