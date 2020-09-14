import 'package:flutter/material.dart';
import 'package:pratilipi_assignment/common/provider/app_info.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  final BuildContext sContext;

  RegisterForm(this.sContext);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
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
                  final _context = widget.sContext;
                  final name = controllerUName.text;
                  final pass = controllerPassword.text;
                  Navigator.of(context).pop();
                  final response = await provider.register(name, pass);
                  Scaffold.of(_context).showSnackBar(
                    SnackBar(
                      content: Text(
                        response
                            ? "Registered! Please sign in."
                            : "User already exists!",
                      ),
                    ),
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
