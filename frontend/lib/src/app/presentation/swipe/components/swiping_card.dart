import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/swipe/util/shared_swipeable_event.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:frontend/src/config/theme.dart';

import '../../../service/swipe_status_service.dart';
import '../util/swipe_status.dart';
import '../util/interests.dart';

import '../../../service/user_service.dart';
import '../../authentification/controller/login_controller.dart';
import '../util/swipes_left.dart';

class SwipingCard extends StatelessWidget {
  final LoginController controller;
  final UserService userService;
  final SwipeStatusService swipeStatusService;

  SwipingCard(
      {super.key,
      required MatchEngine? matchEngine,
      required CustomLoveTheme customLoveTheme,
      required SwipeItem swipeItem,
      required this.swipeable,
      swipeableTimer,
      userId,
      required this.controller,
      required this.userService,
      required this.swipeStatusService})
      : _matchEngine = matchEngine,
        _customLoveTheme = customLoveTheme,
        _swipeItem = swipeItem,
        _swipeableTimer = swipeableTimer,
        _userId = userId;

  final MatchEngine? _matchEngine;
  final CustomLoveTheme _customLoveTheme;
  final SwipeItem _swipeItem;
  bool swipeable = false;
  final bool _swipeableTimer;
  final int _userId;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = min(MediaQuery.of(context).size.width, 750);

    return SafeArea(
      child: Container(
          alignment: Alignment.center,
          height:
              height - kToolbarHeight > 0 ? height - kToolbarHeight : height,
          width: !kIsWeb ? width * 0.90 : width * 0.65,
          child: Stack(children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: kIsWeb ? 50 : 40),
                                    child: Text(
                                      _swipeItem.content.firstName,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                SizedBox(height: height * 0.02),
                                FittedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: kIsWeb ? 50 : 40),
                                        child: Text(
                                          "Age: ${_swipeItem.content.age}",
                                          style: const TextStyle(
                                              fontSize: kIsWeb ? 16 : 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                          width: kIsWeb
                                              ? width * 0.20
                                              : width * 0.15),
                                      locationWidget(
                                          _swipeItem.content.city, 4),
                                    ],
                                  ),
                                ),
                                SizedBox(height: height * 0.02),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: kIsWeb ? 50 : 40),
                                  child: FittedBox(
                                    child: Wrap(
                                      spacing: 25,
                                      runSpacing: 4,
                                      children: _swipeItem
                                                  .content.interests.length >
                                              0
                                          ? List<Widget>.generate(
                                              _swipeItem
                                                  .content.interests.length,
                                              (int i) {
                                                Icon avatar = Interests.getIcon(
                                                    _swipeItem.content
                                                        .interests[i]["name"]);
                                                return ActionChip(
                                                  side: BorderSide(
                                                      width: 1.5,
                                                      color: _customLoveTheme
                                                          .primaryColor),
                                                  avatar: avatar,
                                                  label: Text(_swipeItem.content
                                                      .interests[i]["name"]),
                                                  onPressed: () {},
                                                );
                                              },
                                            )
                                          : [Container()],
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    //for small bio card
                                    height: height - height * 0.6,
                                    width:
                                        !kIsWeb ? width * 0.70 : width * 0.53,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: kIsWeb ? 50 : 30,
                                        horizontal: 35),
                                    decoration: BoxDecoration(
                                      color: _customLoveTheme
                                          .neutralBackgroundColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: _customLoveTheme.textColor
                                              .withOpacity(0.3),
                                          spreadRadius: 3,
                                          blurRadius: 10,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Text(_swipeItem.content.bio,
                                            style: const TextStyle(
                                                fontSize: kIsWeb ? 16 : 14),
                                            textAlign: TextAlign.left)),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    heightFactor: !kIsWeb ? 0.85 : 1,
                                    child: FittedBox(
                                      child:
                                          buttonWidget(context, height, width),
                                    ))
                              ]),
                        ),
                      ));
                },
                onStackFinished: () {},
                itemChanged: (SwipeItem item, int index) {},
                leftSwipeAllowed: _swipeableTimer ? swipeable : false,
                rightSwipeAllowed: _swipeableTimer ? swipeable : false,
                fillSpace: true,
                likeTag: Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _customLoveTheme.primaryColor)),
                  child: const Text('Like'),
                ),
                nopeTag: Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _customLoveTheme.primaryColor)),
                  child: const Text('Dislike'),
                ),
              ),
            ),
          ])),
    );
  }

  Widget locationWidget(city, double distance) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.location_on, size: 18),
            Text(
              "Location: $city",
              style: const TextStyle(
                  fontSize: kIsWeb ? 16 : 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.navigation, size: 18),
            Text(
              "Distance: $distance km",
              style: const TextStyle(
                  fontSize: kIsWeb ? 16 : 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget buttonWidget(context, height, width) {
    final buttonHeight = kIsWeb ? height * 0.037 : height * 0.022;
    final buttonWidth = kIsWeb ? width * 0.046 : width * 0.055;
    double buttonSize = kIsWeb ? 40 : 32;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
            onPressed: () async {
              if (_swipeableTimer) {
                int tmpSwipesLeft =
                    await SwipesLeft.getCurrentSwipesLeft(_userId, userService);
                if (tmpSwipesLeft > 0) {
                  _matchEngine!.currentItem?.nope();
                }
              }
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                  vertical: buttonHeight, horizontal: buttonWidth),
              backgroundColor: _customLoveTheme.primaryColor,
            ),
            child: Icon(Icons.close,
                size: buttonSize, color: _customLoveTheme.textColor)),
        SizedBox(width: width * 0.1),
        ElevatedButton(
            onPressed: () async {
              if (_swipeableTimer) {
                int tmpSwipesLeft =
                    await SwipesLeft.getCurrentSwipesLeft(_userId, userService);
                if (tmpSwipesLeft > 0) {
                  _matchEngine!.currentItem?.like();
                }
              }
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                  vertical: buttonHeight, horizontal: buttonWidth),
              backgroundColor: _customLoveTheme.primaryColor,
            ),
            child: Icon(Icons.favorite_outline,
                size: buttonSize, color: _customLoveTheme.textColor)),
      ],
    );
  }
}
