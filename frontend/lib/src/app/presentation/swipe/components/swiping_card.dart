import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:frontend/src/config/theme.dart';

class SwipingCard extends StatelessWidget {

  const SwipingCard({
    super.key,
    required MatchEngine? matchEngine,
    required CustomLoveTheme customLoveTheme,
    required SwipeItem swipeItem,
    required this.swipeable,
  })
      : _matchEngine = matchEngine,
        _customLoveTheme = customLoveTheme,
        _swipeItem = swipeItem;

  final MatchEngine? _matchEngine;
  final CustomLoveTheme _customLoveTheme;
  final SwipeItem _swipeItem;
  final bool swipeable;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = min(MediaQuery.of(context).size.width, 750);
    return Container(
        alignment: Alignment.center,
        height: height - kToolbarHeight,
        width: !kIsWeb ? width * 0.90 : width * 0.65,
        child: Stack(
          children: [
          Card(
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
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: height * 0.08),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 50 : 40),
                              child: Text(
                                _swipeItem.content.firstName,
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                                  children: List<Widget>.generate(_swipeItem.content.interests.length,
                                        (int i) {
                                      Icon avatar;
                                      if (_swipeItem.content.interests[i] == "sport") {
                                        avatar = Icon(Icons.sports_soccer, color: _customLoveTheme.primaryColor);
                                      } else if (_swipeItem.content.interests[i] == "reading") {
                                        avatar = Icon(Icons.book, color: _customLoveTheme.primaryColor);
                                      } else if (_swipeItem.content.interests[i] == "movies") {
                                        avatar = Icon(Icons.movie, color: _customLoveTheme.primaryColor);
                                      } else if (_swipeItem.content.interests[i] == "IT") {
                                        avatar = Icon(Icons.laptop, color: _customLoveTheme.primaryColor);
                                      } else {
                                        avatar = Icon(Icons.favorite, color: _customLoveTheme.primaryColor);
                                      }
                                      return ActionChip(
                                        side: BorderSide(width: 1.5, color: _customLoveTheme.primaryColor),
                                        avatar: avatar,
                                        label: Text(_swipeItem.content.interests[i]),
                                        onPressed: () {},
                                      );
                                    },
                                  ),
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
                    )
                );
              },
              onStackFinished: () {},
              itemChanged: (SwipeItem item, int index) {
                print("item: ${item.content.firstName}, index: $index");
              },
              leftSwipeAllowed: swipeable,
              rightSwipeAllowed: swipeable,
              fillSpace: true,
              likeTag: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _customLoveTheme.primaryColor)
                ),
                child: const Text('Like'),
              ),
              nopeTag: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _customLoveTheme.primaryColor)
                ),
                child: const Text('Dislike'),
              ),
            ),
          ),
        ]));
    }

    Widget locationWidget(city) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [ Icon(Icons.location_on, size: 18),
        Text(
          "Location: $city",
          style: TextStyle(fontSize: kIsWeb ? 16 : 14, fontWeight: FontWeight.bold),
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
              onPressed: () {
                if(swipeable) {
                  _matchEngine!.currentItem?.nope();
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: buttonHeight, horizontal: buttonWidth),
                backgroundColor: _customLoveTheme.primaryColor,
              ),
              child: Icon(Icons.close, size: buttonSize, color: _customLoveTheme.textColor)),
          SizedBox(width: width * 0.1),
          ElevatedButton(
              onPressed: () {
                if(swipeable) {
                  _matchEngine!.currentItem?.like();
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
}
