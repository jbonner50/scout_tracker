import 'package:flutter/material.dart';

class ProfileCamping extends StatefulWidget {
  final Map<String, dynamic> userData;
  ProfileCamping({this.userData});
  @override
  _ProfileCampingState createState() => _ProfileCampingState();
}

class _ProfileCampingState extends State<ProfileCamping> {
  bool isEditingCamping = false;

  @override
  Widget build(BuildContext context) {
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
}
