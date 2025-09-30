import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserHeader extends StatelessWidget {
  final String backgroundImageUrl;
  final String perfilImageUrl;
  final String name;
  final String email;
  final int notificationCount;

  const UserHeader({
    super.key,
    required this.backgroundImageUrl,
    required this.perfilImageUrl,
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
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: backgroundImageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[800],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[800],
                child: const Icon(Icons.error, color: Colors.red),
              ),
            ),
          ),
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
                CachedNetworkImage(
                  imageUrl: perfilImageUrl,
                  imageBuilder: (context, imageProvider) =>
                      CircleAvatar(backgroundImage: imageProvider, radius: 40),
                  placeholder: (context, url) =>
                      const CircleAvatar(radius: 40, child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const CircleAvatar(radius: 40, child: Icon(Icons.person)),
                ),
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
