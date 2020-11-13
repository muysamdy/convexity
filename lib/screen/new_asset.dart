import 'package:flutter/material.dart';

class NewAssetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Assets')),
      body: NewAssetScreenBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

class NewAssetScreenBody extends StatefulWidget {
  @override
  _NewAssetScreenBodyState createState() => _NewAssetScreenBodyState();
}

class _NewAssetScreenBodyState extends State<NewAssetScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text('Hello')],
    );
  }
}
