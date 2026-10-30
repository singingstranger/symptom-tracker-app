import 'package:flutter/material.dart';

class HeartView extends StatelessWidget{

  const HeartView({
    super.key
    });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding (
          padding: const EdgeInsets.symmetric( horizontal: 8, vertical: 5),
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter Systolic"
            ),
          )
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Enter Diastolic"
            ),
          ),
          ),
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Enter bpm"
            ),
          ),
          ),
      ],
    );
  }

}