import 'package:frontend/src/app/model/user_model.dart';
import 'package:frontend/src/app/presentation/swipe/util/content.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../../../service/user_service.dart';

class Swipe extends StatefulWidget {
  final UserService userService;

  const Swipe({Key? key, required this.userService}) : super(key: key);


  @override
  _SwipeState createState() => _SwipeState();
}

class _SwipeState extends State<Swipe> {
  List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool isLoading = false;

  /*
  user_bravo = User(
        first_name='Bravo',
        last_name='Bravonson',
        email='bravo.bravonson@email.com',
        tel='+92 231 023 953',
        bio='Test subject 2',
        date_of_birth=datetime.today(),
        job='Data Scientist',
        search_radius=50,
        swipes_left=5,
        languages=[english, french, german],
        gender_preferences=[man, woman],
        preferences=[preference_1],
        address=ulm,
        gender_identity=woman,
        interests=[travel, books, science],
        password="pass1"
    )
   */

  final List<Content> _cards = [
    Content(firstName: "Bravo", languages: ["english", "french"], bio: "hello,...", interests: ["sport", "reading", "movies", "IT"])];


  @override
  void initState() {
    super.initState();
    _matchEngine = MatchEngine(swipeItems: _swipeItems);

    _loadNextUser();
  }

  void _loadNextUser() async {
    setState(() {
      isLoading = true;
    });

    await widget.userService.getUser().then((User? user) {
      if (user == null) {
        setState(() {
          _swipeItems.add(SwipeItem(
            content: const Text("There's no user to show"),
          ));
        });
      } else {
        setState(() {
          var firstName = user.firstName;
          _swipeItems.add(SwipeItem(
              content: Content(firstName: firstName, languages: _cards
                  .elementAt(0)
                  .languages, bio: user.bio, interests: _cards
                  .elementAt(0)
                  .interests),
              likeAction: () {
                /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Liked $firstName"),
                  duration: const Duration(milliseconds: 500),
                )); */
                _loadNextUser();
              },
              nopeAction: () {
                /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Disliked $firstName"),
                  duration: const Duration(milliseconds: 500),
                ));*/
                _loadNextUser();
              },
              onSlideUpdate: (SlideRegion? region) async {
                //print("Region $region");
              }));
        });
        }
      }).whenComplete(() {
          isLoading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
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
                        color: Colors.white38,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 70),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 50),
                                child: Text(
                                  _swipeItems[index].content.firstName,
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
                                  children: List<Widget>.generate(_swipeItems[index].content.interests.length,
                                      (int i) {
                                        var avatar;
                                        if (_swipeItems[index].content.interests[i] == "sport") {
                                          avatar = const Icon(Icons.sports_soccer, color: Colors.pink);
                                        } else if (_swipeItems[index].content.interests[i] == "reading") {
                                          avatar = const Icon(Icons.book, color: Colors.pink);
                                        } else if (_swipeItems[index].content.interests[i] == "movies") {
                                          avatar = const Icon(Icons.movie, color: Colors.pink);
                                        } else if (_swipeItems[index].content.interests[i] == "IT") {
                                          avatar = const Icon(Icons.laptop, color: Colors.pink);
                                        } else {
                                          avatar = const Icon(Icons.favorite, color: Colors.pink);
                                        }
                                        return ActionChip(
                                              side: const BorderSide(width: 1.5, color: Colors.pink),
                                              avatar: avatar,
                                              label: Text(_swipeItems[index].content.interests[i]),
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
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3), // changes position of shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(
                                        _swipeItems[index].content.bio,
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
                    leftSwipeAllowed: true,
                    rightSwipeAllowed: true,
                    //upSwipeAllowed: true,
                    fillSpace: true,
                    likeTag: Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green)
                      ),
                      child: const Text('Like'),
                    ),
                    nopeTag: Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.red)
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
                              _matchEngine!.currentItem?.nope();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 40),
                              backgroundColor: Colors.pink,
                            ),
                            child: const Icon(Icons.thumb_down_alt_outlined, size: 35, color: Colors.black)),
                        const SizedBox(width: 25),
                        ElevatedButton(
                            onPressed: () {
                              _matchEngine!.currentItem?.like();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 40),
                              backgroundColor: Colors.pink,
                            ),
                            child: const Icon(Icons.thumb_up_alt_outlined, size: 35, color: Colors.black)),
                      ],
                    ),
                  )
                )
              ])),
            )
    );
  }

}
