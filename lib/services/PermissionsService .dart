import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  final PermissionHandler _permissionHandler = PermissionHandler();
   Future<bool> _requestPermission(PermissionGroup permission) async {
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }
 Future<bool> requestPermissionLocation({Function onPermissionDenied}) async {
    var granted = await _requestPermission(PermissionGroup.location);
    if (!granted) {
      onPermissionDenied();
    }
    return granted;
  }
  Future<bool> requestPermissionlocAtionAlways({Function onPermissionDenied}) async {
    var granted = await _requestPermission(PermissionGroup.locationAlways);
    if (!granted) {
      onPermissionDenied();
    }
    return granted;
  }
   Future<bool> requestPermissionlocLocationWhenInUse({Function onPermissionDenied}) async {
    var granted = await _requestPermission(PermissionGroup.locationWhenInUse);
    if (!granted) {
      onPermissionDenied();
    }
    return granted;
  }
}