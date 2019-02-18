import 'package:flutter/material.dart';
import './cepPage.dart';
import './latlngPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: Text(
          'Minha Localização',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Escolha uma das opções abaixo para procurar um endereço',
            textAlign: TextAlign.center,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: RaisedButton(
                elevation: 5,
                child: Text(
                  'Buscar por CEP',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.deepOrange,
                disabledColor: Colors.grey,
                onPressed: () => Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new CepPage()))),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: RaisedButton(
                elevation: 5,
                child: Text(
                  'Buscar por Localização atual',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.deepPurple,
                disabledColor: Colors.grey,
                onPressed: () => Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new LatLongPage()))),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
          ),
          Text(
            'Developed by: Saviollage',
            style: TextStyle(fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
