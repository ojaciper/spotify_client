import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spotify_clone/core/themes/app_pallete.dart';
import 'package:flutter_spotify_clone/core/utils.dart';
import 'package:flutter_spotify_clone/core/widget/custom_field.dart';
import 'package:flutter_spotify_clone/core/widget/loader.dart';
import 'package:flutter_spotify_clone/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter_spotify_clone/features/home/repository/home_remote_repository.dart';
import 'package:flutter_spotify_clone/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter_spotify_clone/features/home/views/widgets/audio_wave.dart';

class UploadSongScreen extends ConsumerStatefulWidget {
  const UploadSongScreen({super.key});

  @override
  ConsumerState<UploadSongScreen> createState() => _UploadSongScreenState();
}

class _UploadSongScreenState extends ConsumerState<UploadSongScreen> {
  final _songNameController = TextEditingController();
  final _artistController = TextEditingController();
  Color _selectedColor = Pallete.cardColor;
  File? selectedImage;
  File? selectedAudio;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _songNameController.dispose();
    _artistController.dispose();
    super.dispose();
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  void selectAudio() async {
    final pickedAudio = await pickAudio();
    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      homeViewmodelProvider.select((s) => s.isLoading),
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Upload Song"),
        actions: [
          IconButton(
            onPressed: () {
              if (formKey.currentState!.validate() &&
                  selectedAudio != null &&
                  selectedImage != null) {
                ref
                    .read(homeViewmodelProvider.notifier)
                    .uploadSong(
                      selectedAudio: selectedAudio!,
                      selectThumbnail: selectedImage!,
                      songName: _songNameController.text,
                      artist: _artistController.text,
                      selectedColor: _selectedColor,
                    );
              } else {
                showSnackBar(context, "Missing fields");
              }
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: selectImage,
                        child: selectedImage != null
                            ? SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : DottedBorder(
                                options: RoundedRectDottedBorderOptions(
                                  radius: Radius.circular(10),
                                  strokeCap: StrokeCap.round,
                                  color: Pallete.borderColor,
                                  strokeWidth: 2,
                                  dashPattern: [4, 10],
                                ),
                                child: SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.folder_open, size: 40),
                                      const SizedBox(height: 15),
                                      Text(
                                        "Select the thumbnail for your song",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 40),
                      selectedAudio != null
                          ? AudioWave(path: selectedAudio!.path)
                          : CustomField(
                              controller: null,
                              hintText: "Pick Song",
                              readOnly: true,
                              onTap: selectAudio,
                            ),
                      const SizedBox(height: 20),
                      CustomField(
                        controller: _artistController,
                        hintText: "Artist",
                      ),
                      const SizedBox(height: 20),
                      CustomField(
                        controller: _songNameController,
                        hintText: "Song Name",
                      ),
                      const SizedBox(height: 20),
                      ColorPicker(
                        pickersEnabled: {ColorPickerType.wheel: true},
                        color: _selectedColor,
                        onColorChanged: (Color color) {
                          setState(() {
                            _selectedColor = color;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
