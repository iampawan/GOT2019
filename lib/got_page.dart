import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Color mainColor = Colors.amber;
Color secColor = Colors.black;

class GotPage extends StatefulWidget {
  @override
  _GotPageState createState() => _GotPageState();
}

class _GotPageState extends State<GotPage> {
  var data;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    var res = await http.get(
        "http://api.tvmaze.com/singlesearch/shows?q=game-of-thrones&embed=episodes");
    print(res.body);
    data = jsonDecode(res.body);
    setState(() {});
  }

  showGridWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        itemCount: data["_embedded"]["episodes"].length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 5 : 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemBuilder: (context, index) {
          var episode = data["_embedded"]["episodes"][index];
          return Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.network(
                  episode["image"]["original"],
                  fit: BoxFit.cover,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      episode["name"],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize:
                            MediaQuery.of(context).size.width > 600 ? 25 : 15,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("S${episode["season"]}E${episode["number"]}"),
                    decoration: BoxDecoration(
                        color: Colors.amberAccent,
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(16))),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  dataBody(BuildContext context) {
    var imgUrl = data["image"]["original"];
    var body = Column(
      children: <Widget>[
        Center(
          child: CircleAvatar(
            backgroundImage: NetworkImage(imgUrl),
            radius: MediaQuery.of(context).size.width > 600 ? 150 : 70,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          data["name"],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: showGridWidget(),
        ),
      ],
    );
    return body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text("GOT 2019"),
      ),
      body: data != null
          ? dataBody(context)
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
