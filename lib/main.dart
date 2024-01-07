import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify_app/providers/ads_provider.dart';
import 'package:shopify_app/providers/auth_provider.dart';
import 'package:shopify_app/providers/cart_provider.dart';
import 'package:shopify_app/providers/categories_provider.dart';
import 'package:shopify_app/providers/products_provider.dart';
import 'package:shopify_app/screens/splash_screen.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProviderApp()),
      Provider(create: (_) => AdsProvider()),
      Provider(create: (_) => CategoriesProvider()),
      Provider(create: (_) => ProductsProvider()),
      Provider(create: (_) => CartProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}