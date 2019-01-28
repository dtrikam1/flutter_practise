import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import './CustomVisionResponse.dart';
import 'dart:convert';

class CameraPage extends StatefulWidget {
  @override
  _CameraState createState() => new _CameraState();
}

class _CameraState extends State<CameraPage> {
  File _image;
  String _response = "";

  Future fetchPost() async {
    final response = await http.post(
        'https://southcentralus.api.cognitive.microsoft.com/customvision/v2.0/Prediction/8d606170-e62e-4a6c-b6a0-0842af311d8d/image?iterationId=1a4382c0-87b9-4078-acba-4a7b0c53ef1d',
        headers: {
          "Prediction-Key": 'ad50d3fc9c2d401699e38851d71d7ef3',
          'Content-Type': "application/octet-stream"
        },
        body: _image.readAsBytesSync());

    print(response.statusCode);

    if (response.statusCode == 200) {
      // If the call to the server was successful

      var customVisionResponse =
          CustomVisionResponse.fromJson(json.decode(response.body));

      List<Predictions> predictions = customVisionResponse.predictions;

      var probability = 0.0;
      var tagName = "";

      for (var i = 0; i < predictions.length; i++) {
        if (predictions[i].probability > probability) {
          probability = predictions[i].probability;
          tagName = predictions[i].tagName;

          print(predictions[i].probability);
        }
      }

      setState(() {
        _response = tagName;
      });
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
    fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Camera Screen"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              new RaisedButton(
                child: const Text('Take Photo'),
                color: Theme.of(context).accentColor,
                elevation: 4.0,
                splashColor: Colors.blueGrey,
                onPressed: () {
                  // Perform some action
                  getImage();
                },
              ),
              _image == null
                  ? new Text('No image selected')
                  : new Image.file(_image),
              new Text(_response),
            ],
          ),
        ));
  }
}
