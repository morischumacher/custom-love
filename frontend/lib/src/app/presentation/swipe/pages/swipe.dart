import 'dart:async';

import 'package:frontend/src/app/model/user_model.dart';
import 'package:frontend/src/app/presentation/swipe/util/content.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:frontend/src/config/theme.dart';
import 'package:frontend/src/app/presentation/authentification/controller/login_controller.dart';

import '../../../service/user_service.dart';
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

        setState(() {
          swipeable = false;
        });

        Timer(const Duration(seconds: 10), () {
          setState(() {
            swipeable = true;
          });
        });

        print("user name: " + user.firstName);
        _swipeItem = SwipeItem(
          content: Content(firstName: firstName, languages: _cards
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
              child: Container(
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
              ])),
            )
    );
  }

}
