import 'package:flutter/material.dart';
import 'package:frontend/src/app/model/user_model.dart';
import 'package:frontend/src/app/presentation/authentification/components/sign_in_button.dart';
import 'package:frontend/src/app/service/user_service.dart';

import '../../../../config/theme.dart';
import '../../authentification/controller/login_controller.dart';
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

  void getUsers() async {
    await _loginController.retrieveUserId().then((id) {
      widget.userService.getUser(id).then((value) {
        setState(() {
          user = value;
        });
      });
    });
  }

  final LoginController _loginController = LoginController();
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final LoginController _logoutController = LoginController();
  User? user;

  @override
  Widget build(BuildContext context) {
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
                      // registration_name_email
                        Column(children: [
                          SummaryTextfield(label: "First name", input: user!.firstName),
                          SummaryTextfield(label: "Last name", input: user!.lastName),
                          SummaryTextfield(label: "Email", input: user!.email),

                          // registration_gender_preference
                          SummaryTextfield(label: "Gender Identity", input: user!.gender_identity_id.toString()),
                          SummaryTextfield(label: "Gender Preference", input: "TODO"),
                          SummaryTextfield(label: "Birthdate", input: user!.date_of_birth.substring(0, 10)),

                          // registration_radius
                          SummaryTextfield(label: "Search Radius", input: "${user!.search_radius} km / ${(user!.search_radius * 0.621371).roundToDouble()} mi"),

                          SummaryTextfield(label: "Interests", input: "TODO"),

                          // registration_job_bio
                          SummaryTextfield(label: "Job", input: user!.job),
                          SummaryTextfield(label: "Bio", input: user!.bio),
                          
                          LoginButton(
                            onTap: () {
                              Future<void>.value(_logoutController.handleLogout(context));
                              },
                            color: _customLoveTheme.redColor,
                            text: "Logout"
                          )
                        ]),
                      const SizedBox(height: 25.0),
                      Expanded(child: Container()),
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
