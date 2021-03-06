import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../utils/services/face_recognition_api.dart';

class FaceRecognitionRepository {
  final FaceRecognitionDio _faceRecogInstance = FaceRecognitionDio.instance;

  Future<String> addImage(
      {@required String pid, @required String imagePath}) async {
    Response response = await _faceRecogInstance.uploadImage(
      pid: pid,
      imagePath: imagePath,
    );

    if (response.data.containsKey('error')) return response.data['message'];
    return response.data['link'];
  }

  Future<String> deleteImage({@required String pid}) async {
    Response response = await _faceRecogInstance.deleteImage(pid: pid);
    if (response.data.containsKey('error')) return response.data['message'];
    return response.data['deleted'];
  }

  Future<String> updateImage(
      {@required String pid, @required String imagePath}) async {
    return addImage(pid: pid, imagePath: imagePath);
  }

  Future<dynamic> recognizeImage({@required String imagePath}) async {
    Response response =
        await _faceRecogInstance.recognizeImage(imagePath: imagePath);

    if (response.data.containsKey('error')) return response.data['message'];

    return response.data['pids'];
  }

  Future<dynamic> isValidImage({@required String imagePath}) async {
    Response response =
        await _faceRecogInstance.isValidImage(imagePath: imagePath);

    if (response.data.containsKey('error')) return response.data['message'];
    return response.data['valid'];
  }
}
