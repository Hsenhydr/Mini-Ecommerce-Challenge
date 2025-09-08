import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'providers/authentication.provider.dart';
import 'providers/product.provider.dart';
import 'providers/theme.provider.dart';
import 'providers/cart.provider.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/products.dart';
import 'screens/adminPages/admin.dart';
import 'screens/cart.dart';
import 'screens/userOrders.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MiniEcommerceApp());
}

class MiniEcommerceApp extends StatelessWidget {
  const MiniEcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Flutter Mini‑Ecommerce Coding Challenge',
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: const Color.fromARGB(255, 4, 0, 255),
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: const Color.fromARGB(255, 4, 0, 255),
              brightness: Brightness.dark,
            ),
            themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
            home: const MainPage(),
            routes: {
              '/login': (_) => const LoginScreen(),
              '/register': (_) => const RegisterScreen(),
              '/products': (_) => const ProductPage(),
              '/admin': (_) => const AdminScreen(),
              '/cart': (_) => const CartScreen(),
              '/orders': (_) => const UserOrdersPage(),
            },
          );
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  // check auth, eza auth -> products/admin else login
  Future<void> _checkAuth() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.autoLogin();

    if (!mounted) return;

    if (auth.isAuthenticated) {
      Navigator.pushReplacementNamed(
        context,
        auth.role == 'ADMIN' ? '/admin' : '/products',
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
