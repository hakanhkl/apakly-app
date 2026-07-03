import 'package:get/get.dart';
import 'objects/album.dart';
import 'objects/song.dart';
import 'package:collection/collection.dart';

class CartController extends GetxController{
  var _items = {}.obs;
  void addItem(Object object){
    if(!_items.containsKey(object)){
      _items[object] = 1;
    }

    Get.snackbar(
        "Product Added", "You have added the ${object} to the cart.",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2)
    );
  }

  void removeSingle(Object object){
    if(_items.containsKey(object)){
      _items.removeWhere((key, value) => key == object);
    }
  }

  void removeAlbum(Album album){
    if(_items.containsKey(album)){
      _items.removeWhere((key, value) => key == album);
    }
  }

  get items => _items;

  //get items1 => items1.firstWhereOrNull((element) => element == element, orElse: () => null);

  get itemSubtotal => _items.entries.map((items) => items.key.price * items.value).toList();

  get total => _items.entries.map((items) => items.key.price * items.value).toList().reduce((value, element) => value + element).toString();

  get amount => _items.entries.map((items) => items.value).toList().reduce((value, element) => value + element).toStringAsFixed(2);
}