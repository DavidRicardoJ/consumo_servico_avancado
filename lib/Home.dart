import 'package:consumoservicoavancado/Post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _urlBase = "https://jsonplaceholder.typicode.com";

  Future<List<Post>> _recuperarPostagem() async {
    http.Response response = await http.get(_urlBase + "/posts");
    List<Post> lista = new List();
    var dadosJson = jsonDecode(response.body);
    for (var post in dadosJson) {
      Post p =
      new Post(post["userId"], post["id"], post["title"], post["body"]);
      lista.add(p);
    }
    return lista;
  }

  void _post() async {
    var body = jsonEncode({
      "userId": 120,
      "id": null,
      "title": "TestePost",
      "body": "Teste de Post"
    });
    http.Response response = await http.post(_urlBase + "/posts",
        headers: {"Content-type": "application/json; charset=UTF-8"},
        body :  body ,
    );
    print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");
  }

  void _put() {

  }

  void _patch() {

  }

  void _delete() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de serviço avançado"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Text("Salvar"),
                  onPressed: _post,
                ),
                RaisedButton(
                  child: Text("Atualizar"),
                  onPressed: _post,
                ),
                RaisedButton(
                  child: Text("Remover"),
                  onPressed: _post,
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Post>>(
                future: _recuperarPostagem(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    // print("Conexão none");
                      break;
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.deepPurpleAccent,
                        ),
                      );
                      break;
                    case ConnectionState.active:
                    /*print("Conexão active");
              break;*/
                    case ConnectionState.done:
                      print("Conexão done");
                      if (snapshot.hasError) {
                        print("Erro ao carregar os dados");
                      } else {
                        print("Lista carregada.");
                      }
                      break;
                  }
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      List<Post> lista = snapshot.data;
                      return ListTile(
                        title: Text(
                          lista[index].title,
                          style: TextStyle(fontSize: 20, color: Colors.blue),
                        ),
                        subtitle: Text(lista[index].body),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
