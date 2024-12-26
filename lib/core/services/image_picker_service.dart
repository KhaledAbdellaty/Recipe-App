import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:recipe_app/core/error/failures.dart';
import 'dart:io';
import '../di/injection_container.dart' as di;

class ImagePickerService {
  final ImagePicker _picker = di.sl<ImagePicker>();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  ImagePickerService._();
  // ImagePickerService(this._picker, this._storage);
  static ImagePickerService get instance => ImagePickerService._();
  Future<Either<Failure, XFile?>> pickImage({
    required ImageSource source,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (image == null) return const Left(ImagePickerFailure("An Error"));

      return Right(image);
    } catch (e) {
      return Left(ImagePickerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> uploadImage({
    required String path,
    required XFile image,
  }) async {
    try {
      final ref = _storage
          .ref()
          .child(path)
          .child('${DateTime.now().toIso8601String()}.jpg');
      await ref.putFile(File(image.path));
      final imagePath = await ref.getDownloadURL();
      return Right(imagePath);
    } catch (e) {
      return Left(ImagePickerFailure(e.toString()));
    }
  }
}
