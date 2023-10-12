import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_comparator/image_comparator.dart';
import 'package:image_compare_slider/image_compare_slider.dart';
import 'package:collection/collection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double thumbPositionOffset = 0.5;
  ThumbStyle thumbStyle = ThumbStyle.icon;
  List<Color> controlLineColor = [Colors.white, Colors.amber,Colors.teal,Colors.redAccent];
   int selectedColorIndex = 0 ;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 48, bottom: 18),
            child: const Text(
            "Image Comparator View",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ImageComparator(
                  image1: Image.asset("assets/images/before.jpg", fit: BoxFit.cover,),
                  image2: Image.asset("assets/images/after.jpg", fit: BoxFit.cover,),
                  controlLineWidth: 2,
                  controlLineColor: controlLineColor[selectedColorIndex],
                  controlVerticalOffset: thumbPositionOffset,
                  controlThumb: getThumbStyle(thumbStyle, controlColor: controlLineColor[selectedColorIndex]),
                  controlHorizontalOffset: 0.5,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
             children: [
            Row(
                 children: [
                   const Text("Control Color"),
                   const SizedBox(width: 12,),
                   Row(children: controlLineColor.mapIndexed((index, item) => GestureDetector(
                     onTap: ()=> setState(() {
                       selectedColorIndex = index;
                     }),
                     child: Container(
                       decoration: BoxDecoration(
                        color: item,
                         border: Border.all(color: selectedColorIndex == index ? Colors.black: Colors.transparent, width: 2)
                       ),
                       width: 42, height: 42),
                   )).toList(),),
                 ],
               ),
            Row(
              children: [
                const Text("Thumb Position"),
                Expanded(
                  child: Slider(value: thumbPositionOffset, onChanged: (value){
                  setState(() =>thumbPositionOffset = value);
                  }),
                ),
              ],
            ),
            SizedBox(height: 8,),
            Container(height: 1,color: Colors.grey,),
               SizedBox(height: 8,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Custom Thumb Icon"),
                const SizedBox(width: 28,),
                Row(
                  children: ThumbStyle.values.map((item) => GestureDetector(
                    onTap: (){
                      setState(() {
                        thumbStyle = item;
                      });
                    },
                    child: Container(
                      color: item == thumbStyle? Colors.yellow: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Text(item.name),
                    ),
                  )).toList(),
                )
              ],
            )
             ],
            ),
          ),
          const SizedBox(height: 24,),
        ],
      ),
    );
  }

  Widget getThumbStyle(ThumbStyle thumbStyle, {Color controlColor = Colors.white}){
    switch(thumbStyle){
      case ThumbStyle.icon: return  Icon(Icons.circle, color: controlColor,);
      case ThumbStyle.svg: return SvgPicture.asset("assets/images/gesture.svg");
      case ThumbStyle.widget: return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
            border: Border.all(color: controlColor, width: 2),
            borderRadius: BorderRadius.circular(4)
        ),
      );
      case ThumbStyle.image: return Image.asset("assets/images/thumb.png", width: 28, height: 28,);
      case ThumbStyle.text: return  Text("< Slide it >", style: TextStyle(color: controlColor, fontWeight: FontWeight.bold),);
    }
  }
}

enum ThumbStyle{
  icon,
  svg,
  widget,
  image,
  text,
}