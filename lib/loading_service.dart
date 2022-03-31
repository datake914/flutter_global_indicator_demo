import 'package:flutter_riverpod/flutter_riverpod.dart';

final loadingServiceProvider =
    StateNotifierProvider<LoadingService, bool>((ref) {
  return LoadingService();
});

/// LoadingService represents interfaces to control the loading indicator.
class LoadingService extends StateNotifier<bool> {
  LoadingService() : super(false);

  int _count = 0;

  /// Wrap the a future completed value and show / hide the loader before and after processing.
  Future<T> wrap<T>(Future<T> future) async {
    _present();
    try {
      return await future;
    } finally {
      _dismiss();
    }
  }

  void _present() {
    _count = _count + 1;
    // Set the state to true.
    state = true;
  }

  void _dismiss() {
    _count = _count - 1;
    // Set the state to false only if all processing requiring a loader has been completed.
    if (_count == 0) {
      state = false;
    }
  }
}