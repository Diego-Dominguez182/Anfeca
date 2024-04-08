import 'package:flutter/material.dart';
import '../presentation/screens/message_tenant_register_screen.dart';
import '../presentation/screens/main_registration_screen.dart';
import '../presentation/screens/main_screen.dart';
import '../presentation/screens/owner_registration_screen.dart';
import '../presentation/screens/tenant_registration_screen.dart';
import '../presentation/screens/reset_password_screen.dart';
import '../presentation/screens/message_file_screen.dart';
import '../presentation/screens/principal_screen/principal_screen.dart';

class AppRoutes {
  static const String mainRegistrationScreen = '/main_registration_screen';

  static const String mainScreen = '/main_screen';

  static const String ownerRegistrationScreen = '/owner_registration_screen';

  static const String tenantRegistrationScreen = '/tenant_registration_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static const String resetPasswordScreen = '/reset_password_screen';
  
  static const String messageFileScreen = '/message_file_screen';
  
  static const String messageTenantRegisterSccreen = '/message_tenant_register_screen';

  static const String principalScreen = '/principal_screen';
  
  static const String tenantProfileMainScreen = '/tenant_profile_main_screen';



  static Map<String, WidgetBuilder> routes = {
    mainRegistrationScreen: (context) => MainRegistrationScreen(),
    mainScreen: (context) => MainScreen(),
    principalScreen: (context) => PrincipalScreen(),
    ownerRegistrationScreen: (context) => OwnerRegistrationScreen(),
    tenantRegistrationScreen: (context) => TenantRegistrationScreen(),
    resetPasswordScreen: (context) => ResetPasswordScreen(),
    messageFileScreen: (context) => MessageFileScreen(),
    messageTenantRegisterSccreen: (context) => MessageTenantRegisterScreen(),
    tenantProfileMainScreen: (context) => TenantRegistrationScreen(),
  };
}
