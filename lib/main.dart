import 'dart:io';

import 'package:choose_images/utility/AppColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

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
        primarySwatch: Colors.blue,
      ),
      home: ChooseImages(),
    );
  }
}

class ChooseImages extends StatefulWidget {
  const ChooseImages({Key key}) : super(key: key);

  @override
  _ChooseImagesState createState() => _ChooseImagesState();
}

class _ChooseImagesState extends State<ChooseImages> {
  List<File> images = [];
  List<Asset> selectedAssets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Images"),
      ),
      body: body(),
    );
  }

  Widget body() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Images"),
          SizedBox(
            height: 16,
          ),
          imagePickerView(),
          images.length == 0 ? Spacer() : selectedImagesView(),
        ],
      ),
    );
  }

  Widget selectedImagesView() {
    return Container(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: 16,
          bottom: 16,
        ),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(images.length, (index) {
            return selectedImageItemView(index);
          }),
        ),
      ),
    );
  }

  Widget imagePickerView() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(
          color: Colors.grey,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            TextButton(
              onPressed: () {
                loadAssets();
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: 12,
                ),
                alignment: Alignment.center,
                child: Text(
                  "Choose files",
                ),
              ),
            ),
            VerticalDivider(
              color: Colors.grey,
              thickness: 2,
              width: 0,
            ),
            Expanded(
              child: Text(
                (images.length == 0 ? "No" : images.length.toString()) +
                    " image" +
                    (images.length <= 1 ? "" : "s") +
                    " selected",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }

  loadAssets() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text("Select Profile Picture"),
          message: Text("Select from"),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                await ImagePicker()
                    .pickImage(source: ImageSource.camera)
                    .then((value) {
                  if (value != null) {
                    images.add(File(value.path));
                  } else {
                    print('No image selected.');
                  }
                  _notify();
                }).catchError((onError) {
                  print(onError);
                });
              },
              child: Text("Camera"),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                List<Asset> resultList = [];
                try {
                  resultList = await MultiImagePicker.pickImages(
                    maxImages: 10,
                    enableCamera: false,
                    selectedAssets: selectedAssets,
                    cupertinoOptions: CupertinoOptions(
                      takePhotoIcon: "chat",
                    ),
                    materialOptions: MaterialOptions(
                      actionBarColor: "#42C25E",
                      actionBarTitle: "BackyardCart",
                      allViewTitle: "All Photos",
                      useDetailsView: false,
                      selectCircleStrokeColor: "#000000",
                    ),
                  );
                } on Exception catch (e) {
                  print(e.toString());
                }

                if (!mounted) return;

                selectedAssets = resultList;
                _notify();

                await Future.forEach(selectedAssets, (Asset element) async {
                  var path = await FlutterAbsolutePath.getAbsolutePath(
                      element.identifier);
                  images.add(File(path));
                  _notify();
                });
                _notify();
              },
              child: Text("Gallery"),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
        );
      },
    );
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }

  Widget selectedImageItemView(int index) {
    return Container(
      child: Stack(
        overflow: Overflow.visible,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Colors.grey,
                width: 2,
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(
                  images[index],
                ),
              ),
            ),
            margin: EdgeInsets.only(
              right: 16,
            ),
          ),
          Positioned(
            right: -8,
            top: -22,
            child: IconButton(
              icon: CircleAvatar(
                backgroundColor: Colors.redAccent,
                radius: 12,
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              onPressed: () {
                images.removeAt(index);
                _notify();
              },
            ),
          )
        ],
      ),
    );
  }
}
