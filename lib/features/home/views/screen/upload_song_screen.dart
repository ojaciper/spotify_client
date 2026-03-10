import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spotify_clone/core/themes/app_pallete.dart';
import 'package:flutter_spotify_clone/core/widget/custom_field.dart';

class UploadSongScreen extends ConsumerStatefulWidget {
  const UploadSongScreen({super.key});

  @override
  ConsumerState<UploadSongScreen> createState() => _UploadSongScreenState();
}

class _UploadSongScreenState extends ConsumerState<UploadSongScreen> {
  final _songNameController = TextEditingController();
  final _artistController = TextEditingController();
  Color _selectedColor = Pallete.cardColor;
  @override
  void dispose() {
    _songNameController.dispose();
    _artistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Upload Song"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.check))],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              DottedBorder(
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
              const SizedBox(height: 40),
              CustomField(
                controller: null,
                hintText: "Pick Song",
                readOnly: true,
                onTap: () {},
              ),
              const SizedBox(height: 20),
              CustomField(controller: _artistController, hintText: "Artist"),
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
    );
  }
}
