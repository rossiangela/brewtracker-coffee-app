import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
class ImageUtils {
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 80,
      );
      
      if (image != null) {
        return await _saveImageToAppDirectory(image);
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
    }
    return null;
  }

  static Future<String?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 80,
      );
      
      if (image != null) {
        return await _saveImageToAppDirectory(image);
      }
    } catch (e) {
      print('Error picking image from camera: $e');
    }
    return null;
  }

  static Future<String> _saveImageToAppDirectory(XFile image) async {
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(path.join(appDir.path, 'coffee_images'));
    
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(image.path)}';
    final savedImagePath = path.join(imagesDir.path, fileName);
    
    await File(image.path).copy(savedImagePath);
    return savedImagePath;
  }

  static Widget buildImageWidget(String imagePath, {double? width, double? height, BoxFit? fit}) {
    return Image.file(
      File(imagePath),
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: const Icon(Icons.coffee, size: 32),
        );
      },
    );
  }

  static Future<void> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting image: $e');
    }
  }
}
