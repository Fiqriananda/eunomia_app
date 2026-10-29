import 'package:eunomia/app/data/services/notification_services.dart';
import 'package:eunomia/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app/core/theme/app_theme.dart';
import 'app/data/services/api_service.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  final apiService = await Get.putAsync<ApiService>(() => ApiService().init());
  final bool isAuthenticated = await apiService.checkAuth();

  // Inisialisasi Service Notifikasi
  await NotificationService.initialize();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    GetMaterialApp(
      title: 'Eunomia',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: isAuthenticated ? Routes.DASHBOARD : Routes.AUTH,
      getPages: AppPages.routes,
    ),
  );
}
