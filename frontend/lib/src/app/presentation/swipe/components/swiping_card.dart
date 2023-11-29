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
  }) : _matchEngine = matchEngine, _customLoveTheme = customLoveTheme, _swipeItem = swipeItem;

  final MatchEngine? _matchEngine;
  final CustomLoveTheme _customLoveTheme;
  final SwipeItem _swipeItem;
  final bool swipeable;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height - kToolbarHeight,
        width: MediaQuery.of(context).size.width * 0.65,
        child: Stack(children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            clipBehavior: Clip.hardEdge,
            child: SwipeCards(
              matchEngine: _matchEngine!,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    alignment: Alignment.center,
                    color: _customLoveTheme.neutralBackgroundColor,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 70),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Text(
                              _swipeItem.content.firstName,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                child: Text(
                                  "Age: 25",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(width: 200),
                              Icon(Icons.location_on, size: 18),
                              Text(
                                "Location: ",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Wrap(
                              spacing: 25,
                              runSpacing: 4,
                              children: List<Widget>.generate(_swipeItem.content.interests.length,
                                    (int i) {
                                  var avatar;
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
                          Center(
                            child: Container(
                              //for small bio card
                              height: MediaQuery.of(context).size.height - 520,
                              width: MediaQuery.of(context).size.width * 0.53,
                              margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 35),
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
                                      style: const TextStyle(fontSize: 16),
                                      textAlign: TextAlign.left
                                  )
                              ),
                            ),
                          ),
                        ]
                    )
                );
              },
              onStackFinished: () {},
              itemChanged: (SwipeItem item, int index) {
                print("item: ${item.content.firstName}, index: $index");
              },
              leftSwipeAllowed: swipeable,
              rightSwipeAllowed: swipeable,
              //upSwipeAllowed: true,
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
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          if(swipeable) {
                            _matchEngine!.currentItem?.nope();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 40),
                          backgroundColor: _customLoveTheme.primaryColor,
                        ),
                        child: Icon(Icons.close, size: 40, color: _customLoveTheme.textColor)),
                    const SizedBox(width: 25),
                    ElevatedButton(
                        onPressed: () {
                          if(swipeable) {
                            _matchEngine!.currentItem?.like();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 40),
                          backgroundColor: _customLoveTheme.primaryColor,
                        ),
                        child: Icon(Icons.favorite_outline, size: 40, color: _customLoveTheme.textColor)),
                  ],
                ),
              )
          )
        ]));
  }
}
