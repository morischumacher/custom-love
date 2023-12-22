import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_name_email.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/page_title.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../../config/theme.dart';
import '../../../service/location_service.dart';
import '../../../service/login_service.dart';
import '../../../service/user_service.dart';
import '../../authentification/pages/login_page.dart';

class RegistrationLocation extends StatefulWidget {
  const RegistrationLocation({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.gender,
    required this.preference,
    required this.birthdate,
    required this.profilePicture,
    required this.userInterestIdList
  }) : super(key: key);

  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final String? gender;
  final String? preference;
  final String? birthdate;
  final Uint8List? profilePicture;
  final Set<int> userInterestIdList;

  @override
  State<RegistrationLocation> createState() => _RegistrationLocationState();
}

class _RegistrationLocationState extends State<RegistrationLocation> {
  @override
  void initState() {
    super.initState();
    checkLocationPermission();
    firstName = widget.firstName;
    lastName = widget.lastName;
    email = widget.email;
    password = widget.password;
    gender = widget.gender;
    preference = widget.preference;
    birthdate = widget.birthdate;
    profilePicture = widget.profilePicture;
    userInterestIdList = widget.userInterestIdList;
  }

  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final logger = Logger();
  final LocationService _locationService = LocationService();

  Position? userLocation;
  bool userLocationDefined = false;
  late String? firstName;
  late String? lastName;
  late String? email;
  late String? password;
  late String? gender;
  late String? preference;
  late String? birthdate;
  Uint8List? profilePicture;
  late Set<int> userInterestIdList;

  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await requestLocationPermission();
    } else {
      saveCurrentLocation();
    }
  }

  Future<void> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      saveCurrentLocation();
    } else {
      logger.e("Location permission is denied.");
    }
  }

  Future<void> saveCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      userLocation = position;
      userLocationDefined = true;

      var location = await _locationService.getCurrentLocation(
          position.latitude, position.longitude);
      logger.i("Current user location: $location");
    } catch (e) {
      logger.e("Error getting current location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _customLoveTheme.neutralColor,
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: CustomScrollView(
              scrollBehavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: <Widget>[
                      const PageTitle(
                        title: "Profile Location",
                        description: "Please specify your current location and matching radius",
                        bottomPadding: 70.0,
                      ),
                      Stack(
                        children: [
                          Icon(Icons.map, size: 150, color: _customLoveTheme.textColor),
                          Positioned(
                            bottom: 0,
                            right: -10,
                            child: userLocation == null ?
                              Icon(Icons.close, size: 80, color: Colors.red) :
                              Icon(Icons.check, size: 80, color: _customLoveTheme.androidGreen)
                            ,
                          )
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      Text(
                        userLocation != null ?
                        'Your location is specified' :
                        'Allow access to your location on your device, so we can suggest suitable matches',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _customLoveTheme.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      if (userLocation == null)
                        requestLocationButton(context),
                      Expanded(child: Container()),
                      Center(
                        child: Row(
                          children: [
                            prevBtn(context),
                            const Spacer(),
                            nextBtn(context),
                            const SizedBox(height: 80),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )

    );

  }

  OutlinedButton requestLocationButton(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          minimumSize: const Size(156, 56),
          backgroundColor: _customLoveTheme.androidGreen,
          side: BorderSide.none
      ),
      onPressed: () {
        setState(() {
          requestLocationPermission();
        });
        },
      child: const Text(
        "Request Location Access",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
      ),
    );
  }

  OutlinedButton prevBtn(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          minimumSize: const Size(156, 56),
          backgroundColor: _customLoveTheme.primaryColor,
          side: BorderSide.none
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return LoginPage(
            loginService: Provider.of<LoginService>(context),
            userService: Provider.of<UserService>(context),
          );
        }));
      },
      child: const Text(
        "Return",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
      ),
    );
  }

  OutlinedButton nextBtn(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          minimumSize: const Size(156, 56),
          backgroundColor: _customLoveTheme.primaryColor,
          side: BorderSide.none
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return RegistrationNameEmail(
              firstName: firstName,
              lastName: lastName,
              email: email,
              password: password,
              gender: gender,
              preference: preference,
              birthdate: birthdate,
              profilePicture: profilePicture,
              userInterestIdList: userInterestIdList
          );
        }));
      },
      child: const Text(
        "Next",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
      ),
    );
  }
}
