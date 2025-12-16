
 
import 'package:first_flutter/data/models/sentence.dart';
import 'package:first_flutter/data/repositories/authentication_repository.dart'; 
import 'package:first_flutter/data/repositories/sentence_repository.dart';
import 'package:first_flutter/data/services/authentication_service.dart';
import 'package:first_flutter/data/services/sentence_service.dart';
import 'package:first_flutter/presentation/viewmodels/authentication_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/viewmodels/sentence_vm.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        
        Provider<ISentenceService>(
          create: (context) => SentenceService(),
        ),
        Provider<ISentenceRepository>(
          create: (context) => SentenceRepository(
            sentenceService: context.read(),
          ),
        ),
    
        Provider<IAuthenticationService>(
          create: (context) => AuthenticationService(),
        ),
        
        
        Provider<IAuthenticationRepository>(
          create: (context) => AuthenticationRepository(
            authService: context.read<IAuthenticationService>(),
          ),
        ),

        
        ChangeNotifierProvider(
          create: (context) => AuthenticationVM(
            
            authRepository: context.read<IAuthenticationRepository>(),
          ),
        ),
        
        
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SentenceVM(sentenceRepository: context.read()),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      case 2:
        page = LoginPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 450) {
        return Scaffold(
          body: Row(children: [MainArea(page: page)]),
          bottomNavigationBar: NavigationBar(
            destinations: [
              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
              NavigationDestination(icon: Icon(Icons.login), label: 'Login'),
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
          ),
        );
      } else {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 800,
                  destinations: [
                    NavigationRailDestination(
                        icon: Icon(Icons.home), label: Text('Home')),
                    NavigationRailDestination(
                        icon: Icon(Icons.favorite), label: Text('Favorites')),
                    NavigationRailDestination(
                        icon: Icon(Icons.login), label: Text('Login')),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              MainArea(page: page),
            ],
          ),
        );
      }
    });
  }
}

class MainArea extends StatelessWidget {
  const MainArea({super.key, required this.page});

  final Widget page;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: page,
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var vm = context.watch<SentenceVM>();

    if (vm.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    var sentence = vm.current;
    IconData icon = vm.isFavorite(sentence) ? Icons.favorite : Icons.favorite_border;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView(
              children: [
                for (var word in vm.history)
                  ListTile(
                    leading: Icon(
                      vm.isFavorite(word)
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                    title: Text(word.text),
                  ),
              ],
            ),
          ),
          Text('A random AWESOME idea:'),
          BigCard(pair: sentence),
          SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  vm.toggleCurrentFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  vm.next();
                },
                child: Text('Next'),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var vm = context.watch<SentenceVM>();

    if (vm.favorites.isEmpty) {
      return Center(child: Text('No favorites yet.'));
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'You have ${vm.favorites.length} favorites:',
          ),
        ),
        for (var word in vm.favorites)
          ListTile(
            leading: IconButton(
              icon: Icon(Icons.favorite),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                vm.toggleFavorite(word);
              },
              tooltip: 'Remove from favorites',
            ),
            title: Text(word.text),
          ),
      ],
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({super.key, required this.pair});

  final Sentence pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      shadows: [
        Shadow(
            color: theme.colorScheme.primaryContainer, blurRadius: 10),
      ],
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(pair.text, style: style),
      ),
    );
  }
}


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthenticationVM>();

    return Center(
      child: Container(
        width: 400,
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _userController,
              decoration: InputDecoration(labelText: "Enter Username"),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passController,
              decoration: InputDecoration(labelText: "Enter Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: authVM.isLoading
                  ? null 
                  : () async {
                      
                      await authVM.login(
                        _userController.text.trim(),
                        _passController.text.trim(),
                      );
                      
                      if (authVM.currentUser != null) {
                        _userController.clear();
                        _passController.clear();
                      }
                    },
              child: authVM.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 3),
                    ) 
                  : Text("Login"),
            ),
            SizedBox(height: 20),
          
            if (authVM.isLoading)
              Text("Logging in...")
            else if (authVM.errorMessage != null)
              Text(
                "Error: ${authVM.errorMessage}",
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              )
            else
              Text(
                authVM.currentUser == null
                    ? "Not logged in yet."
                    : "Logged as: ${authVM.currentUser!.username} (ID: ${authVM.currentUser!.id})",
              ),
          ],
        ),
      ),
    );
  }
}