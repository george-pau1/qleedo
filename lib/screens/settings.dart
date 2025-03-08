import 'package:cupertino_setting_control/cupertino_setting_control.dart';
import 'package:flutter/material.dart';

class ExampleApp extends StatelessWidget {
  static const routeName = '\Settings';
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.indigo,
        colorScheme: ColorScheme.light(
          primary: Colors.indigo,
          secondary: Colors.indigoAccent,
          surface: Colors.white,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.indigo),
          titleTextStyle: TextStyle(
            color: Colors.indigo,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => new _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  bool _chatResult = true;
  String _searchAreaResult = 'Germany';
  bool _titleOnTop = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Settings'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              // Theme toggle functionality could be added here
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          _buildTitleOnTopSwitch(),
          _buildSectionDivider(),
          _buildProfileSettings(),
          _buildSectionDivider(),
          _buildDashboardSettings(),
          _buildSectionDivider(),
          _buildPrivacySettings(),
          _buildSectionDivider(),
          _buildLegalSettings(),
          _buildSectionDivider(),
          _buildProfileOptions(),
        ],
      ),
    );
  }

  Widget _buildSectionDivider() {
    return SizedBox(height: 20);
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 8),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.indigo,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildTitleOnTopSwitch() {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: SettingRow(
          rowData: SettingsYesNoConfig(
            initialValue: _titleOnTop,
            title: 'Title on top',
          ),
          config: const SettingsRowConfiguration(showAsSingleSetting: true),
          onSettingDataRowChange: (newVal) => setState(() {
            _titleOnTop = newVal;
          }),
          style: SettingsRowStyle(
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Profile'),
            SettingRow(
              rowData: SettingsDropDownConfig(
                title: 'User Area',
                initialKey: _searchAreaResult,
                choices: {
                  'Germany': 'Germany',
                  'Spain': 'Spain',
                  'France': 'France'
                },
                onDropdownFinished: () => {},
              ),
              onSettingDataRowChange: onSearchAreaChange,
              config: SettingsRowConfiguration(
                showAsTextField: false,
                showTitleLeft: !_titleOnTop,
                showTopTitle: _titleOnTop,
                showAsSingleSetting: false,
              ),
              style: SettingsRowStyle(
                backgroundColor: Colors.transparent,
              ),
            ),
            SizedBox(height: _titleOnTop ? 10.0 : 0.0),
            SettingRow(
              rowData: SettingsSliderConfig(
                title: 'Age',
                from: 18,
                to: 120,
                initialValue: 20,
                justIntValues: true,
                unit: ' years',
              ),
              onSettingDataRowChange: (double resultVal) {},
              config: SettingsRowConfiguration(
                showAsTextField: false,
                showTitleLeft: !_titleOnTop,
                showTopTitle: _titleOnTop,
                showAsSingleSetting: false,
              ),
              style: SettingsRowStyle(
                backgroundColor: Colors.transparent,
              ),
            ),
            SizedBox(height: _titleOnTop ? 10.0 : 0.0),
            SettingRow(
              rowData: SettingsSliderFromToConfig(
                title: 'Weight',
                from: 40,
                to: 120,
                initialFrom: 50,
                initialTo: 80,
                justIntValues: true,
                unit: 'kg',
              ),
              onSettingDataRowChange: (List<double> resultVals) {},
              config: SettingsRowConfiguration(
                showAsTextField: false,
                showTitleLeft: !_titleOnTop,
                showTopTitle: _titleOnTop,
                showAsSingleSetting: false,
              ),
              style: SettingsRowStyle(
                backgroundColor: Colors.transparent,
              ),
            ),
            SizedBox(height: _titleOnTop ? 10.0 : 0.0),
            SettingRow(
              rowData: SettingsTextFieldConfig(
                title: 'Name',
                initialValue: 'Chris',
              ),
              onSettingDataRowChange: (String resultVal) {},
              config: SettingsRowConfiguration(
                showAsTextField: false,
                showTitleLeft: !_titleOnTop,
                showTopTitle: _titleOnTop,
                showAsSingleSetting: false,
              ),
              style: SettingsRowStyle(
                backgroundColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Dashboard Settings'),
            SettingRow(
              config: SettingsRowConfiguration(
                showTitleLeft: !_titleOnTop, 
                showTopTitle: _titleOnTop,
              ),
              rowData: SettingsYesNoConfig(
                initialValue: _chatResult, 
                title: 'Today Saints',
              ),
              onSettingDataRowChange: onChatSettingChange,
              style: SettingsRowStyle(
                backgroundColor: Colors.transparent,
              ),
            ),
            SettingRow(
              config: SettingsRowConfiguration(
                showTitleLeft: !_titleOnTop, 
                showTopTitle: _titleOnTop,
              ),
              rowData: SettingsYesNoConfig(
                initialValue: _chatResult, 
                title: 'Todays Verse',
              ),
              onSettingDataRowChange: onChatSettingChange,
              style: SettingsRowStyle(
                backgroundColor: Colors.transparent,
              ),
            ),
            SettingRow(
              config: SettingsRowConfiguration(
                showTitleLeft: !_titleOnTop, 
                showTopTitle: _titleOnTop,
              ),
              rowData: SettingsYesNoConfig(
                initialValue: _chatResult, 
                title: 'Today Prayer',
              ),
              onSettingDataRowChange: onChatSettingChange,
              style: SettingsRowStyle(
                backgroundColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Privacy Settings'),
            SettingRow(
              config: SettingsRowConfiguration(
                showTitleLeft: !_titleOnTop, 
                showTopTitle: _titleOnTop,
              ),
              rowData: SettingsYesNoConfig(
                initialValue: _chatResult, 
                title: 'Allow Chat',
              ),
              onSettingDataRowChange: onChatSettingChange,
              style: SettingsRowStyle(
                backgroundColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Legal'),
            SettingRow(
              config: SettingsRowConfiguration(
                showTitleLeft: !_titleOnTop, 
                showTopTitle: _titleOnTop,
              ),
              rowData: SettingsURLConfig(
                title: 'Privacy', 
                url: 'https://yourprivacystuff.de',
              ),
              onSettingDataRowChange: () => {},
              style: SettingsRowStyle(
                backgroundColor: Colors.transparent,
              ),
            ),
            SizedBox(height: _titleOnTop ? 10.0 : 0.0),
            SettingRow(
              config: SettingsRowConfiguration(
                showTitleLeft: !_titleOnTop, 
                showTopTitle: _titleOnTop,
              ),
              rowData: SettingsButtonConfig(
                title: 'Licenses',
                tick: true,
                functionToCall: () => showLicensePage(
                  context: context,
                  applicationName: 'example',
                  applicationVersion: 'v1.1',
                  useRootNavigator: true,
                ),
              ),
              onSettingDataRowChange: () => {},
              style: SettingsRowStyle(
                backgroundColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOptions() {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Profile Options'),
            SettingRow(
              rowData: SettingsButtonConfig(
                title: 'Delete Profile',
                tick: true,
                functionToCall: () {},
              ),
              style: SettingsRowStyle(
                backgroundColor: Colors.transparent,
           //     titleTextStyle: TextStyle(
         //         color: Colors.red[700],
         //         fontWeight: FontWeight.w500,
         //       ),
         //       iconColor: Colors.red[700],
              ),
              config: SettingsRowConfiguration(
                showAsTextField: false,
                showTitleLeft: !_titleOnTop,
                showTopTitle: _titleOnTop,
                showAsSingleSetting: false,
              ),
              onSettingDataRowChange: () => {},
            ),
          ],
        ),
      ),
    );
  }

  void onChatSettingChange(bool data) {
    setState(() {
      _chatResult = data;
    });
  }

  void onSearchAreaChange(String data) {
    setState(() {
      _searchAreaResult = data;
    });
  }
}