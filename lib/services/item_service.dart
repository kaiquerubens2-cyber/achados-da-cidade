import 'package:flutter/foundation.dart';
import '../models/item_model.dart';

class ItemService extends ChangeNotifier {
  List<ItemModel> _items = [];
  bool _isLoading = false;

  List<ItemModel> get items => _items;
  bool get isLoading => _isLoading;

  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();

    // Simulando uma busca de dados ou API
    await Future.delayed(const Duration(seconds: 1));
    
    _items = [
      ItemModel(
        id: '1',
        title: 'Praça Central',
        description: 'Ponto de encontro e comércio local.',
        latitude: -23.550520,
        longitude: -46.633308,
        category: 'Lazer',
      ),
      ItemModel(
        id: '2',
        title: 'Mercado Municipal',
        description: 'Variedade de produtos da região.',
        latitude: -23.545200,
        longitude: -46.628200,
        category: 'Comércio',
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  // Método para adicionar um novo achado à lista
  Future<void> addItem(ItemModel item) async {
    _items.add(item);
    notifyListeners();
  }
}
