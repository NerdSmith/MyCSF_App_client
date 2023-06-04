import 'dart:async';
import 'dart:convert';

import 'package:mycsf_app_client/chat/usercommon.dart';
import 'package:web_socket_channel/io.dart';

class NotificationController {
  static final NotificationController _singleton =
  NotificationController._internal();

  StreamController<String> streamController =
  StreamController.broadcast(sync: true);

  Function? toRun;

  IOWebSocketChannel? channel;
  late var channelStream = channel?.stream.asBroadcastStream();

  factory NotificationController() {
    return _singleton;
  }

  setToRun(Function f) {
    toRun = f;
  }

  unsetToRun() {
    toRun = null;
  }

  NotificationController._internal() {
    initWebSocketConnection();
  }

  initWebSocketConnection() async {
    Future.delayed(Duration(seconds: 2));
    print("conecting...");

    int myId = await UserCommonController.getSelfId();

    try {
      channel = IOWebSocketChannel.connect(
          Uri.parse('ws://10.0.2.2:8000/chat/$myId/'),
          pingInterval: const Duration(seconds: 10),
          connectTimeout: Duration(seconds: 2)
      );
      channelStream = channel?.stream.asBroadcastStream();
    } on Exception catch (e) {
      print("err: " + e.toString());
      return await initWebSocketConnection();
    }

    print("socket connection initializied");

    channel?.sink.done.then((dynamic _) => _onDisconnected());
    broadcastNotifications();
  }

  void _onDisconnected() {
    print("disconnected");
    initWebSocketConnection();
  }

  void sendMessage(messageObject, Function messageListener) {
    try {
      channel?.sink.add(json.encode(messageObject));
    } on Exception catch (e) {
      print(e);
    }
  }

  broadcastNotifications() {
    channelStream?.listen((streamData) {
      print("bradcst: $streamData");
      if (toRun != null) {
        var data = json.decode(streamData);
        toRun!(ChatMessage.fromJson(data));
      }

    }, onDone: () {
      channelStream = null;
      print("conecting aborted");
      initWebSocketConnection();
    }, onError: (e) {
      print('Server error: $e');
      // initWebSocketConnection();
    });
  }


}