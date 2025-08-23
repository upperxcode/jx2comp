import 'package:flutter/material.dart';

class UserHeader extends StatelessWidget {
  final ImageProvider backgroundImage;
  final ImageProvider perfilimage;
  final String name;
  final String email;
  final int notificationCount;

  const UserHeader({
    super.key,
    required this.backgroundImage,
    required this.perfilimage,
    required this.name,
    required this.email,
    required this.notificationCount,
  });

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      padding: EdgeInsets.zero,
      child: Stack(
        children: <Widget>[
          // Background Image
          Positioned.fill(child: Image(image: backgroundImage, fit: BoxFit.cover)),
          // User Info
          Positioned(
            bottom: 0,
            top: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(backgroundImage: perfilimage, radius: 40),
                SizedBox(height: 10.0),
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        email,
                        style: TextStyle(color: Colors.white, fontSize: 14.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 5.0),
                    if (notificationCount > 0)
                      CircleAvatar(
                        radius: 12.0,
                        backgroundColor: Colors.red,
                        child: Text(
                          notificationCount.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 10.0),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
