import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadForm extends StatefulWidget {
  final String authToken;
  final String name;

  UploadForm({required this.authToken, required this.name});

  @override
  _UploadFormState createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  XFile? selectedImage; // Variable untuk menyimpan gambar yang dipilih
  double? lat; // Variabel untuk menyimpan latitude
  double? lon; // Variabel untuk menyimpan longitude

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = image;
    });
  }

  Future<void> _getLocation() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          lat = position.latitude;
          lon = position.longitude;
        });
        print('Latitude: $lat, Longitude: $lon');
      } catch (e) {
        print("Error getting location: $e");
      }
    } else {
      print('Location permission is denied.');
    }
  }

  Future<void> submitForm() async {
    if (selectedImage != null) {
      final url = Uri.parse('https://story-api.dicoding.dev/v1/stories');
      final request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer ${widget.authToken}'
        ..fields['description'] = descriptionController.text
        // ..fields['name'] = nameController.text
        ..fields['lat'] = lat.toString() // Sertakan nilai latitude
        ..fields['lon'] = lon.toString() // Sertakan nilai longitude
        ..files.add(http.MultipartFile(
          'photo',
          File(selectedImage!.path).readAsBytes().asStream(),
          File(selectedImage!.path).lengthSync(),
          filename: selectedImage!.name,
        ));

      final response = await http.Response.fromStream(await request.send());
      print("API RESPONNN : " + response.body);
      print("API RESPONNN : " + response.statusCode.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Berhasil mengunggah gambar
        final responseData = jsonDecode(response.body);
        if (responseData['error'] == false) {
          // Gambar berhasil diunggah
          final message = responseData['message'];
          _showSuccessDialog(message);
        } else {
          // Terjadi kesalahan saat mengunggah gambar
          final errorMessage = responseData['message'];
          _showErrorDialog(errorMessage);
        }
      } else {
        // Terjadi kesalahan saat mengirim permintaan
        _showErrorDialog('Terjadi kesalahan saat mengirim permintaan.');
      }
    } else {
      // Gambar belum dipilih

      _showErrorDialog('Pilih gambar terlebih dahulu.');
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sukses'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                Navigator.of(context)
                    .pop(true); // Tutup UploadForm dan kembalikan nilai `true`
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("GEO LOCATION: $lat, $lon");
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Gambar dan Deskripsi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              Text(
                'Halo, ${widget.name}!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _getLocation(); // Dapatkan lokasi terlebih dahulu
                  _pickImage(); // Pilih gambar setelah lokasi diperoleh
                },
                child: Text('Pilih Gambar'),
              ),
              if (selectedImage != null) ...[
                SizedBox(height: 20),
                Image.file(
                  File(selectedImage!.path),
                  height: 150,
                  width: 150,
                ),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
