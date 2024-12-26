import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app/core/error/failures.dart';
import 'package:recipe_app/core/services/image_picker_service.dart';
import 'package:recipe_app/core/usecases/usecase.dart';

class PickImageParams {
  final ImageSource source;
  const PickImageParams({required this.source});
}

class PickImageUseCase implements UseCase<XFile?, PickImageParams> {
  final imageService = ImagePickerService.instance;
  PickImageUseCase._();

  static PickImageUseCase get instance => PickImageUseCase._();

  @override
  Future<Either<Failure, XFile?>> call(PickImageParams params) async {
    return await imageService.pickImage(source: params.source);
  }
}
