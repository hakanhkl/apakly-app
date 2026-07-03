import 'package:apakly/objects/item.dart';
import 'package:apakly/objects/song.dart';

class Album extends Item{
  List<Song>? songs;

  Album({
    super.id,
    super.artist,
    super.itemName,
    super.coverFileLocation,
    super.editions,
    super.price,
    super.nftToken,
    super.genre,
    super.releaseDateTime,
    super.leftEditions,
    super.itemType,
    super.chain,
    super.credits,
    super.sentence,
    super.previewUri,
    this.songs,
  });
}