import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

class CustomPage extends StatelessWidget {

  final String pageName;

  CustomPage(this.pageName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$pageName', style: TextStyle(color: Colors.black45),),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Text('This is $pageName built with ${FlavorConfig.instance.name} flavor!'),
      ),
    );
  }
}