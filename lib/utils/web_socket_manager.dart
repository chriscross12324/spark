import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart';

class WebSocketManager extends StateNotifier<WebSocketState> {
  WebSocketManager() : super(WebSocketState());

  WebSocketChannel? _channel;
  String? _currentDeviceId;

  void connect(String deviceId) async {
    if (_currentDeviceId == deviceId) return;

    disconnect();
    _currentDeviceId = deviceId;

    final url = 'wss://findthefrontier.ca/spark/ws/$_currentDeviceId';

    state = state.copyWith(
        isConnected: false,
        isConnecting: true,
        errorMessage: null,
        receivedData: []);

    final randomDelay = Random().nextInt(2500) + 500;
    await Future.delayed( Duration(milliseconds: randomDelay));

    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));

      _channel!.stream.listen((message) {
        final decodedData = jsonDecode(message) as Map<String, dynamic>;
        receiveData(decodedData);
        if (kDebugMode) print("Received: $message");
      }, onError: (error, stacktrace) {
        state = state.copyWith(
          isConnected: false,
          isConnecting: false,
          errorMessage: "WebSocket error: ${error.inner.message} | URL: $url",
        );
        if (kDebugMode) print("WebSocket error: ${error.inner.message}");
      }, onDone: () {
        state = state.copyWith(
          isConnected: false,
          isConnecting: false,
        );
        if (kDebugMode) print("WebSocket closed.");
        _currentDeviceId = null;
      });

      state = state.copyWith(isConnected: true, isConnecting: false);
    } catch (error) {
      state.copyWith(
        isConnected: false,
        isConnecting: false,
        errorMessage: "General error: ${error.toString()}",
      );
    }
  }

  void receiveData(Map<String, dynamic> data) {
    state = state.copyWith(
      receivedData: [...state.receivedData, data],
    );
  }

  void disconnect() {
    if (_channel != null) {
      _channel!.sink.close(goingAway);
      _channel = null;
      _currentDeviceId = null;
      state = state.copyWith(
        isConnected: false,
        isConnecting: false,
        errorMessage: null,
        receivedData: [],
      );
    }
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}

class WebSocketState {
  final bool isConnected;
  final bool isConnecting;
  final String? errorMessage;
  final List<Map<String, dynamic>> receivedData;

  WebSocketState({
    this.isConnected = false,
    this.isConnecting = false,
    this.errorMessage,
    this.receivedData = const [],
  });

  WebSocketState copyWith({
    bool? isConnected,
    bool? isConnecting,
    String? errorMessage,
    List<Map<String, dynamic>>? receivedData,
  }) {
    return WebSocketState(
      isConnected: isConnected ?? this.isConnected,
      isConnecting: isConnecting ?? this.isConnecting,
      errorMessage: errorMessage ?? this.errorMessage,
      receivedData: receivedData ?? this.receivedData,
    );
  }
}

final webSocketManagerProvider =
    StateNotifierProvider<WebSocketManager, WebSocketState>((ref) {
  return WebSocketManager();
});
