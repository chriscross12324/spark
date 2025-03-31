import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spark/app_providers.dart';
import 'package:spark/providers/sensor_data_provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart';

class WebSocketManager extends StateNotifier<WebSocketState> {
  WebSocketManager(this.ref) : super(WebSocketState());

  final Ref ref;
  WebSocketChannel? _channel;
  String? _currentDeviceId;
  bool _shouldReconnect = true;

  void connect(String deviceId) async {
    if (_currentDeviceId == deviceId) return;

    disconnect();
    ref.watch(sensorDataProvider.notifier).purgeData();

    _currentDeviceId = deviceId;
    _shouldReconnect = true;

    final apiBase = ref.read(settingAPIEndpoint);
    final apiEndpoint = 'wss://$apiBase/$_currentDeviceId';

    state = state.copyWith(
      isConnected: false,
      isConnecting: true,
      isReconnecting: false,
      errorMessage: null,
    );
    state = state.resetError();

    try {
      _channel = WebSocketChannel.connect(Uri.parse(apiEndpoint));

      _channel!.stream.listen((message) {
        if (!state.isConnected) {
          state = state.copyWith(isConnected: true, isConnecting: false);
        }

        final decodedData = jsonDecode(message) as Map<String, dynamic>;
        //print(decodedData);

        ref.read(sensorDataProvider.notifier).updateData(decodedData);

        //if (kDebugMode) print("Received: $message");
      }, onError: (error, stacktrace) {
        state = state.copyWith(
          isConnected: false,
          isConnecting: false,
          errorMessage: "WebSocket error: ${error.inner.message} | URL: $apiEndpoint",
        );
        if (kDebugMode) print("WebSocket error: ${error.inner.message}");

        if (_shouldReconnect) {
          reconnect();
        }
      }, onDone: () {
        state = state.copyWith(
          isConnected: false,
          isConnecting: false,
          errorMessage: null,
        );
        if (kDebugMode) print("WebSocket closed.");
        _currentDeviceId = null;

        if (_shouldReconnect) {
          reconnect();
        }
      });
    } catch (error) {
      state = state.copyWith(
        isConnected: false,
        isConnecting: false,
        errorMessage: "General error: ${error.toString()}",
      );
    }
  }

  void disconnect() {
    if (_channel != null) {
      _shouldReconnect = false;
      _channel!.sink.close(normalClosure);
      _channel = null;
      _currentDeviceId = null;
      state = state.copyWith(
        isConnected: false,
        isConnecting: false,
        errorMessage: null,
      );

      state = state.resetError();
    }
  }

  void reconnect() {
    print("Reconnecting");
    state = state.copyWith(isReconnecting: true);

    Future.delayed(const Duration(seconds: 3), () {
      if (_currentDeviceId != null) {
        connect(_currentDeviceId!);
      } else {
        print('Device ID is currently null');
      }
    });
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
  final bool isReconnecting;
  final String? errorMessage;

  WebSocketState({
    this.isConnected = false,
    this.isConnecting = false,
    this.isReconnecting = false,
    this.errorMessage,
  });

  WebSocketState copyWith({
    bool? isConnected,
    bool? isConnecting,
    bool? isReconnecting,
    String? errorMessage,
  }) {
    return WebSocketState(
      isConnected: isConnected ?? this.isConnected,
      isConnecting: isConnecting ?? this.isConnecting,
      isReconnecting: isReconnecting ?? this.isReconnecting,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  WebSocketState resetError() {
    return WebSocketState(
      isConnected: isConnected,
      isConnecting: isConnecting,
      isReconnecting: isReconnecting,
      errorMessage: null,
    );
  }
}

final webSocketManagerProvider =
    StateNotifierProvider<WebSocketManager, WebSocketState>((ref) {
  return WebSocketManager(ref);
});
