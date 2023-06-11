import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

const String apiUrl = "localhost:5000";

List<Song> songs = [];
List<Song> downloaded = [];

class Song {
  String id;
  String title;
  String? text;

  Song({required this.id, required this.title, this.text});

  String get toStringJson {
    return jsonEncode({
      "id": id,
      "title": title,
      "text": text,
    });
  }
}

Future<void> downloadSong({required Song song}) async {
  if (downloaded.contains(song)) {
    return;
  }

  if (song.text == null) {
    await loadSong(song: song);
  }

  await Future.delayed(const Duration(seconds: 2));

  downloaded.add(song);

  await saveDownloaded();
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
    if (!downloaded.contains(Song(id: song["id"], title: song["title"]))) {
      songs.add(
        Song(
          id: song["id"],
          title: song["title"],
        ),
      );
    }
  }
}

Future<void> loadDownloaded() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String> downloadedSongs = prefs.getStringList("downloaded") ?? [];

  for (String song in downloadedSongs) {
    Map<String, dynamic> songMap = jsonDecode(song);

    downloaded.add(
      Song(
        id: songMap["id"],
        title: songMap["title"],
        text: songMap["text"],
      ),
    );
  }

  print("Loaded ${downloaded.length} downloaded songs");
}

Future<void> saveDownloaded() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String> downloadedSongs = [];

  for (Song song in downloaded) {
    downloadedSongs.add(song.toStringJson);
  }

  prefs.setStringList("downloaded", downloadedSongs);
}

Future<void> deleteDownloaded() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.remove("downloaded");
}
