import 'dart:io';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  SocketService() {
    _initConfig();
  }

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;

  void _initConfig() {
    _socket = IO.io('http://192.168.60.101:3000', {
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.onConnect((_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // socket.on('nuevo-mensaje', (payload) {
    //   print('nuevo mensaje');
    //   print('Nombre: ' + payload['nombre']);
    //   print('Mensaje: ' + payload['mensaje']);
    // });
  }
}
