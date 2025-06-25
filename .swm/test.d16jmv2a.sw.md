---
title: Test
---
# Introduction

This document will walk you through the implementation of RTSP stream recording in a Flutter app. The purpose is to enable recording of video streams and saving them locally on Android devices.

We will cover:

1. Overview of the module's purpose and technology stack.
2. Key features implemented in the code.
3. Explanation of the main file structure.

# Overview

The module is designed for recording RTSP streams using Flutter. It leverages the <SwmToken path="/lib/main.dart" pos="4:5:5" line-data="import &#39;package:flutter_vlc_player/flutter_vlc_player.dart&#39;;">`flutter_vlc_player`</SwmToken> plugin for video playback and recording functionalities. The target platform is Android, with iOS support being experimental.

# Key features

## Connect to RTSP stream URL

<SwmSnippet path="/lib/main.dart" line="39">

---

The application connects to an RTSP stream URL using the <SwmToken path="/lib/main.dart" pos="40:5:5" line-data="    _videoPlayerController = VlcPlayerController.network(">`VlcPlayerController`</SwmToken>. This is initialized with the stream URL and configured to auto-play the video.

```
  void _initPlayer() {
    _videoPlayerController = VlcPlayerController.network(
      'https://media.w3.org/2010/05/sintel/trailer.mp4',
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
  }
```

---

</SwmSnippet>

## Display live preview

<SwmSnippet path="/lib/main.dart" line="100">

---

The live preview of the video stream is displayed using the <SwmToken path="/lib/main.dart" pos="108:4:4" line-data="            child: VlcPlayer(">`VlcPlayer`</SwmToken> widget. It is embedded within a <SwmToken path="/lib/main.dart" pos="102:3:3" line-data="    return Scaffold(">`Scaffold`</SwmToken> to provide a user interface for video playback.

```
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
```

---

</SwmSnippet>

## Record the stream and save to local storage

<SwmSnippet path="/lib/main.dart" line="60">

---

Recording functionality is toggled using a button. The <SwmToken path="/lib/main.dart" pos="60:6:6" line-data="  Future&lt;void&gt; _toggleRecording() async {">`_toggleRecording`</SwmToken> method handles starting and stopping the recording, saving the recorded file to local storage.

```
  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _videoPlayerController.stopRecording();
      await Future.delayed(
        Duration(milliseconds: 500),
      ); // Wait for VLC to set path
      final path = _videoPlayerController.value.recordPath;
```

---

</SwmSnippet>

<SwmSnippet path="/lib/main.dart" line="78">

---

&nbsp;

```
    } else {
      final dirPath = await _getRecordingDirectory();
      await _videoPlayerController.startRecording(dirPath);
```

---

</SwmSnippet>

## Show recording status and saved location

<SwmSnippet path="/lib/main.dart" line="73">

---

The application provides feedback on recording status and the location where the video is saved using <SwmToken path="/lib/main.dart" pos="74:1:1" line-data="        SnackBar(">`SnackBar`</SwmToken> notifications.

```
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saved to: ${_recordedPath ?? "Unknown location"}'),
        ),
      );
```

---

</SwmSnippet>

<SwmSnippet path="/lib/main.dart" line="87">

---

&nbsp;

```
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Recording started...')));
    }
  }
```

---

</SwmSnippet>

# Folder / file structure

## <SwmPath>[lib/main.dart](/lib/main.dart)</SwmPath>: Entry point, UI

<SwmSnippet path="/lib/main.dart" line="11">

---

The <SwmPath>[lib/main.dart](/lib/main.dart)</SwmPath> file serves as the entry point of the application. It sets up the UI and initializes the video player and permissions.

```
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
```

---

</SwmSnippet>

## rtsp_recorder.dart: Logic for starting/stopping recording

<SwmSnippet path="/lib/main.dart" line="60">

---

The logic for recording is encapsulated within the <SwmToken path="/lib/main.dart" pos="60:6:6" line-data="  Future&lt;void&gt; _toggleRecording() async {">`_toggleRecording`</SwmToken> method. It manages the recording state and interacts with the <SwmToken path="/lib/main.dart" pos="40:5:5" line-data="    _videoPlayerController = VlcPlayerController.network(">`VlcPlayerController`</SwmToken> to start and stop recording.

```
  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _videoPlayerController.stopRecording();
      await Future.delayed(
        Duration(milliseconds: 500),
      ); // Wait for VLC to set path
      final path = _videoPlayerController.value.recordPath;
```

---

</SwmSnippet>

## platform_channel.dart: Native platform integration (if applicable)

While the current implementation does not explicitly use platform channels, the <SwmToken path="/lib/main.dart" pos="4:5:5" line-data="import &#39;package:flutter_vlc_player/flutter_vlc_player.dart&#39;;">`flutter_vlc_player`</SwmToken> plugin handles native integrations for video playback and recording on Android.

<SwmMeta version="3.0.0" repo-id="Z2l0aHViJTNBJTNBcnRzcF90ZXN0JTNBJTNBYmVucmFqODk=" repo-name="rtsp_test"><sup>Powered by [Swimm](https://app.swimm.io/)</sup></SwmMeta>
