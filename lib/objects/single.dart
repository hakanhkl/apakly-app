import 'package:apakly/objects/item.dart';
import 'package:apakly/objects/song.dart';

/// Single is a subclass for Items
class Single extends Item{
  Song? song;

  Single({
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
    super.balance,
    super.exclusivity,
    super.feedText,
    super.thankYouText,
    this.song
  });
}