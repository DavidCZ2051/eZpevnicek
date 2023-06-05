import 'package:http/http.dart';
import 'dart:convert';

const String apiUrl = "localhost:5000";

List<Song> songs = [];

class Song {
  String id;
  String title;
  String? text;

  Song({required this.id, required this.title, this.text});
}

Future<void> loadSong({required Song song}) async {
  final Response response = await get(
    Uri.parse("http://$apiUrl/pisnicka?song=${song.id}"),
  );

  if (response.statusCode == 404) {
    throw Exception("Failed to find song");
  } else if (response.statusCode != 200) {
    throw Exception("Failed to load song");
  }

  song.text = jsonDecode(response.body)["text"];

  print("Loaded song ${song.title}");
}

Future<void> loadSongs() async {
  final Response response = await get(Uri.http(apiUrl, "/pisnicky"));

  if (response.statusCode != 200) {
    throw Exception("Failed to load songs");
  }

  List songsJson = jsonDecode(response.body)["pisnicky"];

  for (Map song in songsJson) {
    songs.add(
      Song(
        id: song["id"],
        title: song["title"],
      ),
    );
  }
}
