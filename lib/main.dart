import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:achados_da_cidade/theme.dart';
import 'package:achados_da_cidade/nav.dart';
import 'package:achados_da_cidade/services/auth_service.dart';
import 'package:achados_da_cidade/services/item_service.dart';
import 'package:achados_da_cidade/services/chat_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = AuthService();
  await authService.init();

  final itemService = ItemService();
  await itemService.loadItems();

  runApp(MyApp(
    authService: authService,
    itemService: itemService,
  ));
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  final ItemService itemService;

  const MyApp({
    super.key,
    required this.authService,
    required this.itemService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authService),
        ChangeNotifierProvider.value(value: itemService),
        ChangeNotifierProvider(create: (_) => ChatService()),
      ],
      child: Consumer<AuthService>(
        builder: (context, auth, _) => MaterialApp.router(
          title: 'Achados da Cidade',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: AppRouter.createRouter(auth),
        ),
      ),
    );
  }
}
