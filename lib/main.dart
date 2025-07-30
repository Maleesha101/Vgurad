import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vguard/core/app_routes.dart';
import 'package:vguard/firebase_options.dart';
import 'package:vguard/pages/admin_section_page.dart';
import 'package:vguard/pages/ai_advisor_page.dart';
import 'package:vguard/pages/crop_disease_scanner_page.dart';
import 'package:vguard/pages/disease_database_page.dart';
import 'package:vguard/pages/expert_help_page.dart';
import 'package:vguard/pages/farmer_tips_page.dart';
import 'package:vguard/pages/home_page.dart';

void main() async {
  // await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vguard Crop Protection',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: (settings) {
        final Widget page;
        switch (settings.name) {
          case AppRoutes.home:
            page = const HomePage();
            break;
          case AppRoutes.scanCrop:
            page = const CropDiseaseScannerPage();
            break;
          case AppRoutes.diseaseDatabase:
            page = const DiseaseDatabasePage();
            break;
          case AppRoutes.farmerTips:
            page = const FarmerTipsPage();
            break;
          case AppRoutes.expertHelp:
            page = const ExpertHelpPage();
            break;
          case AppRoutes.askAdvisor:
            page = const AskAdvisorPage();
            break;
          case AppRoutes.adminDashboard:
            page = const AdminSectionPage();
            break;
          default:
            page = const Text('Error: Unknown route');
        }

        return PageTransition(
          type: PageTransitionType.fade,
          child: page,
          settings: settings,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      },
    );
  }
}
