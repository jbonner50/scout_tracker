import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:scout_tracker/screens/home/badge_details.dart';
import 'package:scout_tracker/screens/home/profile.dart';

enum BadgeList { all, inprogress, earned, unearned }

class Badges extends StatefulWidget {
  Badges({Key key}) : super(key: key);

  @override
  _BadgesState createState() => _BadgesState();
}

class _BadgesState extends State<Badges> {
  TextEditingController _searchController;

  static List<String> badges = [
    'American Business',
    'American Cultures',
    'American Heritage',
    'American Labor',
    'Animal Science',
    'Animation',
    'Archaeology',
    'Archery',
    'Architecture',
    'Art',
    'Astronomy',
    'Athletics',
    'Automotive Maintenance',
    'Aviation',
    'Backpacking',
    'Basketry',
    'Bird Study',
    'Bugling',
    'Camping',
    'Canoeing',
    'Chemistry',
    'Chess',
    'Citizenship in the Community',
    'Citizenship in the Nation',
    'Citizenship in the World',
    'Climbing',
    'Coin Collecting',
    'Collections',
    'Communication',
    'Composite Materials',
    'Cooking',
    'Crime Prevention',
    'Cycling',
    'Dentistry',
    'Digital Technology',
    'Disabilities Awareness',
    'Dog Care',
    'Drafting',
    'Electricity',
    'Electronics',
    'Emergency Preparedness',
    'Energy',
    'Engineering',
    'Entrepreneurship',
    'Environmental Science',
    'Exploration',
    'Family Life',
    'Farm Mechanics',
    'Fingerprinting',
    'Fire Safety',
    'First Aid',
    'Fish & Wildlife Management',
    'Fishing',
    'Fly Fishing',
    'Forestry',
    'Game Design',
    'Gardening',
    'Genealogy',
    'Geocaching',
    'Geology',
    'Golf',
    'Graphic Arts',
    'Hiking',
    'Home Repairs',
    'Horsemanship',
    'Indian Lore',
    'Insect Study',
    'Inventing',
    'Journalism',
    'Kayaking',
    'Landscape Architecture',
    'Law',
    'Leatherwork',
    'Lifesaving',
    'Mammal Study',
    'Medicine',
    'Metalwork',
    'Mining in Society',
    'Model Design and Building',
    'Motorboating',
    'Moviemaking',
    'Music',
    'Nature',
    'Nuclear Science',
    'Oceanography',
    'Orienteering',
    'Painting',
    'Personal Fitness',
    'Personal Management',
    'Pets',
    'Photography',
    'Pioneering',
    'Plant Science',
    'Plumbing',
    'Pottery',
    'Programming',
    'Public Health',
    'Public Speaking',
    'Pulp and Paper',
    'Radio',
    'Railroading',
    'Reading',
    'Reptile and Amphibian Study',
    'Rifle Shooting',
    'Robotics',
    'Rowing',
    'Safety',
    'Salesmanship',
    'Scholarship',
    'Scouting Heritage',
    'Scuba Diving',
    'Sculpture',
    'Search and Rescue',
    'Shotgun Shooting',
    'Signs, Signals, and Codes',
    'Skating',
    'Small-Boat Sailing',
    'Snow Sports',
    'Soil and Water Conservation',
    'Space Exploration',
    'Sports',
    'Stamp Collecting',
    'Surveying',
    'Sustainability',
    'Swimming',
    'Textile',
    'Theater',
    'Traffic Safety',
    'Truck Transportation',
    'Veterinary Medicine',
    'Water Sports',
    'Weather',
    'Welding',
    'Whitewater',
    'Wilderness Survival',
    'Wood Carving',
    'Woodwork',
  ];

  static List<String> eagleBadges = [
    'Camping',
    'Citizenship in the Community',
    'Citizenship in the Nation',
    'Citizenship in the World',
    'Communication',
    'Cooking',
    'Cycling',
    'Emergency Preparedness',
    'Environmental Science',
    'Family Life',
    'First Aid',
    'Hiking',
    'Lifesaving',
    'Personal Fitness',
    'Personal Management',
    'Sustainability',
    'Swimming',
  ];

  List<String> badgeSearchList = List.from(badges);

  onSearchChanged(String query) {
    setState(() {
      badgeSearchList = badges
          .where((string) => string.toLowerCase().contains(query.toLowerCase()))
          .toList();
      if (eagleOnly) {
        badgeSearchList = badgeSearchList
            .where((element) => eagleBadges.contains(element))
            .toList();
      }
    });
  }

  bool eagleOnly = false;
  Map<String, Widget> indicators = {
    'all': Icon(
      Icons.all_inclusive,
      // color: Colors.black,
    ),
    'inprogress': Icon(
      Icons.hourglass_empty,
      // color: Colors.amberAccent,
    ),
    'done': Icon(
      Icons.check,
      // color: Colors.greenAccent,
    ),
    'incomplete': Icon(
      Icons.clear,
      // color: Colors.redAccent,
    ),
  };

