import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Forfaits Voyages',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: AccueilForfaitsVoyages(title: 'Forfaits Voyages'),
    );
  }
}

class AccueilForfaitsVoyages extends StatefulWidget {
  AccueilForfaitsVoyages({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  AccueilForfaitsVoyagesState createState() => AccueilForfaitsVoyagesState();
}

class AccueilForfaitsVoyagesState extends State<AccueilForfaitsVoyages> {
  late Future<List<Forfait>> futurForfaits;
  List<Forfait> forfaits = [];


  initState() {
    super.initState();
    futurForfaits = _fetchForfaits();

    Iterable list = json.decode('['
        '{"_id":"6000ff360efa3fd999621bed","destination":"Jamaïque","villeDepart":"Montreal", "hotel":{"nom":"Hotel #6","coordonnees":"...","nombreEtoiles":1,"nombreChambres":1,"caracteristiques":["Face à la plage","Miniclub"]},"dateDepart":"2021-01-01","dateRetour":"2021-01-08","dateDepartD":"2020-01-01T00:00:00.000Z","dateRetourD":"2020-01-08T00:00:00.000Z","prix":300,"rabais":0,"vedette":true,"image" : "https://i.imgur.com/bllxt5P.jpg", "da":"0000000"},'
        '{"_id":"6000ff370efa3fd999621c03","destination":"Alaska","villeDepart":"Montreal","hotel":{"nom":"Hotel #6","coordonnees":"...","nombreEtoiles":1,"nombreChambres":1,"caracteristiques":["Face à la plage","Miniclub"]},"dateDepart":"2021-01-01","dateRetour":"2021-01-08","dateDepartD":"2020-01-01T00:00:00.000Z","dateRetourD":"2020-01-08T00:00:00.000Z","prix":300,"rabais":0,"vedette":true,"image" : "https://i.imgur.com/2bknP5q.jpg", "da":"0000000"},'
        '{"_id":"6000ff380efa3fd999621c19","destination":"Japon","villeDepart":"Montreal","hotel":{"nom":"Hotel #6","coordonnees":"...","nombreEtoiles":1,"nombreChambres":1,"caracteristiques":["Face à la plage","Miniclub"]},"dateDepart":"2021-01-01","dateRetour":"2021-01-08","dateDepartD":"2020-01-01T00:00:00.000Z","dateRetourD":"2020-01-08T00:00:00.000Z","prix":300,"rabais":0,"vedette":true,"image" : "https://i.imgur.com/AyW1KcV.jpg", "da":"0000000"},'
        '{"_id":"6000ff390efa3fd999621c2f","destination":"Cuba","villeDepart":"Montreal","hotel":{"nom":"Hotel #6","coordonnees":"...","nombreEtoiles":1,"nombreChambres":1,"caracteristiques":["Face à la plage","Miniclub"]},"dateDepart":"2021-01-01","dateRetour":"2021-01-08","dateDepartD":"2020-01-01T00:00:00.000Z","dateRetourD":"2020-01-08T00:00:00.000Z","prix":300,"rabais":0,"vedette":false,"image" : "https://i.imgur.com/YbI55Cy.jpg", "da":"0000000"},'
        '{"_id":"6000ff3a0efa3fd999621c45","destination":"Cuba","villeDepart":"Montreal","hotel":{"nom":"Hotel #7","coordonnees":"...","nombreEtoiles":2,"nombreChambres":20,"caracteristiques":[]},"dateDepart":"2021-01-01","dateRetour":"2021-01-08","dateDepartD":"2020-01-01T00:00:00.000Z","dateRetourD":"2020-01-08T00:00:00.000Z","prix":3000,"rabais":0,"vedette":false,"image" : "https://i.imgur.com/34Oxo2u.jpg", "da":"0000000"},'
        '{"_id":"6000ff3c0efa3fd999621c5b","destination":"Cuba","villeDepart":"Montreal","hotel":{"nom":"Hotel #8","coordonnees":"...","nombreEtoiles":3,"nombreChambres":300,"caracteristiques":["Face à la plage","Miniclub","..."]},"dateDepart":"2021-01-01","dateRetour":"2021-01-08","dateDepartD":"2020-01-01T00:00:00.000Z","dateRetourD":"2020-01-08T00:00:00.000Z","prix":30000,"rabais":100,"vedette":false,"image" : "https://i.imgur.com/KMstw8x.jpg", "da":"0000000"},'
        '{"_id":"6000ff3e0efa3fd999621c71","destination":"Costa Rica","villeDepart":"Québec","hotel":{"nom":"Hotel #6","coordonnees":"...","nombreEtoiles":1,"nombreChambres":1,"caracteristiques":["Face à la plage","Miniclub"]},"dateDepart":"2021-01-01","dateRetour":"2021-01-08","dateDepartD":"2020-01-01T00:00:00.000Z","dateRetourD":"2020-01-08T00:00:00.000Z","prix":300,"rabais":0,"vedette":false,"image" : "https://i.imgur.com/Uo97EQp.jpg", "da":"0000000"},'
        '{"_id":"6000ff3f0efa3fd999621c87","destination":"Costa Rica","villeDepart":"Québec","hotel":{"nom":"Hotel #7","coordonnees":"...","nombreEtoiles":2,"nombreChambres":20,"caracteristiques":[]},"dateDepart":"2021-01-01","dateRetour":"2021-01-08","dateDepartD":"2020-01-01T00:00:00.000Z","dateRetourD":"2020-01-08T00:00:00.000Z","prix":3000,"rabais":0,"vedette":false,"image" : "https://i.imgur.com/UHxm6H6.jpg", "da":"0000000"},'
        '{"_id":"6000ff400efa3fd999621c9d","destination":"Costa Rica","villeDepart":"Québec","hotel":{"nom":"Hotel #8","coordonnees":"...","nombreEtoiles":3,"nombreChambres":300,"caracteristiques":["Face à la plage","Miniclub","..."]},"dateDepart":"2021-01-01","dateRetour":"2021-01-08","dateDepartD":"2020-01-01T00:00:00.000Z","dateRetourD":"2020-01-08T00:00:00.000Z","prix":30000,"rabais":100,"vedette":false,"image" : "https://i.imgur.com/nM7wvDN.jpg", "da":"0000000"}]');
    forfaits = list.map((model) => Forfait.fromJson(model)).toList();
  }

  Future<List<Forfait>> _fetchForfaits() async {
    final response = await http.get(Uri.https('forfaits-voyages.herokuapp.com', '/api/forfaits/da/1996489', {}));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((forfait) => new Forfait.fromJson(forfait)).toList();
    } else {
      throw Exception('Erreur de chargement des forfaits');
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget destination(String destination, String villeDepart) {
      return Container(
          padding: const EdgeInsets.all(25),
          child:
            Row(
                children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    destination,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "de " + villeDepart,
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),

       ]
      )
      );
    }

    Widget infosHotel(Hotel hotel) {
      return Container(
          padding: const EdgeInsets.only(left: 25, top: 20, bottom:20),
          child:
          Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 2),
                      child:
                        Text(
                        hotel.nom,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          ),
                        ),
                    ),
                    Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    child:
                        Row(children: [
                          Icon(Icons.add_location_sharp, color: Colors.green ),
                          Text(hotel.coordonnees),
                          ],
                        )
                    ),
                   /* Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(hotel.caracteristiques.join(" · "))
                    ),*/
                    Container(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(hotel.nombreChambres.toString()+" chambre(s)")
                    ),
                    Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        child:
                        IconTheme(
                          data: IconThemeData(
                            color: Theme.of(context).primaryColor,
                          ),
                          child:
                          Row(
                            children: [
                            StarDisplay(value: hotel.nombreEtoiles),
                            Text(" "+(new Random().nextInt(150) + 10).toString()+" reviews")
                          ],)
                        )
                    ),
                  ],
                ),
              ]
          )
      );
    }

    Widget sectionPrix( prix, rabais) {
      return Container(
          child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(bottom:10),
                        child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text((prix-rabais).toString() + "\$" ,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "par personne",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 10,
                            ),
                          ),
                        ],
                      )
                    )

                  ],
                ),
                Row(
                  children: [
                    Text(rabais > 0 ? (prix).toString() + "\$" : "",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        decoration: TextDecoration.lineThrough
                      ),)
                  ],
                ),
                Row(
                  children: [
                    Text(rabais > 0 ? rabais.toString() + "\$" : "",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),)
                  ],
                )
              ],
            )
      );
    }




    return FutureBuilder<List<Forfait>>(
        future: futurForfaits,
        builder: (context, snapshot) {
      if (snapshot.hasData) {
          return Scaffold(
              backgroundColor: Colors.grey[300],
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body:
              ListView.builder(
                  padding: const EdgeInsets.only(bottom:32),
                  itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return
                        Container(
                            padding: const EdgeInsets.only(top: 32, left:32, right:32),
                            child:
                          Container(
                          decoration: new BoxDecoration(
                              border: new Border.all(color: snapshot.data![index].vedette ? Theme.of(context).primaryColor : Colors.grey , width: 2),
                              color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: snapshot.data![index].vedette ? Theme.of(context).primaryColor : Colors.grey,
                                blurRadius: 3,
                                offset: Offset(4, 7), // Shadow position // changes position of shadow
                              ),
                            ],
                          ),

                          child: Column(
                            children:[

                              Row(
                                children: [
                                  Expanded(
                                      child:
                                    ClipRRect(
                                          borderRadius: new BorderRadius.only(
                                          topLeft: const Radius.circular(24),
                                          topRight: const Radius.circular(24),
                                    )     ,
                                      child: Image.network(
                                        "https://picsum.photos/600/240",
                                        width: 600,
                                        height: 240,
                                        fit: BoxFit.cover,
                                      )
                                  )
                                  )
                                ],
                              ),
                                Container(
                                decoration: new BoxDecoration(
                                  color: snapshot.data![index].vedette ? Colors.green : Theme.of(context).primaryColor,
                                ),
                                padding: snapshot.data![index].vedette ? const EdgeInsets.only(top: 10,bottom:10): const EdgeInsets.only(top: 5,bottom:5),
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:
                                  [ snapshot.data![index].vedette ?
                                  Text("Forfait vedette".toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 40,
                                      //fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  )
                                      :
                                  Container()
                                  ],
                                )

                                ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  infosHotel(snapshot.data![index].hotel),
                                  Column(
                                    children: [
                                      Row(
                                          children: [
                                          destination(snapshot.data![index].destination, snapshot.data![index].villeDepart),
                                      ]),
                                      Row(
                                          children: [
                                            sectionPrix(snapshot.data![index].prix, snapshot.data![index].rabais),

                                          ]),
                                  ],)
                                ],
                              ),
                              Container(
                                  padding: const EdgeInsets.only(left: 25, bottom:20, right: 25),
                                  child:
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.only(right: 25),
                                        child:
                                            Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children:[
                                                  Row(
                                                      children:[
                                                        Text("Départ:",
                                                          style: TextStyle(
                                                            color: Colors.grey[500],
                                                          ),
                                                        )
                                                      ]
                                                  ),
                                                  Row(
                                                      children:[
                                                        Text(new DateFormat('yyyy-MM-dd').format(snapshot.data![index].dateDepart),
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        )
                                                      ]
                                                  ),
                                                ]
                                            )
                                    ),

                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,

                                        children:[
                                          Row(

                                              children:[
                                                Text("Retour:",
                                                  style: TextStyle(
                                                    color: Colors.grey[500],
                                                  ),
                                                )
                                              ]
                                          ),
                                          Row(
                                              children:[
                                                Text( new DateFormat('yyyy-MM-dd').format(snapshot.data![index].dateRetour),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              ]
                                          ),
                                        ]
                                    )
                                  ],
                                )
                              )


                            ]
                          ),

                        )
                        );
                    }
                    )
        );
      } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }
      return CircularProgressIndicator();
        },
    );
  }
}





