import 'package:qleedo/models/prayer.dart';
import 'package:qleedo/index.dart';
import 'package:qleedo/screens/html_view_inapp.dart';
import 'package:qleedo/screens/html_view_web.dart';
import 'package:http/http.dart' as http; // Added explicit http import

class PrayerListView extends StatefulWidget {
  static const routeName = '/PrayerListView'; // Fixed forward slash
  final String prayerSet;
  final String prayerCollection;
  final String prayerCollectionName;

  const PrayerListView({ // Added const constructor
      Key? key,
      required this.prayerSet,
      required this.prayerCollection,
      required this.prayerCollectionName})
      : super(key: key);

  @override
  _PrayerListViewState createState() => _PrayerListViewState(); // Renamed state class to match widget
}

class _PrayerListViewState extends State<PrayerListView>
  with SingleTickerProviderStateMixin {
  List<Prayer> prayerList = [];
  var isLoading = true;

  @override
  void initState() {
    super.initState();
    getPrayerList();
  }

  void getPrayerList() async {
    var urlParameters = '$keyParseServerUrl/classes/Prayer?where={"Collection":"${widget.prayerCollection}","Set":"${widget.prayerSet}","Status":"A"}&order=Name,Language';

    final uri = Uri.parse(urlParameters);
    print("...getPrayerList.....$urlParameters..");

    try { // Added try-catch for error handling
      final response = await http.get( // Added explicit http namespace
        uri,
        headers: <String, String>{
          'Content-Type': contentType,
          'X-Parse-Application-Id': keyParseApplicationId,
          'X-Parse-REST-API-Key': restAPIKey
        },
      );

      if (response.statusCode == 200) {
        var getdata = json.decode(response.body);
        var data = getdata["results"];
        var prayerCollect =
                (data as List).map((data) => Prayer.fromJson(data)).toList();

        if (mounted) { // Check if widget is still mounted
          setState(() {
            prayerList = prayerCollect;
            isLoading = false;
          });
        }
      } else {
        print("......getPrayerCollection....Error.....${response.statusCode}....");
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) { // Error handling
      print("......getPrayerCollection....Exception.....${e.toString()}....");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override // Added override annotation
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeConfiguration>(context);
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeData.appNavBg,
        leading: navBackButton(themeData, context),
        title: Text(
          widget.prayerCollectionName,
          style: TextStyle(color: themeData.appNavTextColor),
        ),
      ),
      body: isLoading
          ? showCircularProgress(themeData, deviceWidth, deviceHeight)
          : ListView.builder(
              itemCount: prayerList.length,
              itemBuilder: (context, position) {
                return GestureDetector(
                    child: Card(
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              prayerList[position].name,
                              style: TextStyle(
                                  fontSize: 22.0, color: themeData.textColor),
                            ),
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: themeData.textColor,
                              )),
                        ],
                      ),
                    ),
                    onTap: () {
                      print(
                          "....$kIsWeb.....prayer selected list......${prayerList[position].prayerUrl}.....");
                      if (kIsWeb) {
                        // running on the web!
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HtmlViewWeb(
                              name: prayerList[position].name,
                              objectID: prayerList[position].objectID,
                              pageType: 'PR',
                              collectionName: "Prayer",
                              htmlurl: prayerList[position].prayerUrl
                            ),
                          ));
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HtmlViewInApp(
                              name: prayerList[position].name,
                              objectID: prayerList[position].objectID,
                              pageType: 'PR',
                              collectionName: "Prayer",
                              htmlurl: prayerList[position].prayerUrl
                            ),
                          ));
                      }
                    });
              },
            ),
    );
  }
}