import 'package:flutter/cupertino.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutterflavours/main.dart';

void main() {
  FlavorConfig(
      name: 'prod',
      variables: {
        'host': 'prod-host',
        'port': 5555
      }
  );
  runApp(MyApp());
}