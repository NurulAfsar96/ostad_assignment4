import 'package:flutter/material.dart';
import 'photo_service.dart';
import 'photo.dart';

void main() {
  runApp(PhotoApp());
}

class PhotoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PhotoListPage(),
    );
  }
}

class PhotoListPage extends StatefulWidget {
  @override
  _PhotoListPageState createState() => _PhotoListPageState();
}

class _PhotoListPageState extends State<PhotoListPage> {
  late Future<List<Photo>> futurePhotos;

  @override
  void initState() {
    super.initState();
    futurePhotos = PhotoService().fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PhotoApp'),
        backgroundColor: Colors.blue[300],
      ),
      body:
      FutureBuilder<List<Photo>>(
        future: futurePhotos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No photos found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Photo photo = snapshot.data![index];
                return ListTile(
                  leading: Image.network(photo.thumbnailUrl),
                  title: Text(photo.title),
                  subtitle: Text('ID: ${photo.id}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhotoDetailPage(photo: photo),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class PhotoDetailPage extends StatelessWidget {
  final Photo photo;

  PhotoDetailPage({required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Photo Details"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(photo.url),
            SizedBox(height: 16),
            Text(photo.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('ID: ${photo.id}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