class Forfait {
  final String id;
  final String destination;
  final String villeDepart;
  final DateTime dateDepart;
  final DateTime dateRetour;
  final String image;
  final int prix;
  final int rabais;
  final bool vedette;
  final Hotel hotel;

  Forfait({required this.id, required this.destination,required this.villeDepart,required this.hotel,required this.dateDepart,required this.dateRetour, required this.image,required this.prix,required this.rabais,required this.vedette});

  factory Forfait.fromJson(Map<String, dynamic> json) {
    return Forfait(
      id: json['_id'],
      destination: json['destination'],
      villeDepart: json['villeDepart'],
      dateDepart: DateTime.parse("2021-01-01"), //DateTime.parse(json['dateDepartD']),
      dateRetour: DateTime.parse("2021-01-01"), //DateTime.parse(json['dateRetourD']),
      image: json['image'],
      prix: json['prix'],
      rabais: json['rabais'],
      vedette: json['vedette'],
      hotel:Hotel.fromJson(json['hotel']),

    );
  }

}

class Hotel {
  final String nom;
  final String coordonnees;
  final int nombreEtoiles;
  final int nombreChambres;
  final List<String> caracteristiques;

  Hotel({required this.nom,required this.coordonnees,required this.nombreEtoiles,required this.nombreChambres,required this.caracteristiques});

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      nom:json['nom'],
      coordonnees:json['coordonnees'],
      nombreEtoiles: json['nombreEtoiles'],
      nombreChambres: json['nombreChambres'],
      caracteristiques: new List<String>.from(json['caracteristiques'])
    );
  }
}

class StarDisplay extends StatelessWidget {
  final int value;
  const StarDisplay({Key? key, this.value = 0})
      : assert(value != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < value ? Icons.star : Icons.star_border,
        );
      }),
    );
  }
}






