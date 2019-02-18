import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CepPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CepPageState();
}

class CepPageState extends State<CepPage> {
  Key cepButton = new Key('Cep');
  String cep = '';
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _autovalidate = false;
  Map<String, dynamic> address = new Map();

  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull("http://api.postmon.com.br/v1/cep/$cep"),
        headers: {'Accept': 'application/json'});

    if (response.statusCode == 404) {
      this.setState(() {
        address = {};
      });
      return 'Error';
    } else {
      this.setState(() {
        address = json.decode(response.body);
      });

      return 'Success';
    }
  }

  void submit() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true;
    } else {
      form.save();
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'Busca por CEP',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Form(
          key: _formKey,
          autovalidate: _autovalidate,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(20.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Digite seu CEP'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [LengthLimitingTextInputFormatter(8)],
                  validator: (value) {
                    if (value.isEmpty) return 'Entre com um CEP';
                    if (value.length != 8) return "Entre com um CEP válido";

                    if (!RegExp(r'^[0-9]+$').hasMatch(value))
                      return 'Favor digitar apenas os números.';
                  },
                  onSaved: (value) {
                    cep = value;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: RaisedButton(
                    elevation: 5,
                    child: Text(
                      'Buscar',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.red,
                    disabledColor: Colors.grey,
                    onPressed: () => submit()),
              ),
              SizedBox(
                height: 100,
              ),
              cep == ''
                  ? SizedBox()
                  : address.isEmpty
                      ? Card(
                          child: ListTile(
                            title: Text('Cep não encontrado'),
                            subtitle: Text('Verifique o cep e tente novamente'),
                          ),
                        )
                      : Card(
                          child: ListTile(
                            title: Text(address['logradouro'].toString() +
                                ', ' +
                                address['bairro'].toString()),
                            subtitle: Text(address['cidade'].toString() +
                                ', ' +
                                address['estado'].toString()),
                          ),
                        )
            ],
          ),
        ));
  }
}
