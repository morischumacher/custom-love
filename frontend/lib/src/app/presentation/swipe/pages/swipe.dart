import 'dart:async';

import 'package:frontend/src/app/model/user_model.dart';
import 'package:frontend/src/app/presentation/swipe/util/content.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/swipe/util/shared_swipeable_event.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:frontend/src/config/theme.dart';
import 'package:frontend/src/app/presentation/authentification/controller/login_controller.dart';

import '../../../service/user_service.dart';
import '../components/swiping_card.dart';
import '../util/shared_algorithm_event.dart';
import '../util/swipes_left.dart';


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
  late bool swiped;
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final LoginController _controller = LoginController();
  late Timer timer;
  bool swipeableTimer = true;
  late int tmpSwipesLeft;
  late int userId;
  bool swipesEvent = false;

  final List<Content> _cards = [
    Content(firstName: "Bravo", languages: ["english", "french"], bio: "hello,...", interests: ["sport", "reading", "movies", "IT"])];


  @override
  void initState() {
    super.initState();

    _fetchInitData();

    SharedAlgorithmEvent.algoId.algoIdChanged.listen((int algoId) {
      print("current algoID: $algoId");
    });

    SharedSwipeableEvent.swipeable.swipeableChanged.listen((bool swipeable) async {
      print("current swipeable: $swipeable");
      setState(() {
        swipesEvent = swipeable;
      });
    });

    _loadNextUser();
  }

  void _fetchInitData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getUserId();
    });
  }

  Future<void> _getUserId() async {
    var userIdString = await _controller.retrieveUserId() as String;
    userId = int.parse(userIdString);
  }

  void _loadNextUser() async {
    setState(() {
      isLoading = true;
    });

    int swipingAlgoId = await SharedAlgorithmEvent.algoId.getAlgoId();

    if (swipingAlgoId == 0) {
       print("No special swiping algorithm is used");
       await widget.userService.getUser(1).then((User? user) {
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
          swipeableTimer = false;
        });

        swiped = false;

        timer = Timer(const Duration(seconds: 10), () {
          setState(() {
            swipeableTimer = true;
          });
        });

        _swipeItem = SwipeItem(
          content: Content(firstName: firstName, age: age, languages: _cards
              .elementAt(0)
              .languages, bio: user.bio, interests: _cards
              .elementAt(0)
              .interests),
          likeAction: () {
              _loadNextUser();
          },
          nopeAction: () {
              _loadNextUser();
          },
          onSlideUpdate: (SlideRegion? region) async {
            //check if it's possible to swipe (10 sec timer)
            if (swipeableTimer) {
              //ignore the swipe left check if the card is just be tapped
              if (region != null) {
                //ensure that after a swipe attempt the api call happens only once
                if (!swiped) {
                  swiped = true;
                  tmpSwipesLeft = await SwipesLeft.getCurrentSwipesLeft(userId, widget.userService);
                  if(tmpSwipesLeft > 0) {
                    //after reset_date is updated, it's possible to swipe again
                    setState(() {
                      swipeableTimer = true;
                    });
                    SharedSwipeableEvent.swipeable.changeSwipeable(true);

                  } else {
                    SharedSwipeableEvent.swipeable.changeSwipeable(false);
                  }
                }
              }

              //when swipe card is in the initial state (null position), it should be possible to make the api call
              if (region == null) {
                swiped = false;
              }
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
          child: SwipingCard(matchEngine: _matchEngine, customLoveTheme: _customLoveTheme, swipeItem: _swipeItem, swipeable: swipesEvent, swipeableTimer: swipeableTimer, userId: userId, controller: _controller, userService: widget.userService),
        )
    );
  }

  @override
  void dispose() {
    if(timer.isActive) {
      timer.cancel();
    }
    SharedAlgorithmEvent().dispose();
    SharedSwipeableEvent().dispose();
    super.dispose();
  }

}
