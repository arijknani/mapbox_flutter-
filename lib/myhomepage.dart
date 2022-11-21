import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:geolocator/geolocator.dart' ;
import 'package:mapbox/profile_page.dart';
import 'package:mapbox/signin_screen.dart';
import 'package:flutter_mapbox_autocomplete/flutter_mapbox_autocomplete.dart';





class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MapController _mapctl = MapController();



  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }
  @override
  void initState() {
    super.initState();
    _determinePosition();
  }
  double lat = 0;
  double long = 0;
  void current_location() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });
    var newlatlng = latlong.LatLng(lat, long);
    double zoom = 12.0;
    _mapctl.move(newlatlng, zoom);
  }

  double latplace = 0;
  double longplace = 0;
  late MapBoxPlace _place;


  void showplace(MapBoxPlace place) async {
    setState(() {
      var list = place.geometry?.coordinates;
      longplace = list![0];
      latplace = list[1];
      _place =place;



    });
    var newlatlng = latlong.LatLng(latplace, longplace);
    double zoom = 12.0;
    _mapctl.move(newlatlng, zoom);}

    double latdestination=0;
    double longdestination=0;
    double latcurrent=0;
    double longcurrent=0;

   void destination() async {
      setState(() {
        latdestination=latplace;
        longdestination=longplace;
        latcurrent=lat;
        longcurrent=long;
      });
      var dest = latlong.LatLng(latdestination,longdestination);
      double zoom=7.0;
      _mapctl.move(dest, zoom);
    }


    double changelat =0;
    double changelong =0;
    void changeposition(latlong.LatLng _point){
      setState(() {
        changelat = _point.latitude;
        changelong = _point.longitude;
      });
    }
  final _startPointController = TextEditingController();

    @override
    Widget build(BuildContext context) {
      Future overview() async {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              "Overview:",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('latitude = $changelat'),
                  Text('longitude= $changelong'),
                ],
              ),
            ),

            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "ok",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          toolbarHeight: 70,
          title: const Text("Find your Location"),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                gradient: LinearGradient(
                    colors: [Colors.blueGrey,Colors.lightBlue],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter
                )
            ),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          leading: IconButton(
              onPressed: (){
                Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context)=> const ProfilePage())
                );
              }, 
              icon: const Icon(Icons.account_circle)),
          actions: [
            IconButton(
                onPressed: (){
                   FirebaseAuth.instance.signOut().then((value) {
                       print('signed out');
                       Navigator.push(context,
                           MaterialPageRoute(builder: (context)=> const MyLogin())
                       );
                     });
                   },
                icon: const Icon(Icons.logout_rounded), )
          ],
        ),
        resizeToAvoidBottomInset: false,
        body:
        Stack(
          children: [
            FlutterMap(
              mapController: _mapctl,
              options: MapOptions(
                center: latlong.LatLng(36.80278, 10.17972),
                maxZoom: 20.0,
                minZoom: 5.0,
                onTap: (tapPosition, point) => {
                  changeposition(point),
                  },
              ),
              layers: [
                TileLayerOptions(
                    urlTemplate: 'URL',
                    additionalOptions: {
                      'accessToken': 'YOUR_TOKEN'
                    }
                ),
                MarkerLayerOptions(
                  rotate: true,
                    markers: [
                      Marker(
                          point: latlong.LatLng(latplace, longplace),
                          builder: (context) =>
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context ) => DataPage(_place)),
                                  );
                                },
                                icon: const Icon(Icons.location_on),
                                iconSize: 40.0,
                                color: Colors.red,
                          ),
                               ),
                      Marker(
                        point: latlong.LatLng(lat, long),
                          builder: (ctx) =>
                              Icon(
                                  size: 50.0,
                                  color: Colors.blue,
                                  Icons.boy_rounded),
                      ),
                      Marker(
                        point:  latlong.LatLng(changelat,changelong),
                        builder: (context) =>
                            IconButton(
                              onPressed: () => overview(),
                              icon: Icon(Icons.location_on),
                              iconSize: 50.0,
                              color: Colors.red,
                            ),
                      ),

                    ]
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  child: CustomTextField(
                    prefixIcon: const Icon(Icons.search),
                    hintText: "search",
                    textController: _startPointController,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MapBoxAutoCompleteWidget(
                                apiKey: "API_KEY", hint: "Select starting point",
                                onSelect: (place) {
                                  _startPointController.text = place.placeName!;
                                  showplace(place);
                            },
                            limit: 10,
                          ),
                              ),

                      );
                    },
                    enabled: true,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:450),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FloatingActionButton(
                        backgroundColor: Colors.amber,
                        onPressed: () => current_location(),
                        child: const Icon(Icons.location_searching)),
                  ),
                ),
              ],
            )
          ],
        ),

      );
    }
}



class DataPage extends StatefulWidget {
  MapBoxPlace _place;
  DataPage(
      this._place);

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'this is my data',
        ),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "name=${widget._place.placeName}",
                  style:
                  const TextStyle(
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "id=${widget._place.id}",
                  style:
                  const TextStyle(
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("latitude= ${widget._place.geometry?.coordinates![1]}",
                    style:
                    const TextStyle(
                          fontWeight: FontWeight.bold),

                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("longitude= ${widget._place.geometry?.coordinates![0]}",
                  style:
                  const TextStyle(
                      fontWeight: FontWeight.bold),

                ),
              ],
            ),
          ]
      ),
    );
  }
}












