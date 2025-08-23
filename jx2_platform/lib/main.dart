import 'package:jx2_platform/jx2_platform.dart';

void main() async {
  // Verificar plataforma atual
  print(Jx2PlatformHelper.getCurrentPlatform());

  // Obter informações do dispositivo
  final deviceInfo = await Jx2DeviceInfoHelper.getDeviceDetails();
  print(deviceInfo);

  // Verificar conexão com internet
  final hasInternet = await Jx2ConnectivityHelper.checkInternetConnection();
  print('Conectado à internet: $hasInternet');

  // Solicitar permissão de câmera
  final hasCameraPermission = await Jx2PermissionHelper.requestCameraPermission();
  print('Permissão de câmera: $hasCameraPermission');
}