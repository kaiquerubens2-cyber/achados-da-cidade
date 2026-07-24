// --- TELA DE CADASTRO DE NOVO ACHADO COM MAPA E FOTO ---
class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  // Padrão inicial (ex: Centro de Atalaia - AL ou coordenadas aproximadas)
  LatLng _selectedLocation = const LatLng(-9.5036, -36.0125); 
  bool _gettingLocation = true;
  
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _setCurrentLocation();
  }

  Future<void> _setCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
        _gettingLocation = false;
      });
    } catch (e) {
      setState(() {
        _gettingLocation = false;
      });
    }
  }

  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      final newItem = ItemModel(
        id: const Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        latitude: _selectedLocation.latitude,
        longitude: _selectedLocation.longitude,
        category: 'Geral',
        imagePath: _selectedImage?.path,
      );

      await context.read<ItemService>().addItem(newItem);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Achado cadastrado com localização exata!')),
        );
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Novo Achado'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título do Achado (ex: Chave em Atalaia)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor, insira um título'
                    : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 15),
              
              // Seção da Foto
              Center(
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _selectedImage!,
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, size: 30, color: Colors.grey),
                            SizedBox(height: 4),
                            Text('Sem foto', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _takePhoto,
                icon: const Icon(Icons.camera_alt, size: 18),
                label: const Text('Tirar Foto do Item'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  foregroundColor: Colors.white,
                ),
              ),
              
              const SizedBox(height: 15),
              const Text(
                'Toque no mapa abaixo para marcar o local exato do achado:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),

              // Mini Mapa Interativo para selecionar o ponto
              Container(
                height: 220,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: _gettingLocation
                      ? const Center(child: CircularProgressIndicator())
                      : FlutterMap(
                          options: MapOptions(
                            initialCenter: _selectedLocation,
                            initialZoom: 15.0,
                            onTap: (tapPosition, point) {
                              setState(() {
                                _selectedLocation = point;
                              });
                            },
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.achados_dacidade',
                              maxZoom: 19,
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: _selectedLocation,
                                  width: 50,
                                  height: 50,
                                  child: const Icon(
                                    Icons.location_pin,
                                    color: Colors.red,
                                    size: 45,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
              ),
              
              const SizedBox(height: 8),
              Text(
                'Coordenadas selecionadas:\nLat: ${_selectedLocation.latitude.toStringAsFixed(4)}, Lng: ${_selectedLocation.longitude.toStringAsFixed(4)}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: _saveItem,
                child: const Text('Salvar Achado no Mapa', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
