import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_arc_text/flutter_arc_text.dart';
import 'package:frontend/src/app/model/user_model.dart';
import 'package:frontend/src/app/presentation/swipe/util/swipe_state_notifier.dart';
import 'package:frontend/src/app/presentation/swipe/util/swipe_state.dart';
import 'package:frontend/src/app/presentation/swipe/util/matching_algorithm.dart';
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
import '../util/algo_id_notifier.dart';
import '../util/interests.dart';
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
  bool _didChangeDependenciesCalled = false;
  bool _swipeItemLoaded = false;
  //bool _initCompleted = false;
  bool _listenerAdded = false;

  late double height;
  late double width;

  @override
  void initState() {
    super.initState();

    _swipeableSubscription ??= SharedSwipeableEvent.swipeable.swipeableChanged
        .listen((bool gib) async {
      if (mounted) {
        setState(() {
          swipeable = gib;
          // build(context);
        });
      }
    });

    _fetchInitData();

  }



  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    print("didChangeDependencies called");

    if(!_didChangeDependenciesCalled) {
      _didChangeDependenciesCalled = true;

      swipeStateNotifier ??= Provider.of<SwipeStateNotifier>(context);
      print("swipeStatNotifier set");

      algoIdNotifier ??= Provider.of<AlgoIdNotifier>(context);
      print("algoIdNotifier set");

      if (!_listenerAdded) {
        swipeStateNotifier?.addListener(_swipeStateListener);
        algoIdNotifier?.addListener(_algoIdListener);
        _listenerAdded = true;
      }

      // 10 sec timer
      if (mounted) {
        setState(() {
          swipeableTimer = false;
        });
      }

      swiped = false;

      timer = Timer(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            swipeableTimer = true;
          });
        }
      });

     /* if (swipingAlgoId != algoIdNotifier?.algoId || loginAlgoIsSet) {


        print("SwipingAlgoId "+swipingAlgoId.toString());
        print("LoginAlgoIsSet "+loginAlgoIsSet.toString());

        swipingAlgoId = algoIdNotifier!.algoId;
        _loadNextUser();

      }
*/
    }

  }

  Future<void> _algoIdListener() async {
    print("listened to algoIdNotifier");

    print("algoIdNotifier "+algoIdNotifier!.algoId.toString());
    print("swipingAlgoId "+swipingAlgoId.toString());

    if(swipingAlgoId != algoIdNotifier!.algoId && swipeStateNotifier!.swipeState == SwipeState.OKAY) {
      swipingAlgoId = algoIdNotifier!.algoId;
      String accessToken = await _controller.retrieveAccessToken() as String;
      if (!context.mounted) return;
      await MatchingAlgorithm.updateMatchingAlgorithm(accessToken, context.read<UserService>(), swipingAlgoId);
    }

    if (mounted) {
      setState(() {
        if(swipeStateNotifier!.swipeState == SwipeState.OKAY) {
          _loadNextUser();
        } else {
          _swipeItemLoaded = true;
        }
      });
    }
  }

  void _swipeStateListener() {
    print("listened to swipeStateNotifier");
    if (mounted) {
      setState(() {

        if(swipeStateNotifier!.swipeState == SwipeState.OKAY) {
          _loadNextUser();
        } else {
          _swipeItemLoaded = true;
        }

        build(context);
      });
    }
  }

  Widget getSwipeCard() {
    SwipeState state = swipeStateNotifier!.swipeState;

    return SafeArea(
      child: Container(
          alignment: Alignment.center,
          height: height - kToolbarHeight > 0 ? height - kToolbarHeight : height,
          width: !kIsWeb ? width * 0.90 : width * 0.65,
          child: Stack(
              children: [getSwipeCardSwitch(state)])),
    );
  }

  Widget getSwipeCardSwitch(state) {
    switch (state) {
      case SwipeState.OKAY:
        return suggestionSwipeCard();
      case SwipeState.NO_SWIPES_LEFT:
      case SwipeState.NO_SURROUNDING_USER:
        return noSwipesLeftCard();
      default:
        return Center(child: Container());
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = min(MediaQuery.of(context).size.width, 750);
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: _customLoveTheme.neutralColor,
        body: Center(
            child:  _swipeItemLoaded ? getSwipeCard(): Center(child: CircularProgressIndicator(color: _customLoveTheme.primaryColor))
        ));
  }

  Future<void> _fetchInitData() async {
    print("fetchInitData called");
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getUserId();
      await _getMatchingAlgorithm();
      await _checkSwipesLeft(false);
    });
  }

  Future<int> _checkSwipesLeft(bool userCardShown) async {
    tmpSwipesLeft = await SwipesLeft.getCurrentSwipesLeft(
        userId, widget.userService);
    if (tmpSwipesLeft > 0) {
      //after reset_date is updated, it's possible to swipe again
     /* if (userCardShown) {
        setState(() {
          swipeableTimer = true;
        });
      }*/
      SharedSwipeableEvent.swipeable.changeSwipeable(true);
      swipeStateNotifier?.setSwipeState(SwipeState.OKAY);
    } else {
      SharedSwipeableEvent.swipeable.changeSwipeable(false);
      swipeStateNotifier?.setSwipeState(SwipeState.NO_SWIPES_LEFT);
    }
    return tmpSwipesLeft;
  }

  Future<void> _getUserId() async {
    var userIdString = await _controller.retrieveUserId() as String;
    userId = int.parse(userIdString);
  }

  Future<void> _getMatchingAlgorithm() async {
    await MatchingAlgorithm.getCurrentMatchingAlgorithm(userId, widget.userService).then((matchingAlgorithm){
      if (matchingAlgorithm != swipingAlgoId) {
        swipingAlgoId = matchingAlgorithm;
        algoIdNotifier?.setAlgoId(swipingAlgoId);
        loginAlgoIsSet = true;
      }
    });
  }

  void _loadNextUser() async {
    if (isLoading) return;

    if (mounted) {
      setState(() {
        _swipeItemLoaded = false;
        isLoading = true;
      });
    }
    print("Before accessToken");
    String accessToken = await _controller.retrieveAccessToken() as String;
    print("After accessToken "+accessToken);
    await widget.userService
        .getAlgoUser(accessToken, swipingAlgoId)
        .then((User? user) async {
      print("Username: "+user!.firstName);
      var city = await _locationService.getCurrentLocation(
          user!.latitude, user.longitude);
      _setUserSwipingCard(user, city);

    }).whenComplete(() {
      //  isLoading = false;
      if (mounted) {
        setState(() {
          isLoading = false;
          _swipeItemLoaded = true;
          build(context);
        });
      }
    });
  }

  void _setUserSwipingCard(User? user, String? city) {
    if (user == null) {
      if (mounted) {
        setState(() {
          _swipeItem = SwipeItem(
            content: const Text("There's no user to show"),
          );
          build(context);
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _swipeItem = SwipeItem(
            content: _getSuggestedUserInfo(user, city!),
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
          build(context);
        }
        );
      }
    }
  }

  _onSlideUpdate(SlideRegion? region) async {
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

  void _swipeActionTaken(bool hasLiked) async {
    String accessToken = await _controller.retrieveAccessToken() as String;
    int tmpSwipesLeft = await _checkSwipesLeft(true);
    if (hasLiked) {
      await widget.swipeStatusService.postLike(accessToken, int.parse(_swipeItem.content.id));
    } else {
      await widget.swipeStatusService.postView(accessToken, int.parse(_swipeItem.content.id));
    }
    _didChangeDependenciesCalled = false;
    if(tmpSwipesLeft != 0){
      _loadNextUser();
    } else {
      setState(() {});
    }

  }

  Content _getSuggestedUserInfo(User user, String city) {
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

  Widget noSwipesLeftCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.hardEdge,
      child: SwipeCards(
        matchEngine: _matchEngine = MatchEngine(swipeItems: [
          SwipeItem(
              content: "Sorry - No Swipes Left  :(",
              onSlideUpdate: (SlideRegion? region) async {
                _onSlideUpdate(region);
              }),
        ]),
        itemBuilder: (BuildContext context, int index) {
          return Container(
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
              color: _customLoveTheme.neutralBackgroundColor,
              child: ClipRect(
                child: SingleChildScrollView(
                  child: Stack(
                      children: [
                        SizedBox(height: height * 0.08),
                        const FittedBox(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 190, vertical: 190),
                            child: ArcText(
                              radius: 100,
                              text: "Sorry - No Swipes Left  :(",
                              textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              startAngle: 0,
                              stretchAngle: 3,
                              startAngleAlignment: StartAngleAlignment.center,
                              placement: Placement.middle,
                              direction: Direction.clockwise,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 120 : 105, vertical: kIsWeb ? 120 : 105),
                          child: Stack(
                            children: [
                              Icon(Icons.amp_stories_rounded, size: 150, color: _customLoveTheme.textColor),
                              Container(padding: const EdgeInsets.only(left: 52, top: 50), child: Icon(Icons.lock_clock_rounded, size: 45, color: _customLoveTheme.primaryColor)),
                            ],
                          ),
                        )
                      ]
                  ),
                ),
              )
          );
        },
        onStackFinished: () async {
          swipeStateNotifier!.setSwipeState(SwipeState.OKAY);
        },
        leftSwipeAllowed: swipeable,
        rightSwipeAllowed: swipeable,
        fillSpace: true,
      ),
    );
  }

