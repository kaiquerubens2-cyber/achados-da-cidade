import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item_model.dart';

class ItemService extends ChangeNotifier {
  List<ItemModel> _items = [];
  bool _isLoading = false;

  List<ItemModel> get items => _items;
  bool get isLoading => _isLoading;

  // Instância do Cloud Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'items';

  ItemService() {
    loadItems();
  }

  // Carregar itens do Cloud Firestore
  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      final querySnapshot = await _firestore.collection(_collectionName).get();
      
      if (querySnapshot.docs.isNotEmpty) {
        _items = querySnapshot.docs.map((doc) {
          final data = doc.data();
          // Garante que o ID do documento do Firestore seja considerado no modelo
          data['id'] = doc.id;
          return ItemModel.fromMap(data);
        }).toList();
      } else {
        // Lista padrão caso o banco esteja vazio pela primeira vez
        final defaultItem = ItemModel(
          id: '1',
          title: 'Praça Central',
          description: 'Ponto de encontro e comércio local.',
          latitude: -23.550520,
          longitude: -46.633308,
          category: 'Lazer',
        );
        
        // Salva o item padrão no Firestore
        await _firestore.collection(_collectionName).doc(defaultItem.id).set(defaultItem.toMap());
        _items = [defaultItem];
      }
    } catch (e) {
      debugPrint('Erro ao carregar itens do Firestore: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Adicionar um novo item e salvar diretamente no Cloud Firestore
  Future<void> addItem(ItemModel item) async {
    try {
      // Se o item não tiver ID ou gerarmos um novo, salvamos no Firestore
      final docRef = item.id.isNotEmpty 
          ? _firestore.collection(_collectionName).doc(item.id)
          : _firestore.collection(_collectionName).doc();

      final newItem = ItemModel(
        id: docRef.id,
        title: item.title,
        description: item.description,
        latitude: item.latitude,
        longitude: item.longitude,
        category: item.category,
        // Adicione outros campos caso seu ItemModel possua (ex: imageUrl, date, etc.)
      );

      await docRef.set(newItem.toMap());

      _items.add(newItem);
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao adicionar item no Firestore: $e');
    }
  }
}
