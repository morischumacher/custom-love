import 'dart:async';

import 'package:frontend/src/app/model/user_model.dart';
import 'package:frontend/src/app/presentation/swipe/util/content.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:frontend/src/config/theme.dart';
import 'package:frontend/src/app/presentation/authentification/controller/login_controller.dart';

import '../../../service/user_service.dart';
import '../components/swiping_card.dart';
import '../util/shared_algorithm_event.dart';


class Swipe extends StatefulWidget {
  final UserService userService;

  const Swipe({Key? key, required this.userService}) : super(key: key);


  @override
  _SwipeState createState() => _SwipeState();
}

class _SwipeState extends State<Swipe> {
  late SwipeItem _swipeItem;
  MatchEngine? _matchEngine;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool isLoading = false;
  bool swipeable = true;
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final LoginController _controller = LoginController();
  late Timer timer;

  final List<Content> _cards = [
    Content(firstName: "Bravo", languages: ["english", "french"], bio: "hello,...", interests: ["sport", "reading", "movies", "IT"])];

  @override
  void initState() {
    super.initState();

    SharedAlgorithmEvent.algoId.algoIdChanged.listen((int algoId) {
      print("current algoID: $algoId");
    });

    _loadNextUser();
  }

  void _loadNextUser() async {
    setState(() {
      isLoading = true;
    });

    int swipingAlgoId = await SharedAlgorithmEvent.algoId.getAlgoId();

    if (swipingAlgoId == 0) {
       print("No special swiping algorithm is used");
       await widget.userService.getUser().then((User? user) {
         _setSwipingCard(user);
       }).whenComplete(() {
         isLoading = false;
       });
    } else if (swipingAlgoId == 1) {
       print("Random swiping algorithm is used");
       String accessToken = await _controller.retrieveAccessToken() as String;
       print("AccessToken from user logged in: $accessToken");
       await widget.userService.getAlgoUser(accessToken).then((User? user) {
         _setSwipingCard(user);
       }).whenComplete(() {
         isLoading = false;
       });
    }

  }

  void _setSwipingCard(User? user) {
    if (user == null) {
      setState(() {
        _swipeItem = SwipeItem(
          content: const Text("There's no user to show"),
        );
      });
    } else {
      setState(() {
        var firstName = user.firstName;
        var birthDate = DateTime.parse(user.date_of_birth);
        var birthYear = birthDate.year;
        var todayDate = DateTime.now();

        int age = todayDate.year - birthYear;

        if (birthDate.month > todayDate.month || (birthDate.month == todayDate.month && birthDate.day > todayDate.day)) {
          age--;
        }

        setState(() {
          swipeable = false;
        });

        timer = Timer(const Duration(seconds: 10), () {
          setState(() {
            swipeable = true;
          });
        });

        _swipeItem = SwipeItem(
          content: Content(firstName: firstName, age: age, languages: _cards
              .elementAt(0)
              .languages, bio: user.bio, interests: _cards
              .elementAt(0)
              .interests),
          likeAction: () {
            if (swipeable) {
              _loadNextUser();
            }
          },
          nopeAction: () {
            if (swipeable) {
              _loadNextUser();
            }
          },
        );
        _matchEngine = MatchEngine(swipeItems: [_swipeItem]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: _customLoveTheme.neutralColor,
        body: isLoading
          ? const Center(
            child: CircularProgressIndicator(),
          ):
            Center(
              child: SwipingCard(matchEngine: _matchEngine, customLoveTheme: _customLoveTheme, swipeItem: _swipeItem, swipeable: swipeable),
            )
    );
  }

  @override
  void dispose() {
    if(timer.isActive) {
      timer.cancel();
    }
    super.dispose();
  }
}
