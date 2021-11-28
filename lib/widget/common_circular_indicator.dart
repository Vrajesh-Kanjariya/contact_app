import 'package:flutter/material.dart';

class CommonCircularIndicator extends StatelessWidget {
  const CommonCircularIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.3),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
