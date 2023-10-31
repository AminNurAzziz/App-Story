import 'package:flutter/material.dart';

class DetailStory extends StatefulWidget {
  final String? authToken; // Parameter authToken
  final Map<String, dynamic>? story; // Parameter story
  const DetailStory({Key? key, this.authToken, this.story}) : super(key: key);

  @override
  State<DetailStory> createState() => _DetailStoryState();
}

class _DetailStoryState extends State<DetailStory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Kembali ke halaman ListStory
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.grey[100]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget
                  .story?['photoUrl'], // Gunakan URL gambar dari detail cerita
              width: double.infinity,
              height: 500,
              fit: BoxFit.cover,
            ),
            Container(
              margin: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.story?['name'], // Gunakan judul dari detail cerita
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.story?[
                        'description'], // Gunakan deskripsi dari detail cerita
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
