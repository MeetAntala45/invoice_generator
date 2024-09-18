import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Container(
            height: 200,
            child: Image.asset('assets/logo.png'),
          ),
          SizedBox(height: 10),
          Text(
            'Make Professional Invoices',
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          Text(
            'Create Invoices and Share it with your Customer Easily',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white60, 
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                  child: Text('Sign Up'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor, 
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text('Sign In', style: TextStyle(color: Theme.of(context).primaryColor)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Theme.of(context).primaryColor),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
