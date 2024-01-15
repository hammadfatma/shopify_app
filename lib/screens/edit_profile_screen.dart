import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shopify_app/providers/profile_provider.dart';
import 'package:shopify_app/utils/constants.dart';
import 'package:shopify_app/widgets/custom_appbar_widget.dart';
import 'package:shopify_app/widgets/custom_button_icon.dart';
import 'package:shopify_app/widgets/custom_text_field.dart';
import 'dart:io';
import 'package:quickalert/quickalert.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    Provider.of<ProfileProvider>(context, listen: false).createProfileInstance();
    super
        .initState(); // every time open details create instance of cartItem was empty but adding was in firebase
  }
  late TextEditingController nameController = TextEditingController();
  late TextEditingController phoneController = TextEditingController();
  String imageUrl = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackColor,
      appBar: CustomAppBarWidget(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  var file = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (file == null) return;
                  String fileName =
                      DateTime.now().microsecondsSinceEpoch.toString();
                  Reference referenceRoot = FirebaseStorage.instance.ref();
                  Reference referenceDireImages =
                      referenceRoot.child('profiles');
                  Reference referenceImageToUpload =
                      referenceDireImages.child(fileName);
                  try {
                    await referenceImageToUpload.putFile(File(file.path),
                        SettableMetadata(contentType: 'image/png'));
                    imageUrl = await referenceImageToUpload.getDownloadURL();
                    print('Image URL: $imageUrl');
                  } catch (e) {
                    if (context.mounted) {
                      await QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        title: 'Oops...',
                        text: e.toString(),
                      );
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [kPrimaryColor, kSecondaryColor],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  width: 100.0,
                  height: 100.0,
                  child: Center(
                    child: Icon(
                      Icons.image_outlined,
                      color: kWhiteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              CustomTxtFieldWidget(
                isFirst: true,
                isLast: false,
                txt: 'Name',
                con: Icons.person_outlined,
                controller: nameController,
                inputType: TextInputType.name,
              ),
              CustomTxtFieldWidget(
                isFirst: false,
                isLast: true,
                txt: 'Phone',
                con: Icons.phone_outlined,
                controller: phoneController,
                inputType: TextInputType.phone,
              ),
              const SizedBox(
                height: 40,
              ),
              CustomButtonWidget(
                  txt: 'SAVE',
                  onTap: () {
                    Provider.of<ProfileProvider>(context, listen: false)
                        .profileData
                        ?.imageUrl = imageUrl;
                    Provider.of<ProfileProvider>(context, listen: false)
                        .profileData
                        ?.name = nameController.text;
                    Provider.of<ProfileProvider>(context, listen: false)
                        .profileData
                        ?.phone = phoneController.text;
                    Provider.of<ProfileProvider>(context, listen: false)
                        .saveDataToProfile(context: context);
                  },
                  width: 330),
            ],
          ),
        ],
      ),
    );
  }
}
