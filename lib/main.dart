import 'package:MealApp/widgets/transcation_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './widgets/chart.dart';
import './widgets/new_transcation.dart';
import './models/transcation.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter  App',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'OpenSans',
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'QuickSand',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transcation> _userTranscations = [
    // Transcation(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 69.00,
    //   date: DateTime.now(),
    // ),
    // Transcation(
    //   id: 't2',
    //   title: 'New Short',
    //   amount: 49.00,
    //   date: DateTime.now(),
    // ),
  ];

  List<Transcation> get _recentTranscation {
    return _userTranscations.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTranscation(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transcation(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );
    setState(() {
      _userTranscations.add(newTx);
    });
  }

  // final List<Transcation> transcations = [];
  // String titleInput;
  // String amountInput;
  void _startAddNewTranscation(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTranscation(_addNewTranscation),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  bool _showChart = false;
  void _deleteTranscation(String id) {
    setState(() {
      _userTranscations.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final appBar = AppBar(
      title: Text('Flutter App'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => {
            _startAddNewTranscation(context),
          },
        ),
      ],
    );
    final txListWidget = Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: TranscationList(_userTranscations, _deleteTranscation),
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Show Chart'),
                  Switch.adaptive(
                      activeColor: Theme.of(context).accentColor,
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      }),
                ],
              ),
            if (!isLandscape)
              Container(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.3,
                child: Chart(_recentTranscation),
              ),
            if (!isLandscape) txListWidget,
            if (isLandscape)
              _showChart
                  ? Container(
                      //   height: (MediaQuery.of(context).size.height -
                      //       appBar.prefferedS -
                      //       MediaQuery.of(context).padding.top) *
                      //   0.4,
                      child: Chart(_recentTranscation),
                    )
                  : txListWidget
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          _startAddNewTranscation(context),
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
