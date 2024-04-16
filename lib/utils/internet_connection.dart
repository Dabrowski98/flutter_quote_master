import 'dart:io';

abstract class InternetCheckClass {
  Future<bool> get connected;
}

class InternetCheck implements InternetCheckClass {
  @override
  Future<bool> get connected async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      print("Internet connection not found.");
      return Future.value(false);
    }
  }
}