/*  Widget noSwipesLeftCardStatic() {
    final height = MediaQuery.of(context).size.height;
    final width = min(MediaQuery.of(context).size.width, 750);

    final swipeCardHeight = height - kToolbarHeight > 0 ? height - kToolbarHeight : height;
    final swipeCardWidth = !kIsWeb ? width * 0.90 : width * 0.65;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.hardEdge,
      child: Container(
          height: swipeCardHeight,
          width: swipeCardWidth,
          alignment: Alignment.center,
          color: _customLoveTheme.neutralBackgroundColor,
          child: ClipRect(
            child: SingleChildScrollView(
              child: Stack(
                  children: [
                    SizedBox(height: height * 0.08),
                    const FittedBox(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 190, vertical: 190),
                        child: ArcText(
                          radius: 100,
                          text: "Sorry - No Swipes Left  :(",
                          textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          startAngle: 0,
                          stretchAngle: 3,
                          startAngleAlignment: StartAngleAlignment.center,
                          placement: Placement.middle,
                          direction: Direction.clockwise,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 120 : 105, vertical: kIsWeb ? 120 : 105),
                      child: Stack(
                        children: [
                          Icon(Icons.amp_stories_rounded, size: 150, color: _customLoveTheme.textColor),
                          Container(padding: const EdgeInsets.only(left: 52, top: 50), child: Icon(Icons.lock_clock_rounded, size: 45, color: _customLoveTheme.primaryColor)),
                        ],
                      ),
                    )
                  ]
              ),
            ),
          )
      ),
    );
  }*/

  Widget suggestionSwipeCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.hardEdge,
      child: SwipeCards(
        matchEngine: _matchEngine!,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
              color: _customLoveTheme.neutralBackgroundColor,
              child: ClipRect(
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.08),
                        FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 50 : 40),
                            child: Text(
                              _swipeItem.content.firstName,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 50 : 40),
                                child: Text(
                                  "Age: ${_swipeItem.content.age}",
                                  style: const TextStyle(fontSize: kIsWeb ? 16 : 14, fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(width: kIsWeb ? width * 0.20 : width * 0.15),
                              locationWidget(_swipeItem.content.city),
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 50 : 40),
                          child: FittedBox(
                            child: Wrap(
                              spacing: 25,
                              runSpacing: 4,
                              children: _swipeItem.content.interests.length > 0 ? List<Widget>.generate(_swipeItem.content.interests.length,
                                    (int i) {
                                  Icon avatar = Interests.getIcon(_swipeItem.content.interests[i]["name"]);
                                  return ActionChip(
                                    side: BorderSide(width: 1.5, color: _customLoveTheme.primaryColor),
                                    avatar: avatar,
                                    label: Text(_swipeItem.content.interests[i]["name"]),
                                    onPressed: () {},
                                  );
                                },
                              ) : [Container()],
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            //for small bio card
                            height: height - height * 0.6,
                            width: !kIsWeb ? width * 0.70 : width * 0.53,
                            margin: const EdgeInsets.symmetric(vertical: kIsWeb ? 50 : 30, horizontal: 35),
                            decoration: BoxDecoration(
                              color: _customLoveTheme.neutralBackgroundColor,
                              boxShadow: [
                                BoxShadow(
                                  color: _customLoveTheme.textColor.withOpacity(0.3),
                                  spreadRadius: 3,
                                  blurRadius: 10,
                                  offset: const Offset(0, 3), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                    _swipeItem.content.bio,
                                    style: const TextStyle(fontSize: kIsWeb ? 16 : 14),
                                    textAlign: TextAlign.left
                                )
                            ),
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            heightFactor: !kIsWeb ? 0.85 : 1,
                            child: FittedBox(
                              child: buttonWidget(context, height, width),
                            )
                        )
                      ]
                  ),
                ),
              )
          );
        },
        onStackFinished: () async {
          _updateSwipesLeft(false, false);
        },
        itemChanged: (SwipeItem item, int index) {},
        leftSwipeAllowed: swipeableTimer ? swipeable : false,
        rightSwipeAllowed: swipeableTimer ? swipeable : false,
        fillSpace: true,
        likeTag: getTag("Like"),
        nopeTag: getTag("Dislike"),
      ),
    );
  }

  Widget getTag(String tagString) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _customLoveTheme.primaryColor)
      ),
      child: Text(tagString),
    );
  }

  Widget locationWidget(city) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [const Icon(Icons.location_on, size: 18),
        Text(
          "Location: $city",
          style: const TextStyle(fontSize: kIsWeb ? 16 : 14, fontWeight: FontWeight.bold),
        )],);
  }

  Widget buttonWidget(context, height, width) {
    final buttonHeight =  kIsWeb ? height * 0.037 : height * 0.022;
    final buttonWidth = kIsWeb ? width * 0.046 : width * 0.055;
    double buttonSize = kIsWeb ? 40 : 32;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
            onPressed: () async {
              if(swipeableTimer) {
                int tmpSwipesLeft = await SwipesLeft.getCurrentSwipesLeft(userId, widget.userService);
                if(tmpSwipesLeft > 0) {
                  _updateSwipesLeft(true, false);
                } else {
                  swipeStateNotifier!.setSwipeState(SwipeState.NO_SWIPES_LEFT);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: buttonHeight, horizontal: buttonWidth),
              backgroundColor: _customLoveTheme.primaryColor,
            ),
            child: Icon(Icons.close, size: buttonSize, color: _customLoveTheme.textColor)),
        SizedBox(width: width * 0.1),
        ElevatedButton(
            onPressed: () async {
              if(swipeableTimer) {
                int tmpSwipesLeft = await SwipesLeft.getCurrentSwipesLeft(userId, widget.userService);
                if(tmpSwipesLeft > 0) {
                  _updateSwipesLeft(true, true);
                } else {
                  swipeStateNotifier!.setSwipeState(SwipeState.NO_SWIPES_LEFT);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: buttonHeight, horizontal: buttonWidth),
              backgroundColor: _customLoveTheme.primaryColor,
            ),
            child: Icon(Icons.favorite_outline, size: buttonSize, color: _customLoveTheme.textColor)),
      ],
    );
  }

  Future<void> _updateSwipesLeft(bool swipedViaButton, bool hasLiked) async {
    if (swipedViaButton) {
      if (hasLiked) {
        _matchEngine!.currentItem?.like();
      } else {
        _matchEngine!.currentItem?.nope();
      }
    }
    String accessToken = await _controller.retrieveAccessToken() as String;
    int tmpSwipesLeft = await SwipesLeft.updateSwipeLeft(accessToken, widget.userService);
    if (tmpSwipesLeft > 0) {
      swipeStateNotifier!.setSwipeState(SwipeState.OKAY);
    } else {
      SharedSwipeableEvent.swipeable.changeSwipeable(false);
      swipeStateNotifier!.setSwipeState(SwipeState.NO_SWIPES_LEFT);
    }
  }

  @override
  void dispose() {
    print("remove to swipeStateNotifier");
    swipeStateNotifier?.removeListener(_swipeStateListener);
    algoIdNotifier?.removeListener(_algoIdListener);

    timer?.cancel();

    _swipeableSubscription?.cancel();

    super.dispose();
  }

}
