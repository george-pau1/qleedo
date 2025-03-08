import 'package:qleedo/screens/media_list.dart';
import 'package:qleedo/screens/prayer_list.dart';
import 'package:qleedo/screens/sacraments_list.dart';
import 'package:qleedo/screens/saints_home.dart';
import 'package:qleedo/screens/dashboard.dart';
import 'package:qleedo/screens/calendar.dart';
import 'package:qleedo/screens/settings.dart';
import 'package:qleedo/screens/bible.dart';
import 'package:qleedo/index.dart';
import 'package:qleedo/screens/parish_list.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeConfiguration>(context);
    final size = MediaQuery.of(context).size;
    
    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: themeData.bgColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(5, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: themeData.appNavBg,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                ),
                image: const DecorationImage(
                  image: AssetImage("assets/images/logotop/logo_top_1.png"),
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
              ),
            ),
            
            // Menu items in a scrollable list
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildMenuCategory("Main", themeData),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.dashboard_rounded,
                    title: "Dashboard",
                    themeData: themeData,
                    onTap: () => _navigateTo(context, Dashboard.routeName),
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.menu_book_rounded,
                    title: "Holy Bible",
                    themeData: themeData,
                    onTap: () => _navigateTo(context, BiblePage.routeName),
                  ),
                  
                  _buildMenuCategory("Spiritual", themeData),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.favorite_rounded,
                    title: "Prayers",
                    themeData: themeData,
                    onTap: () => _navigateTo(context, PryerList.routeName),
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.spa_rounded,
                    title: "Sacraments",
                    themeData: themeData,
                    onTap: () => _navigateTo(context, SacramentList.routeName),
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.auto_awesome_rounded,
                    title: "Gallery of Saints",
                    themeData: themeData,
                    onTap: () => _navigateTo(context, SaintsList.routeName),
                  ),
                  
                  _buildMenuCategory("Content", themeData),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.play_circle_filled_rounded,
                    title: "Media Center",
                    themeData: themeData,
                    onTap: () => _navigateTo(context, MediaList.routeName),
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.event_rounded,
                    title: "Calendar",
                    themeData: themeData,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScheduledEvents(selectedDate: DateTime.now()),
                        ),
                      );
                    },
                  ),
                  
                  _buildMenuCategory("Personal", themeData),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.person_rounded,
                    title: "User Profile",
                    themeData: themeData,
                    onTap: () => _navigateTo(context, ExampleApp.routeName),
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.church_rounded,
                    title: "Find Parish",
                    themeData: themeData,
                    onTap: () => _navigateTo(context, ParishList.routeName),
                  ),
                ],
              ),
            ),
            
            // Footer with version info
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                "Qleedo v1.0",
                style: TextStyle(
                  color: themeData.textColor.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMenuCategory(String title, ThemeConfiguration themeData) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: themeData.textColor.withOpacity(0.5),
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
  
  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required ThemeConfiguration themeData,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          splashColor: themeData.brandColor.withOpacity(0.1),
          highlightColor: themeData.brandColor.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: themeData.textColor,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    color: themeData.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  void _navigateTo(BuildContext context, String routeName) {
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(routeName);
  }
}

void getLoadingCommon(BuildContext context, int marginTop, ThemeConfiguration theme) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.bgColor.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SpinKitRipple(
                  color: theme.brandColor,
                  size: 80.0,
                ),
                const SizedBox(height: 16),
                Text(
                  "Loading...",
                  style: TextStyle(
                    color: theme.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}