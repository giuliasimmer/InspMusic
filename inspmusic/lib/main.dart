import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'InspMusic',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            background: Colors.lightBlue.shade100,
          ),
          scaffoldBackgroundColor: Colors.lightBlue.shade100,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.lightBlue.shade100,
            foregroundColor: Colors.black,
          ),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  final List<String> frases = [
    "A música expressa o que não pode ser dito em palavras.",
    "A música é a voz da alma.",
    "Onde as palavras falham, a música fala.",
    "Sem música, a vida seria um erro.",
    "A música é uma explosão da alma.",
    "A música é a arte mais direta.",
    "A música pode mudar o mundo.",
    "A música é uma forma de arte intemporal.",
    "A música é o vinho que enche a taça do silêncio.",
    "A música é a linguagem universal da humanidade.",
    "A vida é como a música, deve ser composta de ouvido, sentindo cada momento.",
    "A música é o alimento da alma.",
    "A música é uma ponte entre o espírito e a matéria.",
    "A música é o remédio da mente.",
    "A música é a maneira divina de contar coisas bonitas ao coração.",
    "A música é a poesia do ar.",
    "A música é o tipo de arte que mais se aproxima das lágrimas e das recordações.",
    "A música é uma revelação maior do que toda a sabedoria e filosofia.",
    "A música é uma língua que não fala em palavras específicas.",
    "A música é uma terapia que pode curar feridas do coração.",
    "A música é a melodia da vida.",
    "A música é o verbo do futuro.",
    "A música é uma forma de vida.",
    "A música é o caminho mais curto entre dois corações.",
    "A música é o respiro do coração.",
    "A música é a forma mais perfeita de arte.",
    "A música é uma oração sem palavras.",
    "A música é a harmonia da vida.",
    "A música é a batida do coração da vida.",
    "A música é a magia que todos podem ouvir."
  ];

  var current = "A música expressa o que não pode ser dito em palavras.";
  var history = <String>[];

  GlobalKey? historyListKey;

  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);
    current = (frases..shuffle()).first;
    notifyListeners();
  }

  var favorites = <String>[];

  void toggleFavorite([String? frase]) {
    frase = frase ?? current;
    if (favorites.contains(frase)) {
      favorites.remove(frase);
    } else {
      favorites.add(frase);
    }
    notifyListeners();
  }

  void removeFavorite(String frase) {
    favorites.remove(frase);
    notifyListeners();
  }

  // Função simples para contar o número de palavras na frase atual
  int countWords(String frase) {
    return frase.split(' ').length;
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.music_note, color: Colors.blue),
            SizedBox(width: 10),
            Text('InspMusic'),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Home', icon: Icon(Icons.home)),
            Tab(text: 'Favoritas', icon: Icon(Icons.favorite)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          GeneratorPage(),
          FavoritesPage(),
        ],
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var frase = appState.current;

    IconData icon;
    if (appState.favorites.contains(frase)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: HistoryListView(),
          ),
          SizedBox(height: 10),
          BigCard(frase: frase),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Curtir'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Próxima'),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text('Número de palavras: ${appState.countWords(frase)}'),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    Key? key,
    required this.frase,
  }) : super(key: key);

  final String frase;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: AnimatedSize(
          duration: Duration(milliseconds: 200),
          child: Text(
            frase,
            style: style,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('Nenhum favorito ainda.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: Text('Você tem '
              '${appState.favorites.length} favoritos:'),
        ),
        Expanded(
          child: GridView(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              childAspectRatio: 400 / 80,
            ),
            children: [
              for (var frase in appState.favorites)
                ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.delete_outline, semanticLabel: 'Deletar'),
                    color: theme.colorScheme.primary,
                    onPressed: () {
                      appState.removeFavorite(frase);
                    },
                  ),
                  title: Text(
                    frase,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class HistoryListView extends StatefulWidget {
  const HistoryListView({Key? key}) : super(key: key);

  @override
  State<HistoryListView> createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  final _key = GlobalKey<AnimatedListState>();

  static const Gradient _maskingGradient = LinearGradient(
    colors: [Colors.transparent, Colors.black],
    stops: [0.0, 0.5],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    appState.historyListKey = _key;

    return ShaderMask(
      shaderCallback: (bounds) => _maskingGradient.createShader(bounds),
      blendMode: BlendMode.dstIn,
      child: AnimatedList(
        key: _key,
        reverse: true,
        padding: EdgeInsets.all(10),
        initialItemCount: appState.history.length,
        itemBuilder: (context, index, animation) {
          final frase = appState.history[index];
          return SizeTransition(
            sizeFactor: animation,
            child: Card(
              child: ListTile(
                title: Text(frase),
              ),
            ),
          );
        },
      ),
    );
  }
}
