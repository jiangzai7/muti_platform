import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart' as ui2;

class ClipboardService {
  // 复制图片文件到剪贴板
  static Future<bool> copyImageFile(File imageFile) async {
    try {
      final Uint8List imageBytes = await imageFile.readAsBytes();
      return await copyImageData(imageBytes);
    } catch (e) {
      print('复制图片失败: $e');
      return false;
    }
  }

  // 复制图片数据到剪贴板
  static Future<bool> copyImageData(Uint8List imageData) async {
    try {
      final codec = await ui.instantiateImageCodec(imageData);
      final frame = await codec.getNextFrame();
      final image = frame.image;

      // 将图片数据复制到剪贴板
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        // final pngBytes = byteData.buffer.asUint8List();
        // final clipboardData = ui2.ClipboardData(
        //   image: ui2.ClipboardImage(pngBytes),
        // );
        // await ui.Clipboard.setData(clipboardData);
        // return true;
      }
      return false;
    } catch (e) {
      print('复制图片数据失败: $e');
      return false;
    }
  }

  // // 从相册选择并复制图片
  // static Future<bool> copyImageFromGallery() async {
  //   try {
  //     final XFile? image = await ImagePicker().pickImage(
  //       source: ImageSource.gallery,
  //     );

  //     if (image != null) {
  //       final File imageFile = File(image.path);
  //       return await copyImageFile(imageFile);
  //     }
  //     return false;
  //   } catch (e) {
  //     print('从相册复制图片失败: $e');
  //     return false;
  //   }
  // }
}
