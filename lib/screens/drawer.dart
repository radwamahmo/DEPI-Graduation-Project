import 'dart:io';
import 'package:event_countdown/generated/l10n.dart';
import 'package:event_countdown/main.dart';
import 'package:event_countdown/screens/notifications/notification.dart';
import 'package:event_countdown/data/provider_drawer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _isNightMode = false;
  String _selectedLanguage = 'En';
  String _username = 'UserName';
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isNightMode = prefs.getBool('nightMode') ?? false;
      _selectedLanguage = prefs.getString('language') ?? 'En';
      _username = prefs.getString('username') ?? 'UserName';
      String? imagePath = prefs.getString('profileImage');
      if (imagePath != null) {
        _profileImage = File(imagePath);
      }
    });
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('nightMode', _isNightMode);
    prefs.setString('language', _selectedLanguage);
    prefs.setString('username', _username);
    if (_profileImage != null) {
      prefs.setString('profileImage', _profileImage!.path);
    }
  }

  Future<void> _pickProfileImage() async {
    final ImagePicker _picker = ImagePicker();
    final action = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          S.of(context).profile_picture,
          style: TextStyle(fontSize: 24),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    child: Column(
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: Theme.of(context).colorScheme.primary,
                          size: 50,
                        ),
                        Text(
                          S.of(context).camera,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ],
                    ),
                    onPressed: () => Navigator.of(context).pop(0),
                  ),
                ],
              ),
              SizedBox(width: 50),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    child: Column(
                      children: [
                        Icon(
                          Icons.photo_library,
                          color: Theme.of(context).colorScheme.primary,
                          size: 50,
                        ),
                        Text(
                          S.of(context).gallery,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ],
                    ),
                    onPressed: () => Navigator.of(context).pop(1),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );

    if (action != null) {
      XFile? pickedImage;
      if (action == 0) {
        pickedImage = await _picker.pickImage(source: ImageSource.camera);
      } else if (action == 1) {
        pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      }

      if (pickedImage != null) {
        setState(() {
          _profileImage = File(pickedImage!.path);
        });
        _saveSettings(); // Save the profile image path
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Drawer(
      child: Container(
        color: isDarkMode ? Color(0xff1B1B1B) : Color(0xffBFBFDB),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: 85.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  S.of(context).app_name,
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Color(0xFF0D1445),
                      fontSize: 30),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.white,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? Icon(Icons.person,
                                size: 50, color: Colors.black45)
                            : null,
                      ),
                      Positioned(
                        bottom: -1,
                        right: -1,
                        child: GestureDetector(
                          onTap: _pickProfileImage,
                          child: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            radius: 17,
                            child: Icon(Icons.camera_alt,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person,
                              color: isDarkMode
                                  ? Colors.white
                                  : Color(0xFF0D1445)),
                          SizedBox(width: 12.0),
                          // check username that entered by the user and replaced it
                          Text(
                            _username != S.of(context).username
                                ? _username
                                : "",
                            style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white
                                    : Color(0xFF0D1445),
                                fontSize: 18),
                          ),
                          // the default "UserName" of the drawer
                          if (_username == S.of(context).username)
                            Text(
                              S.of(context).username,
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white
                                    : Color(0xFF0D1445),
                                fontSize: 18,
                              ),
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: IconButton(
                          icon: Icon(Icons.edit,
                              color: isDarkMode
                                  ? Colors.white
                                  : Color(0xFF0D1445)),
                          onPressed: _editUsername,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(
                S.of(context).settings,
                style: TextStyle(
                    color: isDarkMode ? Colors.white : Color(0xFF0D1445),
                    fontSize: 20),
              ),
            ),
            SwitchListTile(
              secondary: Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: isDarkMode ? Colors.white : Color(0xff1B1B1B),
              ),
              title: Text(S.of(context).night_mode,
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Color(0xFF0D1445))),
              value: _isNightMode,
              activeColor: Colors.blue,
              onChanged: (bool value) {
                setState(() {
                  _isNightMode = value;
                });
                _saveSettings(); // Save night mode state
                final provider =
                    Provider.of<ThemeProvider>(context, listen: false);
                provider.toggleTheme(value);
              },
            ),
            ListTile(
              leading: Icon(Icons.language,
                  color: isDarkMode ? Colors.white : Color(0xFF0D1445)),
              title: Text(S.of(context).language,
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Color(0xFF0D1445))),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  _selectedLanguage,
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Color(0xFF0D1445),
                      fontSize: 20),
                ),
              ),
              onTap: _selectLanguage,
            ),
            ListTile(
              leading: Icon(Icons.notifications,
                  color: isDarkMode ? Colors.white : Color(0xFF0D1445)),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).notifications,
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Color(0xFF0D1445)),
                  ),
                  SizedBox(width: 8.0),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(Icons.arrow_forward_ios,
                        color: isDarkMode ? Colors.white : Color(0xFF0D1445)),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationHistory(),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _editUsername() {
    showDialog(
      context: context,
      builder: (context) {
        // Initialize the controller with an empty string instead of the current username
        TextEditingController _usernameController = TextEditingController();

        return AlertDialog(
          title: Text(S.of(context).edit_username),
          content: TextField(
            controller: _usernameController,
            decoration: InputDecoration(hintText: S.of(context).enter_username),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  // Only update username if the text field is not empty
                  if (_usernameController.text.isNotEmpty) {
                    _username = _usernameController.text;
                    _saveSettings();
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text(
                S.of(context).save_button,
              ),
            ),
          ],
        );
      },
    );
  }

  void _selectLanguage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).select_language),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(S.of(context).english),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'En';
                    _saveSettings();
                    _changeLanguage('en'); // تغيير اللغة إلى الإنجليزية
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text(S.of(context).arabic),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'Ar';
                    _saveSettings();
                    _changeLanguage('ar'); // تغيير اللغة إلى العربية
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _changeLanguage(String languageCode) async {
    Locale _locale = Locale(languageCode);
    S.load(_locale); // تحميل الترجمة الجديدة
    MyApp.setLocale(context, _locale); // تحديث Locale في التطبيق

    // حفظ اللغة في SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
  }
}
