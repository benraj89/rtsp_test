import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VLC Recorder',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late VlcPlayerController _videoPlayerController;
  bool _isRecording = false;
  String? _recordedPath;

  @override
  void initState() {
    super.initState();
    _initPermissions();
    _initPlayer();
  }

  void _initPlayer() {
    _videoPlayerController = VlcPlayerController.network(
      'https://media.w3.org/2010/05/sintel/trailer.mp4',
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
  }

  Future<void> _initPermissions() async {
    await [Permission.storage].request();
  }

  Future<String> _getRecordingDirectory() async {
    final directory = Directory('/storage/emulated/0/Download');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory.path;
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _videoPlayerController.stopRecording();
      await Future.delayed(
        Duration(milliseconds: 500),
      ); // Wait for VLC to set path
      final path = _videoPlayerController.value.recordPath;

      setState(() {
        _isRecording = false;
        _recordedPath = path;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saved to: ${_recordedPath ?? "Unknown location"}'),
        ),
      );
    } else {
      final dirPath = await _getRecordingDirectory();
      await _videoPlayerController.startRecording(dirPath);

      setState(() {
        _isRecording = true;
        _recordedPath = null;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Recording started...')));
    }
  }

  @override
  void dispose() {
    _videoPlayerController.stopRendererScanning();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('VLC Recorder')),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: VlcPlayer(
              controller: _videoPlayerController,
              aspectRatio: 16 / 9,
              placeholder: Center(child: CircularProgressIndicator()),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _toggleRecording,
            icon: Icon(
              _isRecording ? Icons.stop : Icons.fiber_manual_record,
              color: _isRecording ? Colors.black : Colors.red,
            ),
            label: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isRecording ? Colors.grey : Colors.redAccent,
            ),
          ),
          if (_recordedPath != null) ...[
            SizedBox(height: 10),
            Text(
              'Saved to:\n$_recordedPath',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.green),
            ),
          ],
        ],
      ),
    );
  }
}
