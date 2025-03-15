import 'package:connectivity_plus/connectivity_plus.dart';

import '../custom_widgets/toast.dart';
import '../fire_store_sync_service/fire_store_sync_service.dart';

class ConnectivityService {
  final FireStoreSyncService firestoreSyncService;

  ConnectivityService(this.firestoreSyncService) {
    Connectivity().onConnectivityChanged.listen((statusList) {
      if (statusList.isNotEmpty &&
          statusList.first != ConnectivityResult.none) {
        firestoreSyncService.syncCompletedTasks();
      } else {
        Dialogues.toast(
          "No internet. Sync will happen when online.",
          isError: true,
        );
      }
    });
  }

  static Future<bool> isOnline() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.isEmpty ||
        connectivityResult.contains(ConnectivityResult.none)) {
      Dialogues.toast(
        "No internet. Sync will happen when online.",
        isError: true,
      );
      return false;
    } else {
      return true;
    }
  }
}
