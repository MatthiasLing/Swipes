import 'package:flutter/material.dart';

class BottomScreenButton extends StatelessWidget {
  final Function function;
  BottomScreenButton({this.function});
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text("Submit"),
      onPressed: () {
        Scaffold.of(context).showBottomSheet<void>(
          (BuildContext context) {
            return Container(
              height: 200,
              color: Colors.amber,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('BottomSheet'),
                    RaisedButton(
                      child: const Text('Close BottomSheet'),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
