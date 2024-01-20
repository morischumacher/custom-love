import 'package:flutter/material.dart';
import 'package:frontend/src/app/model/user_detailed.dart';
import 'package:frontend/src/app/presentation/authentification/components/sign_in_button.dart';
import 'package:frontend/src/app/service/user_service.dart';
import 'package:provider/provider.dart';

import '../../../../config/app_state.dart';
import '../../../../config/theme.dart';
import '../../../service/image_service.dart';
import '../../authentification/controller/login_controller.dart';
import '../../registration/controller/registration_controller.dart';
import '../../registration/pages/widgets/summary_textfield.dart';

class Profile extends StatefulWidget {
  final UserService userService;

  const Profile({Key? key, required this.userService}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    getUsers();
  }

  ImageService? _service;
  ImageStorage? _storage;
  final LoginController _logoutController = LoginController();

  Future<void> getProfilePicture() async {
    if (user != null) {
      if (_service == null ||
          _storage == null ||
          _storage!.loaded(user!.profilePictureId)) {
        return;
      }

      String route = "profile-picture/${user!.profilePictureId}";
      var tmp = await _service!.getImage(route);
      _storage!.load(user!.profilePictureId, tmp);
    }
  }

  void getUsers() async {
    await _loginController.retrieveUserId().then((id) {
      widget.userService.getUserProfile(int.parse(id!)).then((value) {
        setState(() {
          user = value;
        });
      });
    });
  }

  final LoginController _loginController = LoginController();
  final RegistrationController _controller = RegistrationController();
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  UserDetailed? user;

  @override
  Widget build(BuildContext context) {
    _service = Provider.of<ImageService>(context);
    _storage = Provider.of<ImageStorage>(context);
    getProfilePicture();

    Consumer<ImageStorage> img = Consumer<ImageStorage>(
      builder: (BuildContext context, ImageStorage storage, Widget? child) {
        int id = user!.profilePictureId;

        if (!storage.loaded(id)) {
          return const Icon(Icons.downloading);
        }

        return ClipRRect(
            borderRadius:
                BorderRadius.circular(_customLoveTheme.universalPadding),
            child: Image.memory(storage.getBytes(id)!));
      },
    );

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 0, 25, 0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: CustomScrollView(
              scrollBehavior:
              ScrollConfiguration.of(context).copyWith(scrollbars: false),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: <Widget>[
                      Expanded(child: Container()),
                      if (user == null)
                        SizedBox(
                            height: 100,
                            width: 100,
                            child: CircularProgressIndicator(
                                color: _customLoveTheme.primaryColor,
                                strokeWidth: 18
                            )
                        ),
                      if (user != null)
                        img,

                      if (user != null)
                      // registration_name_email
                        Column(children: [
                          SummaryTextfield(label: "First name", input: user!.firstName),
                          SummaryTextfield(label: "Last name", input: user!.lastName),
                          SummaryTextfield(label: "Email", input: user!.email),

                          // registration_gender_preference
                          SummaryTextfield(label: "Gender Identity", input: user!.genderIdentity.name),
                          SummaryTextfield(label: "Gender Preference", input: _controller.genderListToString(user!.genderPreferences)),
                          SummaryTextfield(label: "Birthdate", input: user!.dateOfBirth.substring(0, 10)),

                          // registration_radius
                          SummaryTextfield(label: "Search Radius", input: "${user!.searchRadius} km / ${(user!.searchRadius * 0.621371).roundToDouble()} mi"),

                          SummaryTextfield(label: "Interests", input: _controller.interestsListToString(user!.interests)),
                          SummaryTextfield(label: "Languages", input: _controller.languageListToString(user!.languages)),

                          // registration_job_bio
                          SummaryTextfield(label: "Job", input: user!.job),
                          SummaryTextfield(label: "Bio", input: user!.bio),
                          SummaryTextfield(label: "Search Radius", input: user!.searchRadius.toString()),
                          SummaryTextfield(label: "Swipes left", input: user!.swipesLeft.toString())
                        ]),
                      const SizedBox(height: 25.0),
                      Expanded(child: Container()),
                      LoginButton(
                          onTap: () {
                            Future<void>.value(_logoutController.handleLogout(context));
                          },
                          color: _customLoveTheme.primaryColor,
                          text: "Logout"
                      ),
                      const SizedBox(height: 30.0)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
