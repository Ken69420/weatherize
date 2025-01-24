import 'package:flutter/material.dart'; // Import the Flutter Material package for UI components.
import 'signup.dart';
import 'firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import the User class from the firebase_auth package.
import 'dashboard.dart';

void main() {
  runApp(
      const WeatherizeApp()); // Entry point of the app that initializes and runs the WeatherizeApp widget.
}

class WeatherizeApp extends StatelessWidget {
  const WeatherizeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Create a MaterialApp, which provides the basic structure for the app.
      debugShowCheckedModeBanner: false, // Disable the debug banner in the app.
      home: LoginPage(), // Set LoginPage as the home screen of the app.
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: SingleChildScrollView(
          // Allow scrolling if the content exceeds the screen height.
          padding: const EdgeInsets.symmetric(
              horizontal:
                  30), // Add horizontal padding around the child content.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Weatherize",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40), // Add vertical spacing of 40 pixels.

              // Username TextField
              TextField(
                // Create a text input field for the username.
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Username",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password TextField
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: const Text(
                      "Sign up here",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    String email = _emailController.text;
                    String password = _passwordController.text;
                    User? user = await _authService.signInWithEmailAndPassword(
                        email, password);
                    if (user != null) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DashboardPage()));
                    } else {
                      print("Login failed");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
