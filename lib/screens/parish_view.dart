
import 'package:qleedo/models/Parishs.dart';
import 'package:qleedo/index.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';

class ParishView extends StatefulWidget {
  static const routeName = '\ParishView';
  Parishs selectedParish;
  
  ParishView({Key? key, required this.selectedParish,}) : super(key: key);


  @override
  _ParishViewState createState() => _ParishViewState();
}

class _ParishViewState extends State<ParishView> {
  bool isLoading = true;
  // late GoogleMapController mapController;
  // List<Marker> markers = <Marker>[];
  // Completer<GoogleMapController> controller = Completer();
  // double lat = 0.0, lng = 0.0;
  // void onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  // }

  @override
  void initState() {
    super.initState();
    // lat  = widget.selectedParish.latitude != "" ? double.parse(widget.selectedParish.latitude) : 0.0;
    // lng  = widget.selectedParish.longitude != "" ? double.parse(widget.selectedParish.longitude) : 0.0;
    // markers.add(Marker(markerId: MarkerId(widget.selectedParish.id.toString()),
    //               position: LatLng(lat,lng),
    //               infoWindow: InfoWindow(title: widget.selectedParish.name)));
    
  }

 

  @override
  Widget build(BuildContext context) {
    // print("...$lng......build...$lat..");

    final themeData = Provider.of<ThemeConfiguration>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeData.appNavBg,
        title: Text(
          widget.selectedParish.name,
          style: TextStyle(
              color: themeData.appNavTextColor,
              fontSize: AppConstants.headingFontSize,
              fontWeight: AppConstants.fontWeight),
        ),
        leading: navBackButton(themeData, context),
      ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: isLoading
    ? Center(child: CircularProgressIndicator())
    : Center(child: Text("Parish Details")),

  );}


}
