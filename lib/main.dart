import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        platform: TargetPlatform.iOS,
      ),
      home: SafeArea(child: MyHomePage(title: 'Flutter Demo Home Page')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    Widget normalScreen() {
      return Column(
        // Column is also a layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        //
        // Invoke "debug painting" (press "p" in the console, choose the
        // "Toggle Debug Paint" action from the Flutter Inspector in Android
        // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
        // to see the wireframe for each widget.
        //
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'You have pushed the button this many times:',
          ),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      );
    }

    Widget iosScroll(oldalSzam, jelenlegiOldal) {
      var lastSelected = jelenlegiOldal;
      return CupertinoPicker.builder(
        backgroundColor: Colors.white,
        itemExtent: 30,
        childCount: oldalSzam,
        scrollController: FixedExtentScrollController(initialItem: jelenlegiOldal - 1),
        itemBuilder: (context, index) {
          return Text((index + 1).toString());
        },
        onSelectedItemChanged: (value) {
          lastSelected = value + 1;
          print(value + 1);
        },
      );
    }

    iosAlert(oldalSzam, jelenlegiOldal) {
      /*showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(
            "Válassz oldalt!",
          ),
          content: SizedBox(
            child: iosScroll(oldalSzam, jelenlegiOldal),
            height: 200,
          ),
          actions: [
            CupertinoDialogAction(
              child: Text('Ok'),
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
                return 3;
              },
            )
          ],
        ),
      );*/
      Widget sizer(Widget input) {
        return Container(
          //from stackoverflow 216
          // looks godd from me 250
          height: 216,
          padding: const EdgeInsets.only(top: 6.0), // from stack overflow
          child: input,
        );
      }

//!finaé
      showCupertinoModalPopup(
        builder: (context) => sizer(iosScroll(oldalSzam, jelenlegiOldal)),
        context: context,
      );

      //howCupertinoModalPopup(
      // builder: (context) => sizer(
      //   CupertinoDatePicker(
      //     backgroundColor: Colors.white,
      //     onDateTimeChanged: (dateTime) {},
      //   ),
      // ),
      // context: context,
      //;
    }

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            tooltip: 'Display ios style alert',
            onPressed: () {
              showCupertinoDialog(
                  context: context,
                  builder: (_) => CupertinoAlertDialog(
                        title: Text("Test pop-up "),
                        content: Text("Még több fincsi szöveg"),
                        actions: [
                          CupertinoDialogAction(
                            child: Text("Bezár"),
                            isDefaultAction: true,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ));
            },
          ),
        ],
      ),

      body: Container(
        color: Colors.white,
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Padding(
            padding: EdgeInsets.all(50),
            child: Container(child: iosScroll(15, 9)),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //iosAlert(15, 2);
          PDFDocument document = await PDFDocument.fromURL(
              'https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text('Example'),
                        ),
                        body: Center(child: PDFViewer(document: document)),
                      )));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Demo extends StatelessWidget {
  const Demo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _showPicker(BuildContext ctx) {
      showCupertinoModalPopup(
          context: ctx,
          builder: (_) => Container(
                width: 300,
                height: 250,
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  itemExtent: 30,
                  scrollController: FixedExtentScrollController(initialItem: 1),
                  children: [
                    Text('0'),
                    Text('1'),
                    Text('2'),
                  ],
                  onSelectedItemChanged: (value) {},
                ),
              ));
    }

    Widget item() {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 100,
          child: Center(child: Text("asd")),
          color: Colors.blue,
        ),
      );
    }

    return Column(
      children: [
        Flexible(
          flex: 10,
          fit: FlexFit.tight,
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: ListWheelScrollView(
              onSelectedItemChanged: (item) {
                print("item changed");
              },
              useMagnifier: true,
              magnification: 1.2,
              physics: FixedExtentScrollPhysics(),
              clipBehavior: Clip.hardEdge,
              renderChildrenOutsideViewport: false,
              itemExtent: 100,
              diameterRatio: 3,
              children: [item(), item(), item(), item(), item()],
            ),
          ),
        ),
        Divider(),
        Flexible(
            fit: FlexFit.tight,
            flex: 10,
            child: Container(
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                itemExtent: 30,
                scrollController: FixedExtentScrollController(initialItem: 1),
                children: [
                  Text('0'),
                  Text('1'),
                  Text('2'),
                ],
                onSelectedItemChanged: (value) {},
              ),
            )),
        Flexible(
          fit: FlexFit.tight,
          flex: 1,
          child: Container(
              height: MediaQuery.of(context).size.height,
              child: FloatingActionButton(
                child: Icon(Icons.account_tree_rounded),
                onPressed: () {
                  _showPicker(context);
                },
              )),
        ),
      ],
    );
  }
}
