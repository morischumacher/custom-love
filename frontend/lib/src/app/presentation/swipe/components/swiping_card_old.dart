import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arc_text/flutter_arc_text.dart';
import 'package:frontend/src/app/presentation/swipe/util/swipe_state_notifier.dart';
import 'package:frontend/src/app/presentation/swipe/util/shared_swipeable_event.dart';
import 'package:frontend/src/app/presentation/swipe/util/swipe_state.dart';
import 'package:provider/provider.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:frontend/src/config/theme.dart';

import '../../../service/swipe_status_service.dart';
import '../util/swipe_status.dart';
import '../util/interests.dart';

import '../../../service/user_service.dart';
import '../../authentification/controller/login_controller.dart';
import '../util/swipes_left.dart';
import 'dart:math' as math;

class SwipingCard extends StatelessWidget {
  final LoginController controller;
  final UserService userService;
  final SwipeStatusService swipeStatusService;

  SwipingCard({
    super.key,
    required MatchEngine? matchEngine,
    required CustomLoveTheme customLoveTheme,
    required SwipeItem swipeItem,
    required this.swipeable, swipeableTimer, userId, required this.controller, required this.userService, required this.swipeStatusService, swipeStateNotifier
  })
      : _matchEngine = matchEngine,
        _customLoveTheme = customLoveTheme,
        _swipeItem = swipeItem,
        _swipeableTimer = swipeableTimer,
        _userId = userId,
        _swipeStateNotifier = swipeStateNotifier;

  final MatchEngine? _matchEngine;
  final CustomLoveTheme _customLoveTheme;
  final SwipeItem _swipeItem;
  bool swipeable = false;
  final bool _swipeableTimer;
  final int _userId;
  final SwipeStateNotifier _swipeStateNotifier;


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = min(MediaQuery.of(context).size.width, 750);
    return SafeArea(
      child: Container(
          alignment: Alignment.center,
          height: height - kToolbarHeight > 0 ? height - kToolbarHeight : height,
          width: !kIsWeb ? width * 0.90 : width * 0.65,
          child: Stack(
              children: [ _swipeStateNotifier.swipeState != SwipeState.OKAY ? noSwipesLeftCard(height, width) :
              suggestionSwipeCard(height, width)
              ])),
    );
  }

  Widget noSwipesLeftCard(height, width) {
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
          _swipeStateNotifier.setSwipeState(SwipeState.OKAY);
        },
        leftSwipeAllowed: swipeable,
        rightSwipeAllowed: swipeable,
        fillSpace: true,
      ),
    );
  }

  Widget suggestionSwipeCard(height, width) {
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
        leftSwipeAllowed: _swipeableTimer ? swipeable : false,
        rightSwipeAllowed: _swipeableTimer ? swipeable : false,
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
              if(_swipeableTimer) {
                int tmpSwipesLeft = await SwipesLeft.getCurrentSwipesLeft(_userId, userService);
                if(tmpSwipesLeft > 0) {
                  _updateSwipesLeft(true, false);
                } else {
                  _swipeStateNotifier.setSwipeState(SwipeState.NO_SWIPES_LEFT);
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
              if(_swipeableTimer) {
                int tmpSwipesLeft = await SwipesLeft.getCurrentSwipesLeft(_userId, userService);
                if(tmpSwipesLeft > 0) {
                  _updateSwipesLeft(true, true);
                } else {
                  _swipeStateNotifier.setSwipeState(SwipeState.NO_SWIPES_LEFT);
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
    String accessToken = await controller.retrieveAccessToken() as String;
    int tmpSwipesLeft = await SwipesLeft.updateSwipeLeft(accessToken, userService);
    if (tmpSwipesLeft > 0) {
      _swipeStateNotifier.setSwipeState(SwipeState.OKAY);
    } else {
      SharedSwipeableEvent.swipeable.changeSwipeable(false);
      _swipeStateNotifier.setSwipeState(SwipeState.NO_SWIPES_LEFT);
    }
  }

}
