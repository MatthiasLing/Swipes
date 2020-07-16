import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart'; //For creating the SMTP Server
import 'package:random_string/random_string.dart';

class BottomScreenButton extends StatelessWidget {
  final Function function;
  BottomScreenButton({this.function});
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text("Submit"),
      onPressed: () async {
        var userInfo = function();
        if (userInfo != null) {
          String userName = userInfo[0].toString();
          String email = userInfo[1].toString();
          String verification;

          String username = 'uchicagoswipes@gmail.com';
          String password = 'Swipes123';

          final smtpServer = gmail(username, password);

          String verificationCode() {
            return randomAlphaNumeric(6);
          }

          Scaffold.of(context).showBottomSheet<void>(
            (BuildContext context) {
              return Container(
                height: 500,
                color: Colors.amber,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Text(userName + ", is this your correct email?"),
                      // Email verification
                      new Text(email),
                      // TODO: Make this button less obnoxious
                      RaisedButton(
                        child: const Text('Close BottomSheet'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      RaisedButton(
                        child: const Text('Send Confirmation Email'),
                        onPressed: () async {
                          (verification == null)
                              ? verification = verificationCode()
                              : null;
                          // Create our email message.
                          final message = Message()
                            ..from = Address(username)
                            ..recipients.add(email)
                            ..subject = userName +
                                ', Please Confirm Your Swipes Account'
                            ..text = 'Your code is: ' + verification;

                          try {
                            final sendReport = await send(message, smtpServer);
                            print('Message sent: ' +
                                sendReport
                                    .toString()); //print if the email is sent
                          } on MailerException catch (e) {
                            print('Message not sent. \n' + e.toString());
                          }
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
