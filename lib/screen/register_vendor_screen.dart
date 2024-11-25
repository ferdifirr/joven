import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joven/routes.dart';
import 'package:joven/utils/asset.dart';
import 'package:joven/utils/log.dart';
import 'package:joven/widget/map_widget.dart';

class RegisterVendorScreen extends StatefulWidget {
  const RegisterVendorScreen({super.key});

  @override
  State<RegisterVendorScreen> createState() => _RegisterVendorScreenState();
}

class _RegisterVendorScreenState extends State<RegisterVendorScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  File? _audioFile;
  PlayerState _playerState = PlayerState.stopped;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      Log.d("Image picker error: $e");
    }
  }

  Future<void> _pickAudioFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _audioFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      Log.d("Error picking audio file: $e");
    }
  }

  Future<void> _playAudio() async {
    if (_playerState == PlayerState.playing) {
      await _audioPlayer.pause();
      setState(() {
        _playerState = PlayerState.paused;
      });
    } else if (_audioFile != null) {
      await _audioPlayer.play(DeviceFileSource(_audioFile!.path));
      setState(() {
        _playerState = PlayerState.playing;
      });
    }
  }

  _showPreviewDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: InteractiveViewer(
            child: Image.file(
              _image!,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Image.asset(Asset.logo),
          ),
          const SizedBox(height: 20),
          Text(
            'Create Business Account',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Business Name',
                      prefixIcon: Icon(Icons.business),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _descController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      prefixIcon: Icon(Icons.description),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    onTap: () async {
                      final Map<String, dynamic>? selectedPosition =
                          await showDialog(
                        context: context,
                        builder: (context) {
                          return const Dialog.fullscreen(
                            child: MapWidget(),
                          );
                        },
                      );
                      if (selectedPosition != null) {
                        _addressController.text =
                            '${selectedPosition['address']}';
                      }
                    },
                    controller: _addressController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Business Image',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_image == null) {
                        _pickImage(ImageSource.gallery);
                      } else {
                        _showPreviewDialog();
                      }
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.blueAccent,
                              width: 2,
                            ),
                          ),
                          child: _image == null
                              ? const Center(
                                  child: Text('No image selected'),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _image!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Positioned(
                          right: 2,
                          top: 2,
                          child: GestureDetector(
                            onTap: () {
                              if (_image == null) {
                                _pickImage(ImageSource.gallery);
                              } else {
                                setState(() {
                                  _image = null;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _image == null
                                    ? Icons.add_a_photo
                                    : Icons.remove_circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Audio',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _pickAudioFile,
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.blueAccent,
                          width: 2,
                        ),
                      ),
                      child: _audioFile != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: _playAudio,
                                  icon: Icon(
                                    _playerState == PlayerState.playing
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "File: ${_audioFile!.path.split('/').last}",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.audiotrack),
                                Text(
                                  'Upload Audio',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                    ),
                  ),
                  Text(
                    'Audio file will be used as a background music for the business profile. When the user opens the business profile, the audio will be played and notification will be shown to the user when you near the user.',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.red,
                        ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // _registerUser();
                      Navigator.pushNamed(context, Routes.home);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Create Account'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
