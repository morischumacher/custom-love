import 'dart:async';

import 'package:frontend/src/app/model/user_model.dart';
import 'package:frontend/src/app/presentation/swipe/util/swipe_state_notifier.dart';
import 'package:frontend/src/app/presentation/swipe/util/swipe_state.dart';
import 'package:frontend/src/app/presentation/swipe/util/matching_algorithm.dart';
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
  SwipeStateNotifier? swipeStateNotifier;
  StreamSubscription<bool>? _swipeableSubscription;
  AlgoIdNotifier? algoIdNotifier;
  bool loginAlgoIsSet = false;

  @override
  void initState() {
    super.initState();

    _fetchInitData();
  }

    _swipeableSubscription ??= SharedSwipeableEvent.swipeable.swipeableChanged
        .listen((bool swipeable) async {
      if (mounted) {
        setState(() {
          swipesEvent = swipeable;
        });
      }
    });

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    swipeStateNotifier ??= Provider.of<SwipeStateNotifier>(context);

    algoIdNotifier ??= Provider.of<AlgoIdNotifier>(context);
    if (swipingAlgoId != algoIdNotifier?.algoId || loginAlgoIsSet) {
      swipingAlgoId = algoIdNotifier!.algoId;
      _loadNextUser();
      String accessToken = await _controller.retrieveAccessToken() as String;
      if (!context.mounted) return;
      await MatchingAlgorithm.updateMatchingAlgorithm(accessToken, context.read<UserService>(), swipingAlgoId);
    }

    // 10 sec timer
    if (mounted) {
      setState(() {
        swipeableTimer = false;
      });
    }

    swiped = false;

    timer = Timer(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          swipeableTimer = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return swipingAlgoId !=0 ? Scaffold(
        key: _scaffoldKey,
        backgroundColor: _customLoveTheme.neutralColor,
        body: isLoading
            ? Center(
          child: CircularProgressIndicator(color: _customLoveTheme.primaryColor),
        ):
        Center(
            child: getSwipeCard()
        )) : const SizedBox();
  }

  void _fetchInitData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getUserId();
      await _getMatchingAlgorithm();
      await _checkSwipesLeft(false);
    });
  }

  _checkSwipesLeft(bool userCardShown) async {
    tmpSwipesLeft = await SwipesLeft.getCurrentSwipesLeft(
        userId, widget.userService);
    if (tmpSwipesLeft > 0) {
      //after reset_date is updated, it's possible to swipe again
      if (userCardShown) {
        setState(() {
          swipeableTimer = true;
        });
      }
      SharedSwipeableEvent.swipeable.changeSwipeable(true);
      swipeStateNotifier?.setSwipeState(SwipeState.OKAY);
    } else {
      SharedSwipeableEvent.swipeable.changeSwipeable(false);
      swipeStateNotifier?.setSwipeState(SwipeState.NO_SWIPES_LEFT);
    }
  }

  Future<void> _getUserId() async {
    var userIdString = await _controller.retrieveUserId() as String;
    userId = int.parse(userIdString);
  }

  Future<void> _getMatchingAlgorithm() async {
    var matchingAlgorithm = await MatchingAlgorithm.getCurrentMatchingAlgorithm(userId, widget.userService);
    if (matchingAlgorithm != swipingAlgoId) {
      swipingAlgoId = matchingAlgorithm;
      algoIdNotifier?.setAlgoId(swipingAlgoId);
      loginAlgoIsSet = true;
    }
  }

  void _loadNextUser() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

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

  Future<void> _swipeActionTaken(bool hasLiked) async {
    String accessToken = await _controller.retrieveAccessToken() as String;
    int swipingsLeftInt = await SwipesLeft.updateSwipeLeft(accessToken, widget.userService);
    if (swipingsLeftInt > 0) {
      SharedSwipeableEvent.swipeable.changeSwipeable(true);
    } else {
      SharedSwipeableEvent.swipeable.changeSwipeable(false);
    }

    if (hasLiked) {
      await widget.swipeStatusService.postLike(accessToken, int.parse(_swipeItem.content.id));
    } else {
      await widget.swipeStatusService.postView(accessToken, int.parse(_swipeItem.content.id));
    }

    _loadNextUser();
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
          _swipeItem = SwipeItem(
            content: _getUserInfo(user, city!),
            likeAction: () async {
              _swipeActionTaken(true);
            },
            nopeAction: () async {
              _swipeActionTaken(false);
            },
            onSlideUpdate: (SlideRegion? region) async {
              _onSlideUpdate(region);
            },
          );
          _matchEngine = MatchEngine(swipeItems: [_swipeItem]);
        });
      }
    }
  }

  _onSlideUpdate(SlideRegion? region) async {
    //check if it's possible to swipe (10 sec timer)
    if (swipeableTimer) {
      //ignore the swipe left check if the card is just be tapped
      if (region != null) {
        //ensure that after a swipe attempt the api call happens only once
        if (!swiped) {
          swiped = true;
          await _checkSwipesLeft(true);
        }
      }

      //when swipe card is in the initial state (null position), it should be possible to make the api call
      if (region == null) {
        swiped = false;
      }
    }
  }

  void _swipeActionTaken(bool hasLiked) async {
    _loadNextUser();
    String accessToken = await _controller.retrieveAccessToken() as String;
    if (hasLiked) {
      await widget.swipeStatusService.postLike(accessToken, int.parse(_swipeItem.content.id));
    } else {
      await widget.swipeStatusService.postView(accessToken, int.parse(_swipeItem.content.id));
    }
  }

  Content _getUserInfo(User user, String city) {
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

    return Content(
        id: id.toString(),
        firstName: firstName,
        age: age,
        city: city,
        bio: user.bio,
        interests: interests);
  }

  Widget getSwipeCard() {
    SwipeItem swipeItem;
    bool setSwipeable;

    switch(swipeStateNotifier!.swipeState) {
      case SwipeState.OKAY:
        swipeItem = _swipeItem;
        setSwipeable = swipesEvent;
      default:
        swipeItem = SwipeItem(content: "No swipes left  :(");
        setSwipeable = false;
    }

    return SwipingCard(
        matchEngine: _matchEngine,
        customLoveTheme: _customLoveTheme,
        swipeItem: swipeItem,
        swipeable: setSwipeable,
        swipeableTimer: swipeableTimer,
        userId: userId,
        controller: _controller,
        userService: widget.userService,
        swipeStatusService: widget.swipeStatusService,
        swipeStateNotifier: swipeStateNotifier);
  }

  @override
  void dispose() {
    timer?.cancel();

    _swipeableSubscription?.cancel();

    super.dispose();
  }

}
