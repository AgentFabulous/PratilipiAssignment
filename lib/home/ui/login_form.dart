import 'package:flutter/material.dart';
import 'package:pratilipi_assignment/common/provider/app_info.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  final BuildContext sContext;

  LoginForm(this.sContext);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController controllerUName = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  @override
  void dispose() {
    controllerUName.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppInfoProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: "Enter Username",
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24.0),
                borderSide: BorderSide(),
              ),
            ),
            controller: controllerUName,
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: "Enter Password",
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24.0),
                borderSide: BorderSide(),
              ),
            ),
            controller: controllerPassword,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: FloatingActionButton.extended(
                onPressed: () async {
                  final name = controllerUName.text;
                  final pass = controllerPassword.text;
                  final _context = widget.sContext;
                  Navigator.of(context).pop();
                  final response = await provider.signIn(name, pass);
                  String prompt = "";
                  switch (response) {
                    case SignInState.SUCCESS:
                      prompt = "Signed in!";
                      break;
                    case SignInState.NO_USER:
                      prompt = "User doesn't exist!";
                      break;
                    case SignInState.BAD_PASS:
                    case SignInState.BAD_TOKEN:
                      prompt = "Incorrect password!";
                      break;
                  }
                  Scaffold.of(_context).showSnackBar(
                    SnackBar(content: Text(prompt)),
                  );
                },
                label: Text('Continue'),
                icon: Icon(Icons.keyboard_arrow_right),
              ),
            ),
          )
        ],
      ),
    );
  }
}
