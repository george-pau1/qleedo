import 'package:flutter/material.dart';
import 'package:qleedo/index.dart';
import 'package:qleedo/models/prayer.dart';
import 'package:qleedo/models/saints.dart';
import 'package:qleedo/service/webservices_call.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

class SaintsDetailsView extends StatefulWidget {
  static const routeName = '\SAINTSHOME';
  final Saints selectedSaints;
  final String type;

  const SaintsDetailsView({
    Key? key, 
    required this.selectedSaints, 
    required this.type
  }) : super(key: key);

  @override
  _SaintsDetailsViewState createState() => _SaintsDetailsViewState();
}

class _SaintsDetailsViewState extends State<SaintsDetailsView> with TickerProviderStateMixin {
  bool _isLoading = false;
  late Saints _currentSaint;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    
    if (widget.type == "L") {
      _currentSaint = widget.selectedSaints;
      _fadeController.forward();
    } else {
      _isLoading = true;
      _getSaintsDetails(widget.selectedSaints.id);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeConfiguration>(context);
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: themeData.appNavBg,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: themeData.appNavBg,
              ),
            )
          : FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildHeader(themeData, size),
                    _buildContent(themeData),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHeader(ThemeConfiguration themeData, Size size) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Background Image with Gradient Overlay
        Container(
          height: size.height * 0.4,
          width: double.infinity,
          decoration: BoxDecoration(
            color: themeData.appNavBg,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            boxShadow: [
              BoxShadow(
                color: themeData.appNavBg.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  themeData.appNavBg.withOpacity(0.8),
                  themeData.appNavBg,
                ],
              ).createShader(rect);
            },
            blendMode: BlendMode.dstIn,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(_currentSaint.imageUrl),
                  fit: BoxFit.cover,
                  opacity: 0.1,
                ),
              ),
            ),
          ),
        ),
        
        // Saint Information
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 100),
              // Saint Image
              Hero(
                tag: 'saint-${_currentSaint.id}',
                child: Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: themeData.appNavBg.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(4),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: _currentSaint.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.person,
                          size: 70,
                          color: Colors.grey[400],
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.error_outline,
                          size: 70,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Saint Name
              Text(
                _currentSaint.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.merriweather(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Feast Date
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Text(
                  _currentSaint.feastDate,
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              const SizedBox(height: 10),
              
              // Period
              Text(
                _currentSaint.period,
                style: GoogleFonts.lato(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                ),
              ),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent(ThemeConfiguration themeData) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 30),
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 5,
                  decoration: BoxDecoration(
                    color: themeData.appNavBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  "Biography",
                  style: GoogleFonts.merriweather(
                    color: themeData.appNavBg,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            child: Text(
              _currentSaint.description,
              style: GoogleFonts.lato(
                color: Colors.black87,
                fontSize: 16,
                height: 1.7,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getSaintsDetails(id) async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      WebService service = WebService();
      Map<String, String> headers = {"accept": "application/json"};
      final response = await service.getResponse("$saintsApi$id", headers);
      
      Map<String, dynamic> jsonData = response;
      var status = jsonData[statusKey];
      
      if (status == 200) {
        var data = jsonData[dataKey];
        var saints = Saints.fromJson(data);
        
        setState(() {
          _currentSaint = saints;
          _isLoading = false;
        });
        
        _fadeController.forward();
      } else {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(jsonData[messageKey] ?? "Failed to load saint details"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}