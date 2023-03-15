import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';

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
  ImageProvider img = Image.asset('assets/015_024.png').image;

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
      children: voltarNovo(appState),
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}

class MyHomePage extends StatelessWidget {
  ImageProvider img1 = Image.asset('assets/015_024.png').image;
  ImageProvider img2 = Image.asset('assets/000_000.png').image;
  var imgList = <ImageProvider>[];
  ImageProvider img = Image.asset('assets/015_024.png').image;
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
    if(imgList.isEmpty){
      imgList.add(img1);
      imgList.add(img2);
    }
    
    var appState = context.watch<MyAppState>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text("q saco"),
      ),
      body: Column(
        children: [
          ImageWidget(),
          RadioButtonCreator(imgList: imgList),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => {appState.setNextImage(img2)},),
    );
  }
}