  Widget _buildBadgeTile(String badgeName) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4, // soften the shadow
            spreadRadius: 1, //extend the shadow
            offset: Offset(
              0, // Move to right 10  horizontally
              2, // Move to bottom 10 Vertically
            ),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Material(
          child: InkWell(
            splashColor: Colors.redAccent[100],
            highlightColor: Colors.grey.withOpacity(0.15),
            // When the user taps the button, show a snackbar.
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BadgeDetails(
                            badgeName: badgeName,
                          )));
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: badgeName,
                    child: SvgPicture.asset(
                      'assets/images/badges/${badgeName.toLowerCase().replaceAll(' ', '-')}.svg',
                      height: 70,
                      placeholderBuilder: (context) => Center(
                        child: SpinKitDoubleBounce(
                          color: Colors.redAccent[100],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        badgeName,
                        maxLines: 2,
                        wrapWords: false,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  LinearPercentIndicator(
                    percent: 0.6,
                    lineHeight: 10,
                    linearGradient: new LinearGradient(
                      colors: [
                        Colors.amber[200],
                        Colors.redAccent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    backgroundColor: Colors.grey[200],
                    clipLinearGradient: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadges({BadgeList type}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(30),
          // borderRadius: BorderRadius.only(
          //     topRight: Radius.circular(50),
          //     topLeft: Radius.circular(50)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: GridView.count(
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 3,
            scrollDirection: Axis.vertical,
            childAspectRatio: 0.85,
            children: badgeSearchList.map((badgeName) {
              return _buildBadgeTile(badgeName);
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              sliver: SliverAppBar(
                // forceElevated: value,
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(30),
                ),
                elevation: 0,
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  centerTitle: true,
                  background: Container(
                    padding: EdgeInsets.fromLTRB(24, 8, 16, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadiusDirectional.circular(30),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: onSearchChanged,
                      style: TextStyle(fontSize: 25, color: Colors.black),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search Badges",
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                _searchController.clear();
                                onSearchChanged("");
                              },
                              icon: Icon(Icons.clear, color: Colors.black),
                            ),
                            FilterChip(
                              label: Text('Eagle Only',
                                  style: TextStyle(fontFamily: 'ProductSans')),
                              labelStyle: TextStyle(color: Colors.white),
                              selected: eagleOnly,
                              onSelected: (bool selected) {
                                setState(() {
                                  eagleOnly = !eagleOnly;
                                });
                                onSearchChanged(_searchController.text);
                              },
                              backgroundColor: Colors.grey[400],
                              selectedColor: Colors.redAccent[100],
                              checkmarkColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(60),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(6.0),
                    child: TabBar(
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey[400],
                      labelStyle: TextStyle(
                          fontSize: 20,
                          fontFamily: 'ProductSans',
                          fontWeight: FontWeight.bold),
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.redAccent[100],
                      ),
                      tabs: [
                        Tab(icon: indicators['all']),
                        Tab(icon: indicators['inprogress']),
                        Tab(child: indicators['done']),
                        Tab(child: indicators['incomplete']),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        // flexibleSpace:
        //     child: Align(
        //         alignment: Alignment.bottomCenter,
        //         child: RaisedButton(onPressed: () {})),
        //   ),
        //   // child: Column(
        //   //   mainAxisAlignment: MainAxisAlignment.center,
        //   //   crossAxisAlignment: CrossAxisAlignment.center,
        //   //   children: <Widget>[
        //   //     Container(
        //   //         margin: EdgeInsets.only(top: 16.0),
        //   //         padding: EdgeInsets.only(left: 32.0, right: 32.0),
        //   //         child: Text(
        //   //           'Some text',
        //   //           textAlign: TextAlign.center,
        //   //           style: TextStyle(
        //   //               color: Colors.white,
        //   //               fontFamily: 'PlayfairDisplay',
        //   //               fontStyle: FontStyle.italic,
        //   //               fontSize: 16.0),
        //   //         )),
        //   //     Container(
        //   //         margin: EdgeInsets.only(top: 16.0),
        //   //         padding: EdgeInsets.only(left: 32.0, right: 32.0),
        //   //         child: Text(
        //   //           'some text',
        //   //           textAlign: TextAlign.center,
        //   //           style: TextStyle(
        //   //               color: Colors.white,
        //   //               fontFamily: 'PlayfairDisplay',
        //   //               fontSize: 16.0),
        //   //         )),
        //   //   ],
        //   // ),
        // ),

        body: TabBarView(
          children: [
            _buildBadges(type: BadgeList.all),
            _buildBadges(type: BadgeList.inprogress),
            _buildBadges(type: BadgeList.earned),
            Container(
              color: Colors.red,
            ),
            // _buildBadges(type: BadgeList.unearned),
          ],
        ),
      ),
    );
  }
}
