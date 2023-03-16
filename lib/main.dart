import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(),
      ),
    );
  }

  // This widget is the root of your application.
}


class ImageWidget extends StatefulWidget{
  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget>{
  ImageProvider img = Image.asset('assets/airplane/001_005.png').image;

  void setImage(ImageProvider newImage){
    setState(() {
      img = newImage;
    });
  }
  @override
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>();
    appState.addListener(() => setImage(appState.img));
    return Image(image: img);
  }
}

class MyAppState extends ChangeNotifier {
  var img;

  void setNextImage(ImageProvider? value){
    if(value != null){
        img = value;
    }
    notifyListeners();
  }

}

/*class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}*/
class RadioButtonCreator extends StatefulWidget{
  final List<ImageProvider> imgList;

  const RadioButtonCreator({super.key, required this.imgList}); 
  @override
  // ignore: no_logic_in_create_state
  State<RadioButtonCreator> createState() => _RadioButtonCreatorState(imgList);
}

class _RadioButtonCreatorState extends State<RadioButtonCreator>{
  List<ImageProvider> imgList;
  

  _RadioButtonCreatorState(this.imgList);
  List<Radio<ImageProvider>> voltarNovo(MyAppState state){
    var radioList = <Radio<ImageProvider>>[];
    for(var image in imgList){
      radioList.add(Radio(value: image, groupValue: state.img, onChanged: state.setNextImage ));
    }
    
    return radioList;
  }

  @override
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: voltarNovo(appState),
    );
  }
}

class MyHomePage extends StatelessWidget {
  ImageProvider img1 = Image.asset('assets/airplane/000_000.png').image;
  ImageProvider img2 = Image.asset('assets/airplane/000_007.png').image;
  var imgList = <ImageProvider>[];
  ImageProvider img = Image.asset('assets/airplane/001_0005.png').image;
  late Widget radioButton;
  var k = UniqueKey();

  

  /*List<Radio<ImageProvider>> voltarNovo(MyAppState state){
    var radioList = <Radio<ImageProvider>>[];
    if(_counter != 5){
      for(var image in imgList){
        radioList.add(Radio(value: image, groupValue: img, onChanged: state.setNextImage ));
      }
      _counter++;
    }
    return radioList;
  }*/

  @override
  Widget build(BuildContext context) {

    Future<List<String>> _listAssets() async {
    // Load as String
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

    // Decode to Map
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // Filter by path
    final filtered = manifestMap.keys
        .where((path) => path.startsWith('assets/airplane/') && path != 'assets/airplane/.DS_Store')
        .toList();
    return filtered;
    //print(filtered.length);
  }
    
    var appState = context.watch<MyAppState>();

    //return FutureBuilder(builder: builder)
    
    return Scaffold(
      appBar: AppBar(
        title: Text("q saco"),
      ),
      body: Column(
        children: [
          ImageWidget(),
          FutureBuilder(
            future: _listAssets(),
            builder: (context, AsyncSnapshot<List<String>> snapshot){
              if(snapshot.hasData){
                if(snapshot.data!.isEmpty){
                  return Text('TA VAZIOOOO');
                }
                print(snapshot.data!.length);
                if(imgList.isEmpty){
                  for(var imgPath in snapshot.data!){
                    imgList.add(Image.asset(imgPath).image);
                  } 
                }
                return RadioButtonCreator(imgList: imgList.sublist(0, 7));
              }else{
                return Text('TEM NADA');
              }
            }
            )
          //for(var i = 0; i< 8; i+7)
          //RadioButtonCreator(imgList: imgList.sublist(0, 7))
          //RadioButtonCreator(imgList: imgList),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => {appState.setNextImage(img2)},),
    );
  }
}



