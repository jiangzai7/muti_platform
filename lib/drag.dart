import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DragDropReceiver extends StatefulWidget {
  final Function(List<File>)? onFilesDropped;
  final Widget child;

  const DragDropReceiver({Key? key, this.onFilesDropped, required this.child})
    : super(key: key);

  @override
  _DragDropReceiverState createState() => _DragDropReceiverState();
}

class _DragDropReceiverState extends State<DragDropReceiver> {
  bool _isDragging = false;
  final Set<String> _supportedExtensions = {
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.bmp',
    '.webp',
    '.mp4',
    '.mov',
    '.avi',
    '.mkv',
    '.webm',
  };

  @override
  void initState() {
    super.initState();
    _setupMethodChannel();
  }

  void _setupMethodChannel() {
    // 设置方法通道接收来自 macOS 的拖拽事件
    const methodChannel = MethodChannel('drag_channel');
    methodChannel.setMethodCallHandler((call) async {
      if (call.method == "filesDropped") {
        final List<dynamic> filePaths = call.arguments;
        _handleDroppedFiles(filePaths.cast<String>());
      }
    });
  }

  void _handleDroppedFiles(List<String> filePaths) {
    final List<File> mediaFiles = [];

    for (String path in filePaths) {
      final file = File(path);
      if (_isSupportedMediaFile(file)) {
        mediaFiles.add(file);
      }
    }

    if (mediaFiles.isNotEmpty && widget.onFilesDropped != null) {
      widget.onFilesDropped!(mediaFiles);
    }
  }

  bool _isSupportedMediaFile(File file) {
    final extension = file.path.toLowerCase().split('.').last;
    return _supportedExtensions.contains('.$extension');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        // 自定义拖拽覆盖层
        if (_isDragging)
          Positioned.fill(
            child: Container(
              color: Colors.blue.withOpacity(0.3),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 10),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.file_upload, size: 48, color: Colors.blue),
                      SizedBox(height: 10),
                      Text(
                        '松开以添加文件',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '支持图片和视频文件',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
