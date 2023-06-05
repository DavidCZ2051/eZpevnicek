import 'package:flutter/material.dart';
import 'package:zpevnicek/logic.dart';

class Songs extends StatefulWidget {
  const Songs({super.key});

  @override
  State<Songs> createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Zpěvníček"),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              for (Song song in songs)
                ListTile(
                  title: Text(song.title),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SongDetails(song: song),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SongDetails extends StatefulWidget {
  const SongDetails({super.key, required this.song});

  final Song song;

  @override
  State<SongDetails> createState() => _SongDetailsState();
}

class _SongDetailsState extends State<SongDetails> {
  @override
  void initState() {
    super.initState();

    if (widget.song.text == null) {
      load();
    }
  }

  void load() async {
    await loadSong(song: widget.song);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Songs(),
                ),
              );
            },
          ),
          title: Text(widget.song.title),
          backgroundColor: Colors.green[400],
        ),
        body: widget.song.text == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.song.text!),
                ),
              ),
      ),
    );
  }
}
