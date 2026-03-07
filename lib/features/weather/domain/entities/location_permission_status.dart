enum LocationPermissionStatus {
  unknown,     // not yet requested
  requesting,  // native dialog showing
  granted,     // approved
  denied,      // denied by user (including deniedForever)
}
