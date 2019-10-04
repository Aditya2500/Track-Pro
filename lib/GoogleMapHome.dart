import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tracking06/services/http_request.dart';
import 'package:tracking06/utils/sharedUtils.dart';

class GoogleMapHome extends StatefulWidget {
  @override
  _GoogleMapHomeState createState() => _GoogleMapHomeState();
}

class _GoogleMapHomeState extends State<GoogleMapHome> {
  Completer<GoogleMapController> _controller = Completer();

  GoogleMapController _controller1;
  final Set<Polyline> _polyline = {};
  LatLng _lastMapPosition = LatLng(33.738045, 73.084488);
  List<LatLng> latlng = List();
  LatLng _new = LatLng(22.108278, 88.337194);
  LatLng _news = LatLng(22.758278,
      88.337194); // this latlng should be of static or home address latlng
  int count = 0;

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  final Set<Marker> _markers = {};

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onAddMarkerButtonPressed(LatLng _position) {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _position,
        infoWindow: InfoWindow(
          title: _position.toString(),
          snippet: 'near',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(-33.852, 151.211),
    zoom: 11.0,
  );

  CameraPosition _position = _kInitialPosition;
  void _updateCameraPosition(CameraPosition position) {
    setState(() {
      _position = position;
    });
  }

  String email = '';
  String deviceId = '';
  String firebaseId = '';
  var items ;

  @override
  void initState() {
    super.initState();
    latlng.add(_new);
    latlng.add(_news);
    _polyline.add(Polyline(
        polylineId: PolylineId(_lastMapPosition.toString()),
        visible: true,
        //latlng is List<LatLng>
        points: latlng,
        color: Colors.red[800]));
    Timer.periodic(new Duration(seconds: 10), (timer) {


      SessionStorage.getCurrentUser('user_email').then((value) {
        setState(() {
          this.email = value;
        });
      });
      SessionStorage.getCurrentUser('uid').then((value) {
        setState(() {
          this.firebaseId = value;
          TrackerApiService.listDevices(this.firebaseId, this.email)
              .then((value) {
            setState(() {                          
              items = value["items"][0]["lastLog"]["gpsData"];             
              _onAddMarkerButtonPressed(LatLng(items["lat"],items["lon"]));
              _gotoLocation(items["lat"],items["lon"]);
            });
          });
        });
      });

      

      // double lats = 22.758278 + (count * 0.01);
      // //print(lats);
      // count++;
      // _new = LatLng(lats, 88.337194);
      // latlng.add(_new);
      //_onAddMarkerButtonPressed(LatLng(lats, 88.337194));
      // _gotoLocation(lats,88.337194);

      // _polyline.add(Polyline(
      //           polylineId: PolylineId(_lastMapPosition.toString()),
      //           visible: true,
      //           //latlng is List<LatLng>
      //           points: latlng,
      //           color: Colors.red[800]
      //       ));
    });
  }

  double zoomVal = 5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(context),
          // _zoomminusfunction(),
          //_zoomplusfunction(),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: _onMapTypeButtonPressed,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.map, size: 36.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      //-----END of the BODY PART of the APP ----
    );
  }

  Widget _zoomminusfunction() {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        icon: Icon(
          FontAwesomeIcons.searchMinus,
          color: Color(0xff6200ee),
        ),
        onPressed: () {
          zoomVal--;

          _minus(zoomVal);
        },
      ),
    );
  }
  //-----END of the ZOOM IN FUNCTION -----

  //-----ZOOM OUT FUNCTION BEGINS -----

  Widget _zoomplusfunction() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: Icon(
          FontAwesomeIcons.searchPlus,
          color: Color(0xff6200ee),
        ),
        onPressed: () {
          zoomVal++;

          _minus(zoomVal);
        },
      ),
    );
  }
  //-----END of the ZOOM OUT FUNCTION -----

  //----"_minus()" FUNCTION BEGINS----

  Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(22.5726, 88.3639),
      zoom: zoomVal,
    )));
  }

  Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(22.5726, 88.3639),
      zoom: zoomVal,
    )));
  }

  Widget _boxes(String _image, double lat, double long, String restaurantName) {
    return GestureDetector(
      onTap: () {
        _gotoLocation(lat, long);
      },
      child: Container(
        child: new FittedBox(
          child: Material(
            color: Colors.white,
            elevation: 14.0,
            borderRadius: BorderRadius.circular(24.0),
            shadowColor: Color(0x802196f3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 180,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24.0),
                    child: Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(_image),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: myDetailsContainer(restaurantName),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //----"myDetailsContainer" Widget Begins ------

  Widget myDetailsContainer(String restaurantName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(
            restaurantName,
            style: TextStyle(
                color: Color(0xff6200ee),
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          )),
        ),
        SizedBox(height: 5.0),
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                child: Text(
              "4.1",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
            )),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStarHalf,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
                child: Text(
              "(946)",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
            )),
          ],
        )),
        SizedBox(height: 5.0),
        Container(
            child: Text(
          "American \u00B7 \u0024\u0024 \u00B7 1.6 mi",
          style: TextStyle(
            color: Colors.black54,
            fontSize: 18.0,
          ),
        )),
        SizedBox(height: 5.0),
        Container(
            child: Text(
          "Closed \u00B7 Opens 17:00 Thu",
          style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        )),
      ],
    );
  }
  //----END of "myDetailsContainer" Widget ------

  //-----"_googleMap" Widget BEGINS -----

  Widget _buildGoogleMap(BuildContext context) {
    _onAddMarkerButtonPressed(LatLng(22.758278, 88.337194));
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: _currentMapType,

        /**Here 'initialCameraPositions' 
         * shows the location in google 
        */

        initialCameraPosition: CameraPosition(
          target: LatLng(22.5726, 88.3639),
          zoom: 9,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        //  onMapCreated: (GoogleMapController controller) {
        //   _controller1 =    controller;
        // },
        // onMapCreated: this._setMapController,
        markers: _markers,
        //polylines: _polyline,
        //onCameraMove: _updateCameraPosition,
      ),
    );
  }

  void _setMapController(GoogleMapController controller) {
    this._controller1 = controller;
    controller.moveCamera(
        CameraUpdate.newLatLngZoom(LatLng(22.758278, 88.337194), 12));
  }

  //-----"_googleMap" Widget BEGINS ----

  //----"_gotoLocation()" Future Begins ------

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;

    /**HERE "controller" Animate the CAMERA POSITION
    * to that particular lattitude & longitude value
    */
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 16,
      tilt: 50.0,
      bearing: 45.0,
    )));
  }

  //----END of "_gotoLocation()" Future ------

}

