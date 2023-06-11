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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (Song song in songs) SongWidget(song: song),
        ],
      ),
    );
  }
}

class SongWidget extends StatefulWidget {
  SongWidget({super.key, required this.song});

  Song song;

  @override
  State<SongWidget> createState() => _SongWidgetState();
}

class _SongWidgetState extends State<SongWidget> {
  int status = 0;

  @override
  void initState() {
    super.initState();

    if (downloaded.any((song) => song.id == widget.song.id)) {
      setState(() {
        status = 1;
        widget.song =
            downloaded.firstWhere((song) => song.id == widget.song.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SongDetails(song: widget.song),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                widget.song.title,
                style: const TextStyle(fontSize: 16),
              ),
              const Spacer(),
              status == 0
                  ? IconButton(
                      onPressed: () async {
                        setState(() {
                          status = 2;
                        });
                        await downloadSong(song: widget.song);
                        setState(() {
                          status = 1;
                        });
                      },
                      icon: const Icon(Icons.download),
                    )
                  : status == 1
                      ? const Icon(Icons.download_done)
                      : const CircularProgressIndicator(),
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
                  builder: (context) => const BackBone(),
                ),
              );
            },
          ),
          title: Text(widget.song.title),
          backgroundColor: Colors.green,
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

class Downloaded extends StatefulWidget {
  const Downloaded({super.key});

  @override
  State<Downloaded> createState() => _DownloadedState();
}

class _DownloadedState extends State<Downloaded> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          for (Song song in downloaded)
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
          ElevatedButton(
            onPressed: () async {
              await deleteDownloaded();
              setState(() {
                downloaded = [];
              });
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }
}

class BackBone extends StatefulWidget {
  const BackBone({super.key});

  @override
  State<BackBone> createState() => _BackBoneState();
}

class _BackBoneState extends State<BackBone> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentPage,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note),
              label: "Písně",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.download),
              label: "Stažené",
            ),
          ],
          onTap: (index) {
            setState(() {
              currentPage = index;
            });
          },
        ),
        appBar: AppBar(
          title: const Text("Zpěvníček"),
          backgroundColor: Colors.green,
        ),
        body: IndexedStack(
          index: currentPage,
          children: const [
            Songs(),
            Downloaded(),
          ],
        ),
      ),
    );
  }
}
