import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app/core/error/failures.dart';
import 'package:recipe_app/core/services/image_picker_service.dart';
import 'package:recipe_app/core/usecases/usecase.dart';

class UploadImageParams {
  final XFile image;
  final String path;
  const UploadImageParams({required this.path, required this.image});
}

class UploadImageUseCase implements UseCase<String, UploadImageParams> {
  final imageService = ImagePickerService.instance;
  UploadImageUseCase._();

  static UploadImageUseCase get instance => UploadImageUseCase._();

  @override
  Future<Either<Failure, String>> call(UploadImageParams params) async {
    return await imageService.uploadImage(path: params.path, image: params.image);
  }
}
