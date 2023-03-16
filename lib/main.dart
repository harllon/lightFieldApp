import 'package:flutter/material.dart';
//import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:math';

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

  List<Radio<ImageProvider>> CreateRadioList(MyAppState state, int i){
    print(i);
    var radioList = <Radio<ImageProvider>>[];
    var n = sqrt(imgList.length).toInt();
    for(var image in imgList.sublist(i, i+n)){
      radioList.add(Radio(value: image, groupValue: state.img, onChanged: state.setNextImage ));
    }
    
    return radioList;
  }

  @override
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for(var i = 0 ; i < imgList.length; i = i + sqrt(imgList.length).toInt())
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: CreateRadioList(appState, i),
          )
      ]
    );
  }
}

class MyHomePage extends StatelessWidget {
  ImageProvider img1 = Image.asset('assets/airplane/000_000.png').image;
  ImageProvider img2 = Image.asset('assets/airplane/000_007.png').image;
  ImageProvider img = Image.asset('assets/airplane/001_0005.png').image;
  var imgList = <ImageProvider>[];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    Future<List<String>> loadImagesPath() async {
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
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text("q saco"),
      ),
      body: Column(
        children: [
          ImageWidget(),
          FutureBuilder(
            future: loadImagesPath(),
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
                   return RadioButtonCreator(imgList: imgList);
                }
                return RadioButtonCreator(imgList: imgList);
              }else{
                return Text('TEM NADA');
              }
            }
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => {appState.setNextImage(img2)},),
    );
  }
}



