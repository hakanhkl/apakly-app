import 'package:apakly/http/following_requests.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class FollowButton extends StatefulWidget {
  String artistId;
  bool isFollowingState = false;

  FollowButton({super.key, required this.artistId});

  @override
  State<FollowButton> createState() => _FollowButton();
}

class _FollowButton extends State<FollowButton> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: isFollowing(widget.artistId),
        builder: (error, isFollowing) {
          if (isFollowing.hasData) widget.isFollowingState = isFollowing.data!;

          if (widget.isFollowingState) {
            // user is following artist
            return OutlinedButton(
              style: OutlinedButton.styleFrom(
                  shape: const StadiumBorder(),
                  side: const BorderSide(width: 1.5, color: primaryColor),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8)),
              onPressed: () {
                unfollow(artistId: widget.artistId);
                setState(() {
                  widget.isFollowingState = false;
                });
              },
              child: const Text(
                'unfollow',
                style: TextStyle(
                  color: textColor,
                  fontSize: fSize1,
                ),
              ),
            );
          } else {
            // user is not following artist
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor: primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8)),
              onPressed: () {
                follow(artistId: widget.artistId);
                setState(() {
                  widget.isFollowingState = true;
                });
              },
              child: const Text(
                'follow',
                style: TextStyle(
                  color: textColor,
                  fontSize: fSize1,
                ),
              ),
            );
          }
        });
  }
}
