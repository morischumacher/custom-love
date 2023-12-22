import 'dart:async';

import 'package:frontend/src/app/model/user_model.dart';
import 'package:frontend/src/app/presentation/swipe/util/swipe_status.dart';
import 'package:frontend/src/app/presentation/swipe/util/content.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/swipe/util/shared_swipeable_event.dart';
import 'package:frontend/src/app/service/swipe_status_service.dart';
import 'package:provider/provider.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:frontend/src/config/theme.dart';
import 'package:frontend/src/app/presentation/authentification/controller/login_controller.dart';

import '../../../service/location_service.dart';
import '../../../service/user_service.dart';
import '../components/swiping_card.dart';
import '../util/algo_id_notifier.dart';
import '../util/swipes_left.dart';

class Swipe extends StatefulWidget {
  final UserService userService;
  final SwipeStatusService swipeStatusService;

  const Swipe({Key? key, required this.userService, required this.swipeStatusService}) : super(key: key);

  @override
  _SwipeState createState() => _SwipeState();

}

class _SwipeState extends State<Swipe>{
  late SwipeItem _swipeItem;
  MatchEngine? _matchEngine;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool isLoading = false;
  bool swipeable = true;
  late bool swiped;
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final LoginController _controller = LoginController();
  final LocationService _locationService = LocationService();
  Timer? timer;
  bool swipeableTimer = true;
  late int tmpSwipesLeft;
  late int userId;
  bool swipesEvent = false;
  int swipingAlgoId = 0;
  StreamSubscription<bool>? _swipeableSubscription;

  @override
  void initState() {
    super.initState();

    _fetchInitData();

    print("init");

    _swipeableSubscription = SharedSwipeableEvent.swipeable.swipeableChanged
        .listen((bool swipeable) async {
      if (mounted) {
        setState(() {
          swipesEvent = swipeable;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final algoIdNotifier = Provider.of<AlgoIdNotifier>(context);
    if (swipingAlgoId != algoIdNotifier.algoId) {
      swipingAlgoId = algoIdNotifier.algoId;
      _loadNextUser();
    }
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
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    print("algo id: $swipingAlgoId");

    String accessToken = await _controller.retrieveAccessToken() as String;
    await widget.userService
        .getAlgoUser(accessToken, swipingAlgoId)
        .then((User? user) async {
      var city = await _locationService.getCurrentLocation(
          user!.latitude, user.longitude);
      _setSwipingCard(user, city);
    }).whenComplete(() {
      isLoading = false;
    });
  }

  void _setSwipingCard(User? user, String? city) {
    if (user == null) {
      if (mounted) {
        setState(() {
          _swipeItem = SwipeItem(
            content: const Text("There's no user to show"),
          );
        });
      }
    } else {
      if (mounted) {
        setState(() {
          var id = user.id;
          var firstName = user.firstName;
          List<dynamic>? interests = [];
          if (user.interests != null) {
            interests = user.interests;
          }
          var birthDate = DateTime.parse(user.date_of_birth);
          var birthYear = birthDate.year;
          var todayDate = DateTime.now();

          int age = todayDate.year - birthYear;

          if (birthDate.month > todayDate.month ||
              (birthDate.month == todayDate.month &&
                  birthDate.day > todayDate.day)) {
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
            content: Content(
                id: id.toString(),
                firstName: firstName,
                age: age,
                city: city,
                bio: user.bio,
                interests: interests),
            likeAction: () async {
              String accessToken = await _controller.retrieveAccessToken() as String;
              await SwipesLeft.updateSwipeLeft(accessToken, widget.userService);
              await widget.swipeStatusService.postLike(accessToken, int.parse(_swipeItem.content.id));
              _loadNextUser();
            },
            nopeAction: () async {
              String accessToken = await _controller.retrieveAccessToken() as String;
              await SwipesLeft.updateSwipeLeft(accessToken, widget.userService);
              await widget.swipeStatusService.postView(accessToken, int.parse(_swipeItem.content.id));
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
                    tmpSwipesLeft = await SwipesLeft.getCurrentSwipesLeft(
                        userId, widget.userService);
                    if (tmpSwipesLeft > 0) {
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
  }

  @override
  Widget build(BuildContext context) {
      return swipingAlgoId !=0 ? Scaffold(
        key: _scaffoldKey,
        backgroundColor: _customLoveTheme.neutralColor,
        body: isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        ):
        Center(
          child: SwipingCard(
              matchEngine: _matchEngine,
              customLoveTheme: _customLoveTheme,
              swipeItem: _swipeItem,
              swipeable: swipesEvent,
              swipeableTimer: swipeableTimer,
              userId: userId,
              controller: _controller,
              userService: widget.userService,
              swipeStatusService: widget.swipeStatusService),
        )) : const SizedBox();
  }

  @override
  void dispose() {
    if (timer != null) {
      if(timer!.isActive) {
        timer?.cancel();
      }
    }

    _swipeableSubscription?.cancel();

    super.dispose();
  }
}
