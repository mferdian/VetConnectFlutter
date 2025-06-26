import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/my_order_page.dart';
import 'package:flutter_application_1/pages/notification_page.dart';
import 'package:flutter_application_1/pages/order_detail_page.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/pages/create_new_password.dart';
import 'package:flutter_application_1/pages/doctor_list_page.dart';
import 'package:flutter_application_1/pages/forgot_password.dart';
import 'package:flutter_application_1/pages/get_started_screen.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/pages/payment_success.dart';
import 'package:flutter_application_1/pages/register_page.dart';
import 'package:flutter_application_1/pages/signin_page.dart';
import 'package:flutter_application_1/pages/splash_screen.dart';
import 'package:flutter_application_1/pages/edit_profile_page.dart';
import 'package:flutter_application_1/controllers/profile_controller.dart';
import 'package:get_storage/get_storage.dart'; 
import 'package:intl/date_symbol_data_local.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ProfileController());
  GetStorage.init();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( 
      title: 'VetConnect',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/get-started': (context) => const GetStartedScreen(),
        '/sign-in': (context) => SignInPage(),
        '/sign-up': (context) => RegisterPage(),
        '/forgot-password': (context) => ForgotPasswordPage(),
        '/create-new-password': (context) => const NewPasswordPage(),
        '/home': (context) => const HomePage(),
        '/doctor-list': (context) => DoctorListPage(),
        '/payment-success': (context) => PaymentSuccessPage(),
        '/edit-profile': (context) => EditProfilePage(),
        '/log-out': (context) => SignInPage(),
        '/notification': (context) => NotificationPage(),
        '/my-orders' : (context)=> MyOrderPage(),
        '/order-detail': (context)=> OrderDetailPage(),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(
            child: Text('Page not found!'),
          ),
        ),
      ),
    );
  }
}
