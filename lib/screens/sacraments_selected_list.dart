
import 'package:qleedo/screens/html_view_inapp.dart';
import 'package:qleedo/screens/html_view_web.dart';
import 'package:qleedo/index.dart';


class SacramentListView extends StatefulWidget {
  static const routeName = '\SacramentLists';
  final String sacramentCollection;
  final String sacramentCollectionName;

  SacramentListView(
      {Key? key,
      required this.sacramentCollection,
      required this.sacramentCollectionName})
      : super(key: key);

  @override
  _SacramentListPageState createState() => _SacramentListPageState();
}

class _SacramentListPageState extends State<SacramentListView>
    with SingleTickerProviderStateMixin {
  List<SacramentsOld> sacramentList = [];
  var isLoading = true, _isNetworkAvail = true;

  @override
  void initState() {
    super.initState();
    //getSacrament();
    getSacramentList();
  }

  void getSacramentList() async {
  final urlParameters = '$keyParseServerUrl/classes/Sacrament?where={"Collection":"${widget.sacramentCollection}", "Status":"A"}&order=Name';
  final uri = Uri.parse(urlParameters);

  // Debug: Print URL for verification
  print("Fetching URL: $urlParameters");

  try {
    final response = await get(
      uri,
      headers: <String, String>{
        'Content-Type': contentType,
        'X-Parse-Application-Id': keyParseApplicationId,
        'X-Parse-REST-API-Key': restAPIKey,
      },
    );

    // Debug: Print the status code and response body
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final getdata = jsonDecode(response.body);

      // Ensure results is a valid list
      if (getdata["results"] != null && getdata["results"] is List) {
        final List<dynamic> data = getdata["results"];
        final List<SacramentsOld> prayerCollect = data
            .map((item) => SacramentsOld.fromJsonSacramentList(item))
            .toList();

        setState(() {
          sacramentList = prayerCollect;
          isLoading = false;
        });
      } else {
        // Handle case where no data is found
        print("No data found.");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      // Handle non-200 responses
      print("Error: ${response.statusCode} - ${response.reasonPhrase}");
      setState(() {
        isLoading = false;
      });
    }
  } catch (e) {
    // Handle exceptions
    print("Exception: $e");
    setState(() {
      isLoading = false;
    });
  }
}



  Widget build(BuildContext context) {
  final themeData = Provider.of<ThemeConfiguration>(context);
  double deviceHeight = MediaQuery.of(context).size.height;
  double deviceWidth = MediaQuery.of(context).size.width;

  return Scaffold(
    appBar: AppBar(
      backgroundColor: themeData.appNavBg,
      leading: navBackButton(themeData, context),
      title: Text(
        "${widget.sacramentCollectionName}",
        style: TextStyle(
          color: themeData.appNavTextColor,
          fontSize: AppConstants.headingFontSize,
          fontWeight: AppConstants.fontWeight,
        ),
      ),
    ),
    body: isLoading
        ? showCircularProgress(themeData, deviceWidth, deviceHeight)
        : ListView.builder(
            itemCount: sacramentList.length,
            itemBuilder: (context, position) {
              return GestureDetector(
                child: Card(
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          sacramentList[position].name,
                          style: TextStyle(
                            fontSize: 22.0,
                            color: themeData.listTextColor,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: themeData.listTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  final url = sacramentList[position].sacramentUrl;
                  if (url != null && url.isNotEmpty) {
                    print("Sacrament Selected: Name - ${sacramentList[position].name}, URL - $url");

                    if (kIsWeb) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HtmlViewWeb(
                            name: sacramentList[position].name,
                            collectionName: "Sacrament",
                            objectID: sacramentList[position].objectID,
                            pageType: "SA",
                            htmlurl: url,
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HtmlViewInApp(
                            name: sacramentList[position].name,
                            collectionName: "Sacrament",
                            objectID: sacramentList[position].objectID,
                            pageType: "SA",
                            htmlurl: url,
                          ),
                        ),
                      );
                    }
                  } else {
                    print("Invalid URL for sacrament: ${sacramentList[position].name}");
                  }
                },
              );
            },
          ),
  );
}
    }