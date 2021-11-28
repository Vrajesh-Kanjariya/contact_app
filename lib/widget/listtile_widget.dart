import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ListTileWidget extends StatelessWidget {
  String url;
  String firstName;
  String lastName;
  String date;
  String contact;
  String address;

  ListTileWidget(this.firstName, this.lastName, this.date, this.contact,
      this.address, this.url);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 5,
      shadowColor: Colors.grey,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        padding: EdgeInsets.only(left: 7.5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            onBackgroundImageError: (context, error) => Icon(Icons.error),
            backgroundImage: CachedNetworkImageProvider(
              url,
            ),
          ),
          title: Text(
            firstName + " " + lastName,
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
              Text(
                contact,
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
              Text(
                address,
                style: TextStyle(color: Colors.black, fontSize: 15),
              )
            ],
          ),
          // horizontalTitleGap: 20.0,
          contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
        ),
      ),
    );
  }
}
