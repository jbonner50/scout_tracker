import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:scout_tracker/services/auth.dart';
import 'package:scout_tracker/services/database.dart';
import 'package:scout_tracker/shared.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, Widget> indicators = {
    'progress': Icon(
      Icons.hourglass_full,
      color: Colors.amberAccent,
    ),
    'done': Icon(
      Icons.check_circle,
      color: Colors.greenAccent,
    ),
    'incomplete': Icon(
      Icons.cancel,
      color: Colors.redAccent,
    ),
  };

  bool isEditingLeadership = false;
  bool isEditingCamping = false;

  Widget _buildOverviewCard(Map<String, dynamic> userData) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
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
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Rank Progress Overview',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Spacer(),
                Chip(
                  backgroundColor: Colors.redAccent[100],
                  label: Text(
                    '${(userData['rank_progress'][userData['rank']] * 100).truncate()} %',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 8, bottom: 16),
              height: 1,
              color: Colors.grey[400],
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Leadership Positions',
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '6 months required',
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.grey[500]),
                    ),
                  ],
                ),
                Spacer(),
                Text(
                  '2 months left',
                  style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.grey[500]),
                ),
                SizedBox(width: 5),
                indicators['progress'],
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Merit Badges',
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '6 required (2 Eagle)',
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.grey[500]),
                    ),
                  ],
                ),
                Spacer(),
                Text(
                  '3 left (1 Eagle)',
                  style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.grey[500]),
                ),
                SizedBox(width: 5),
                indicators['progress'],

                // Text(
                //   '2 months left',
                //   style: TextStyle(
                //       // fontWeight: FontWeight.bold,
                //       fontSize: 16,
                //       color: Colors.grey[500]),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadershipCard(Map<String, dynamic> userData) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Leadership Positions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Spacer(),
              ActionChip(
                onPressed: () {
                  print('done');
                  setState(() => isEditingLeadership = !isEditingLeadership);
                },
                label: Icon(isEditingLeadership ? Icons.check : Icons.edit,
                    color: Colors.white, size: 20),
                backgroundColor: Colors.redAccent[100],
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 8, bottom: 16),
            height: 1,
            color: Colors.grey[400],
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Senior Patrol Leader',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'Current Position',
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey[500]),
                  ),
                ],
              ),
              Spacer(),
              Text(
                '8/12/19 - Present',
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey[500]),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scribe',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '1 year, 6 months',
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey[500]),
                  ),
                ],
              ),
              Spacer(),
              Text(
                '1/12/18 - 7/12/19',
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey[500]),
              ),
            ],
          ),
          if (isEditingLeadership) ...[
            SizedBox(height: 10),
            Center(
              child: ActionChip(
                onPressed: () {
                  print('pressed');
                  setState(() => isEditingLeadership = true);
                },
                label: Icon(Icons.add, color: Colors.white, size: 20),
                backgroundColor: Colors.redAccent[100],
              ),
            )
          ],
        ],
      ),
    );
  }

  Widget _buildCampingCard(Map<String, dynamic> userData) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Camping Trips',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Spacer(),
              ActionChip(
                onPressed: () {
                  print('done');
                  setState(() => isEditingCamping = !isEditingCamping);
                },
                label: Icon(isEditingCamping ? Icons.check : Icons.edit,
                    color: Colors.white, size: 20),
                backgroundColor: Colors.redAccent[100],
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 8, bottom: 16),
            height: 1,
            color: Colors.grey[400],
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Art\'s Farm',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '2 days, 2 nights',
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey[500]),
                  ),
                ],
              ),
              Spacer(),
              Text(
                '5/21/18',
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey[500]),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '7 Ranges Scout Camp',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '7 days, 6 nights',
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey[500]),
                  ),
                ],
              ),
              Spacer(),
              Text(
                '7/16/18',
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey[500]),
              ),
            ],
          ),
          if (isEditingCamping) ...[
            SizedBox(height: 10),
            Center(
              child: ActionChip(
                onPressed: () {
                  print('pressed');
                  setState(() => isEditingLeadership = true);
                },
                label: Icon(Icons.add, color: Colors.white, size: 20),
                backgroundColor: Colors.redAccent[100],
              ),
            )
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String uid = Provider.of<String>(context);
    return SingleChildScrollView(
      child: StreamBuilder<DocumentSnapshot>(
          stream: DatabaseService(uid: uid).user,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> userData = snapshot.data.data;
              return Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 6,
                    padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 54,
                          child: CircleAvatar(
                            backgroundColor: Colors.lightBlue[100],
                            backgroundImage:
                                AssetImage('assets/images/scout.png'),
                            radius: 50,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                userData['username'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30),
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.keyboard_capslock,
                                    color: Colors.white),
                                Text(
                                  userData['rank'],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                SizedBox(width: 10),
                                // Text(
                                //   '# ',
                                //   style: TextStyle(
                                //       color: Colors.white,
                                //       fontWeight: FontWeight.bold,
                                //       fontSize: 20),
                                // ),
                                // Text(
                                //   '221',
                                //   style: TextStyle(
                                //       color: Colors.white, fontSize: 20),
                                // ),
                              ],
                            ),
                          ],
                        ),
                        MaterialButton(
                          onPressed: () => AuthService().logout(),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          padding: EdgeInsets.all(10),
                          color: Colors.white24,
                          elevation: 0,
                          highlightElevation: 0,
                          splashColor: Colors.redAccent[100],
                          highlightColor: Colors.transparent,
                          child: Row(
                            children: [
                              Text(
                                'Edit',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Column(
                    //       children: [
                    //         Text(
                    //           'Rank Progress',
                    //           style: TextStyle(
                    //               color: Colors.white,
                    //               fontWeight: FontWeight.bold,
                    //               fontSize: 20),
                    //         ),
                    //         SizedBox(height: 10),
                    //         LinearPercentIndicator(
                    //           width: MediaQuery.of(context).size.width / 5,
                    //           animation: true,
                    //           animationDuration: 400,
                    //           percent: userData['rank_progress']
                    //                   [userData['rank']]
                    //               .toDouble(),
                    //           lineHeight: 35,
                    //           progressColor: Colors.white,
                    //           linearStrokeCap: LinearStrokeCap.roundAll,
                    //           trailing: Container(
                    //             margin: EdgeInsets.only(left: 20),
                    //             child: Text(
                    //               '${(userData['rank_progress'][userData['rank']] * 100).truncate()}%',
                    //               style: TextStyle(
                    //                   color: Colors.white,
                    //                   fontSize: 20,
                    //                   fontWeight: FontWeight.bold),
                    //             ),
                    //           ),
                    //           // linearGradient: LinearGradient(
                    //           //   colors: [
                    //           //     Colors.amber[200],
                    //           //     Colors.redAccent,
                    //           //   ],
                    //           // ),
                    //           backgroundColor: Colors.white24,
                    //         ),
                    //       ],
                    //     ),
                    //     Column(
                    //       children: [
                    //         Text(
                    //           'Badges Earned',
                    //           style: TextStyle(
                    //               color: Colors.white,
                    //               fontWeight: FontWeight.bold,
                    //               fontSize: 20),
                    //         ),
                    //         SizedBox(height: 10),
                    //         Text(
                    //           (() {
                    //             int complete = 0;
                    //             userData['badge_progress']
                    //                 .forEach((key, value) {
                    //               if (value == 1) complete++;
                    //             });
                    //             return complete.toString();
                    //           }()),
                    //           style: TextStyle(
                    //               color: Colors.white,
                    //               fontWeight: FontWeight.bold,
                    //               fontSize: 35),
                    //         ),
                    //       ],
                    //     ),

                    //   ],
                    // ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(30),
                        // borderRadius: BorderRadius.only(
                        //     topRight: Radius.circular(50),
                        //     topLeft: Radius.circular(50)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildOverviewCard(userData),
                          SizedBox(height: 16),
                          _buildLeadershipCard(userData),
                          SizedBox(height: 16),
                          _buildCampingCard(userData),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