//----- 'gramercyMarker' Begins -----

Marker gramercyMarker = Marker(
  markerId: MarkerId('gramercy'),
  position: LatLng(22.758278, 88.337194),
  infoWindow: InfoWindow(title: 'Gramercy Tavern'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);

//----- 'bernardinMarker' Begins -----

Marker bernardinMarker = Marker(
  markerId: MarkerId('bernardin'),
  position: LatLng(40.761421, -73.981667),
  infoWindow: InfoWindow(title: 'Le Bernardin'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);

//----- 'blueMarker' Begins -----

Marker blueMarker = Marker(
  markerId: MarkerId('bluehill'),
  position: LatLng(40.732128, -73.999619),
  infoWindow: InfoWindow(title: 'Blue Hill'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);

//----- 'LOCATION marker' Begins -----

//1st place
Marker newyork1Marker = Marker(
  markerId: MarkerId('newyork1'),
  position: LatLng(40.742451, -74.005959),
  infoWindow: InfoWindow(title: "Los Tacos"),
  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
);

//2nd place
Marker newyork2Marker = Marker(
  markerId: MarkerId('newyork2'),
  position: LatLng(40.729640, -73.983510),
  infoWindow: InfoWindow(title: "Nargis"),
  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
);

//3rd place
Marker newyork3Marker = Marker(
  markerId: MarkerId('newyork3'),
  position: LatLng(440.719109, -74.000183),
  infoWindow: InfoWindow(title: "Taco Bell"),
  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
);
