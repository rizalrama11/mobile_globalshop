import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage('assets/img/user.png'),
            ),
            Text(
              "Rizal Ramadhan",
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: "Pacifico",
              ),
            ),
            Text(
              "Software Engineering",
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.grey[400],
                letterSpacing: 2.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.grey[600],
              ),
            ),
            Card(
              color: Color(0xfffbc30b),
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                leading: Icon(
                  Icons.phone_iphone_rounded,
                  color: Colors.white,
                ),
                title: Text(
                  "+62 895 0769 XXXX",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Source Sans Pro",
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            Card(
              color: Color(0xfffbc30b),
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                leading: Icon(
                  Icons.mail,
                  color: Colors.white,
                ),
                title: Text(
                  "rizalrama20@gmail.com",
                  style: TextStyle(
                    fontFamily: "Source Sans Pro",
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Card(
              color: Color(0xfffbc30b),
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                leading: Icon(
                  Icons.school,
                  color: Colors.white,
                ),
                title: Text(
                  "Global Institute",
                  style: TextStyle(
                    fontFamily: "Source Sans Pro",
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Card(
              color: Color(0xfffbc30b),
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                leading: Icon(
                  Icons.location_city,
                  color: Colors.white,
                ),
                title: Text(
                  "Tangerang, Indonesia",
                  style: TextStyle(
                    fontFamily: "Source Sans Pro",
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
