import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item_model.dart';

class ItemService extends ChangeNotifier {
  List<ItemModel> _items = [];
  bool _isLoading = false;

  List<ItemModel> get items => _items;
  bool get isLoading => _isLoading;

  ItemService() {
    loadItems();
  }

  // Chave para salvar no SharedPreferences
  static const String _storageKey = 'saved_items_list';

  // Carregar itens salvos na memória interna
  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? itemsString = prefs.getString(_storageKey);

      if (itemsString != null) {
        final List<dynamic> decodedData = jsonDecode(itemsString);
        _items = decodedData.map((json) => ItemModel.fromMap(json)).toList();
      } else {
        // Lista padrão caso esteja vazio pela primeira vez
        _items = [
          ItemModel(
            id: '1',
            title: 'Praça Central',
            description: 'Ponto de encontro e comércio local.',
            latitude: -23.550520,
            longitude: -46.633308,
            category: 'Lazer',
          ),
        ];
        await _saveToStorage();
      }
    } catch (e) {
      debugPrint('Erro ao carregar itens: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Adicionar um novo item e salvar permanentemente
  Future<void> addItem(ItemModel item) async {
    _items.add(item);
    notifyListeners();
    await _saveToStorage();
  }

  // Método auxiliar para salvar a lista em JSON no SharedPreferences
  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encodedData = jsonEncode(_items.map((item) => item.toMap()).toList());
      await prefs.setString(_storageKey, encodedData);
    } catch (e) {
      debugPrint('Erro ao salvar itens: $e');
    }
  }
}
