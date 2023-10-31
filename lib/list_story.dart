import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:story/detail_story.dart';
import 'package:story/addStory.dart';
import 'package:story/google_maps.dart';

class ListStory extends StatefulWidget {
  final String? authToken; // Parameter authToken
  final String? name; // Parameter name

  const ListStory({Key? key, this.authToken, this.name}) : super(key: key);

  @override
  State<ListStory> createState() => _ListStoryState();
}

class _ListStoryState extends State<ListStory> {
  List<dynamic> stories = []; // Daftar cerita dari API

  @override
  void initState() {
    super.initState();
    if (widget.authToken != null) {
      fetchStories(); // Memuat data cerita saat halaman dimuat
    } else {
      print('Token tidak tersedia');
    }
  }

  // Method untuk mengambil data cerita dari API
  Future<void> fetchStories() async {
    final response = await http.get(
      Uri.parse('https://story-api.dicoding.dev/v1/stories?location=0'),
      headers: {
        'Authorization': 'Bearer ${widget.authToken!}',
      },
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        stories = responseData['listStory'];
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 18, 28, 49),
        title: Text(
          'AZZ Story',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.map,
              color: Colors.white,
            ),
            onPressed: () {
              // Tambahkan ini
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapScreen(
                    latitude: -6.1753924,
                    longitude: 106.8271528,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 230, 240, 255),
        ),
        child: ListView.builder(
          itemCount: stories.length,
          itemBuilder: (context, index) {
            final story = stories[index];
            print(stories.length);
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailStory(
                      authToken: widget.authToken,
                      story: story,
                    ),
                  ),
                );
              },
              child: Card(
                margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      height: 120,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        child: Image.network(
                          story[
                              'photoUrl'], // Gunakan URL gambar dari data cerita
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        story['name'],
                        maxLines: 1, // Atur jumlah baris maksimum untuk judul
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ), // Menampilkan elipsis jika teks terlalu panjang
                      ),
                      subtitle: Text(
                        story['description'],
                        maxLines:
                            2, // Atur jumlah baris maksimum untuk subtitle
                        overflow: TextOverflow
                            .ellipsis, // Menampilkan elipsis jika teks terlalu panjang
                      ),
                      trailing: Icon(Icons.more_vert),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 18, 28, 49),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UploadForm(
                authToken: widget.authToken!,
                name: widget.name!,
              ),
            ),
          ).then((_) => fetchStories()); // Tambahkan ini
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
