import 'package:flutter/material.dart';

class ProfileLeadership extends StatefulWidget {
  final Map<String, dynamic> userData;
  ProfileLeadership({this.userData});
  @override
  _ProfileLeadershipState createState() => _ProfileLeadershipState();
}

class _ProfileLeadershipState extends State<ProfileLeadership> {
  bool isEditingLeadership = false;

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
