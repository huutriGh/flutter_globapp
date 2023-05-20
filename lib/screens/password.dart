import 'package:flutter/material.dart';
import 'package:globapp/data/sembast_db.dart';

import './password_detail.dart';
import '../data/shared_prefs.dart';
import '../models/password.dart';

class PasswordsScreen extends StatefulWidget {
  const PasswordsScreen({super.key});
  @override
  State createState() => _PasswordsScreenState();
}

class _PasswordsScreenState extends State<PasswordsScreen> {
  late SembastDb db;

  int settingColor = 0xff1976d2;
  double fontSize = 16;
  SPSettings settings = SPSettings();
  @override
  void initState() {
    settings.init().then((value) {
      setState(() {
        settingColor = settings.getColor();
        fontSize = settings.getFontSize();
      });
    });
    db = SembastDb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passwords List'),
        backgroundColor: Color(settingColor),
      ),
      body: FutureBuilder(
        future: getPasswords(),
        builder: (context, snapshot) {
          List<Password> passwords = snapshot.data ?? [];
          return ListView.builder(
            itemCount: passwords.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(passwords[index].id.toString()),
                onDismissed: (direction) {
                  db.deletePassword(passwords[index]);
                },
                child: ListTile(
                  title: Text(
                    passwords[index].name,
                    style: TextStyle(
                      fontSize: fontSize,
                    ),
                  ),
                  trailing: const Icon(Icons.edit),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return PasswordDetailDialog(
                          passwords[index],
                          false,
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(settingColor),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return PasswordDetailDialog(Password('', ''), true);
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<List<Password>> getPasswords() async {
    List<Password> passwords = await db.getPassword();
    return passwords;
  }
}
