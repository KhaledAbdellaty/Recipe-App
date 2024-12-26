import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/features/recipes/presentation/cubit/recipe_cubit.dart';
import '../../../../core/presentation/widgets/image_picker_bottom_sheet.dart';

class ProfileDrawer extends StatelessWidget {
  ProfileDrawer({
    super.key,
  });
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String userName = '';
    final cubit = RecipeCubit.of(context);
    return Form(
      key: _formKey,
      child: Container(
        width: MediaQuery.of(context).size.width / 1.2,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close))
                ],
              ),
            ),
            const Divider(),
            Expanded(
                child: SingleChildScrollView(
                    child: Column(
              children: [
                Stack(
                  children: [
                    BlocBuilder<RecipeCubit, RecipeState>(
                      builder: (context, state) {
                        return CircleAvatar(
                          radius: 50,
                          backgroundImage: state is RecipeImageLoaded
                              ? Image.file(state.image).image
                              : CachedNetworkImageProvider(
                                  cubit.user!.profilePictureUrl ??
                                      'https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250',
                                ),
                        );
                      },
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        width: 30,
                        height: 30,
                        child: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: ImagePickerBottomSheet(
                                    onSourceSelected: (source) {
                                      cubit.pickImage(source: source);
                                      cubit.uploadProfileImage();
                                    },
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                              size: 15,
                            )),
                      ),
                    )
                  ],
                ),
                TextFormField(
                  // controller: controller,
                  initialValue: cubit.user!.username,
                  decoration: InputDecoration(labelText: 'User name'),
                  onSaved: (value) {
                    userName = value!;
                  },
                ),
                OutlinedButton(
                    onPressed: () {
                      _formKey.currentState!.save();
                      cubit.updateProfile(userName);
                    },
                    child: const Text('Update'))
              ],
            )))
          ],
        ),
      ),
    );
  }
}
