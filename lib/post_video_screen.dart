import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_video_upload/encoding_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class PostVideoScreen extends StatefulWidget {
  @override
  _PostVideoScreenState createState() => _PostVideoScreenState();
}

class _PostVideoScreenState extends State<PostVideoScreen> {
  bool _uploading = false;
  VideoInfo _videoInfo;
  double _progress = 0.0;
  int _videoDuration = 0;
  final thumbWidth = 100;
  final thumbHeight = 150;

  @override
  void initState() {
    ///init encoding provider
    EncodingProvider.enableStatisticsCallback((int time,
        int size,
        double bitrate,
        double speed,
        int videoFrameNumber,
        double videoQuality,
        double videoFps) {
      setState(() {
        _progress = time / _videoDuration;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Create a post', style: Theme.of(context).textTheme.headline6),

            ///video controller
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  border: Border.all(width: 1, color: Colors.grey)),
              clipBehavior: Clip.antiAlias,
              child: Center(
                  child: _uploading
                      ? ProgressBar(progress: _progress)
                      : _videoInfo == null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MaterialButton(
                                  onPressed: () => _getVideo(),
                                  color: Colors.blue,
                                  shape: CircleBorder(),
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.video_collection_sharp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text('Pick video')
                              ],
                            )
                          : Image.file(
                              File(_videoInfo.thumbUrl),
                              fit: BoxFit.cover,
                            )),
            )
          ],
        ),
      ),
    );
  }

  _getVideo() async {
    ///you can change source to camera or gallery
    var videoFile = await ImagePicker().getVideo(source: ImageSource.camera);
    if (videoFile == null) return;
    setState(() {
      _uploading = true;
    });
  }

  _processVideo(File rawVideoFile) async {
    final String rand = '${new Random().nextInt(10000)}';
    final videoName = 'video$rand';
    final Directory extDir = await getApplicationDocumentsDirectory();
    final outDirPath = '${extDir.path}/Videos/$videoName';
    final videosDir = new Directory(outDirPath);
    videosDir.createSync(recursive: true);

    final rawVideoPath = rawVideoFile.path;
    final info = await EncodingProvider.getMediaInformation(rawVideoPath);
    final aspectRatio =
        EncodingProvider.getAspectRatio(info.getMediaProperties());

    setState(() {
      _videoDuration = EncodingProvider.getDuration(info.getMediaProperties());
      _progress = 0.0;
    });

    final thumbFilePath =
        await EncodingProvider.getThumb(rawVideoPath, thumbWidth, thumbHeight);

    setState(() {
      _progress = 0.0;
    });
    final videoUrl = await _uploadFile(rawVideoPath, 'video');

    _videoInfo = VideoInfo(
      videoUrl: videoUrl,
      thumbUrl: thumbFilePath,
      aspectRatio: aspectRatio,
      uploadedAt: Timestamp.now(),
      videoName: videoName,
    );
  }

  void _onUploadProgress(TaskSnapshot event) {
    if (event.state == TaskState.running) {
      final double progress = event.bytesTransferred / event.totalBytes;
      setState(() {
        _progress = progress;
      });
    }
  }

  Future<String> _uploadFile(filePath, folderName) async {
    final file = new File(filePath);
    final basename = p.basename(filePath);
    final dir = 'post_video';

    final Reference ref = FirebaseStorage.instance
        .ref()
        .child(dir)
        .child(folderName)
        .child(basename);
    UploadTask uploadTask = ref.putFile(file);
    uploadTask.snapshotEvents.listen(_onUploadProgress);
    String videoUrl = '';
    await uploadTask
        .then((ts) async => videoUrl = await ts.ref.getDownloadURL());
    return videoUrl;
  }

  String getFileExtension(String fileName) {
    final exploded = fileName.split('.');
    return exploded[exploded.length - 1];
  }
}

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    Key key,
    @required double progress,
  })  : _progress = progress,
        super(key: key);

  final double _progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: LinearProgressIndicator(
        value: _progress,
      ),
    );
  }
}

class VideoInfo {
  String videoUrl;
  String thumbUrl;
  double aspectRatio;
  String videoName;
  Timestamp uploadedAt;

  VideoInfo(
      {this.videoUrl,
      this.aspectRatio,
      this.videoName,
      this.uploadedAt,
      this.thumbUrl});
}
