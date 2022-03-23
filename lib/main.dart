import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

import 'pages/custom-page.dart';
import 'pages/search-page.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Flavor ${FlavorConfig.instance.name}',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Shell(title: 'Flutter Demo Home Page'),
    );
  }
}

class Shell extends StatefulWidget {
  Shell({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _ShellState createState() => _ShellState();
}

class _ShellState extends State<Shell> with SingleTickerProviderStateMixin{

  TabController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: [
                CustomPage('Home'),
                Search(),
                CustomPage('Health'),
                CustomPage('Settings')
              ],
            ),
          ),
          TabBar(
            onTap: (_){
              print(_);
              ScaffoldMessenger.of(context).clearSnackBars();
            },
            unselectedLabelColor: Colors.black38,
            labelColor: Colors.deepOrangeAccent,
            controller: _controller,
            tabs: [
              Tab(
                icon: Icon(
                    Icons.dashboard
                ),
              ),
              Tab(
                icon: Icon(
                    Icons.search
                ),
              ),
              Tab(
                icon: Icon(
                    Icons.assessment
                ),
              ),
              Tab(
                icon: Icon(
                    Icons.person_outline
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}