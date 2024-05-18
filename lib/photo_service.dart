import 'dart:convert';
import 'package:http/http.dart' as http;
import 'photo.dart';

class PhotoService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com/photos';

  Future<List<Photo>> fetchPhotos() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<Photo> photos = body.map((dynamic item) => Photo.fromJson(item)).toList();
      return photos;
    } else {
      throw Exception('Failed to load photos');
    }
  }
}
