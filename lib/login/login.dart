import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple, Colors.blue], // Customize gradient colors
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  padding: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.fingerprint, // Replace with your actual logo
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  'Login to Flowmi',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 32),
                // Email Field
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 16),
                // Password Field
                TextField(
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock, color: Colors.white),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 16),
                // Remember Me Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: false, // Replace with your actual checkbox state
                      onChanged: (value) {
                        // Handle checkbox change
                      },
                      activeColor: Colors.white,
                      checkColor: Colors.deepPurple,
                    ),
                    Text(
                      'Remember me',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                // Sign In Button
                ElevatedButton(
                  onPressed: () {
                    // Handle sign in
                  },
                  child: Text('Sign in'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    padding:
                        EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Forgot Password
                TextButton(
                  onPressed: () {
                    // Handle forgot password
                  },
                  child: Text(
                    'Forgot the password?',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 16),
                // Sign Up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle sign up
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}