import 'package:apakly/music/components/playlist_screen.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class Playlist_Prev extends StatelessWidget {
  String coverUrl;
  String title;

  Playlist_Prev({
    required this.coverUrl,
    required this.title,
    super.key
  });

  @override
  Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;

  return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Playlist_Screen(),
            )
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          height: size.height * 0.14,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: AspectRatio(
                      aspectRatio: 1/1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image(
                          image: AssetImage(coverUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: fSize1,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 18,
                  child: Icon(
                    Icons.more_vert,
                    color: iconColor,
                    size: 16,
                  ),
                ),
                onTap: (){},
              ),

            ],
          ),
        ),
      ),
    );
  }
}
