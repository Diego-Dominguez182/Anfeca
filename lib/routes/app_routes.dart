import 'package:flutter/material.dart';
import 'package:resty_app/presentation/screens/Home/menu_screen.dart';
import 'package:resty_app/presentation/screens/myProperties/my_properties_screen.dart';
import 'package:resty_app/presentation/screens/myProperties/uploadProperty/upload_property_photos.dart';
import '../presentation/screens/Authentication/tenantRegister/message_tenant_register_screen.dart';
import '../presentation/screens/Authentication/main_registration_screen.dart';
import '../presentation/screens/Authentication/login_screen.dart';
import '../presentation/screens/Authentication/owner_registration_screen.dart';
import '../presentation/screens/Authentication/tenantRegister/tenant_registration_screen.dart';
import '../presentation/screens/Authentication/reset_password_screen.dart';
import '../presentation/screens/Authentication/tenantRegister/message_file_screen.dart';
import '../presentation/screens/Home/main_screen.dart';
import '../presentation/screens/myProperties/uploadProperty/upload_property_screen.dart';
import '../presentation/screens/update_password_screen.dart';
import '../presentation/screens/myProperties/uploadProperty/settings_house_screen.dart';
import '../presentation/screens/myProperties/uploadProperty/location_propertie_screen.dart';
import '../presentation/screens/myProperties/uploadProperty/property_services_screen.dart';
import '../presentation/screens/myProperties/uploadProperty/property_description_screen.dart';
import '../presentation/screens/myProperties/uploadProperty/property_price_screen.dart';

class AppRoutes {
  static const String mainRegistrationScreen = '/main_registration_screen';

  static const String loginScreen = '/login_screen';

  static const String ownerRegistrationScreen = '/owner_registration_screen';

  static const String tenantRegistrationScreen = '/tenant_registration_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static const String resetPasswordScreen = '/reset_password_screen';
  
  static const String messageFileScreen = '/message_file_screen';
  
  static const String messageTenantRegisterSccreen = '/message_tenant_register_screen';

  static const String mainScreen = '/main_screen';
  
  static const String menuScreen = '/menu_screen';

  static const String myPropertiesScreen = '/my_properties_screen';

  static const String uploadRoomScreen = '/upload_room_screen';

  static const String updatePasswordScreen = '/update_password_screen.dart';

  static const String settingHouseScreen = '/settings_house_screen.dart';

  static const String locationPropertieScreen = '/location_propertie_screen.dart';

  static const String propertyServicesScreen = '/property_services_screen.dart';

  static const String uploadPropertyScreen = '/upload_property_screen.dart';

  static const String propertyDescriptionScreen = '/property_description_screen.dart';

  static const String propertyPriceScreen = '/property_price_screen.dart';


  static Map<String, WidgetBuilder> routes = {
    mainRegistrationScreen: (context) => MainRegistrationScreen(),
    loginScreen: (context) => LoginScreen(),
    mainScreen: (context) => MainScreen(),
    ownerRegistrationScreen: (context) => OwnerRegistrationScreen(),
    tenantRegistrationScreen: (context) => TenantRegistrationScreen(),
    resetPasswordScreen: (context) => ResetPasswordScreen(),
    messageFileScreen: (context) => MessageFileScreen(),
    messageTenantRegisterSccreen: (context) => MessageTenantRegisterScreen(),
    menuScreen: (context) => MenuScreen(),
    myPropertiesScreen: (context) => MyPropertiesScreen(),
    uploadRoomScreen: (context) => UploadRoomScreen(),
    updatePasswordScreen: (context) => UpdatePasswordScreen(),
    settingHouseScreen: (context) => SettingHouseScreen(),
    propertyServicesScreen: (context) => PropertyServicesScreen(),
    uploadPropertyScreen: (context) => UploadPropertyScreen(),
    locationPropertieScreen: (context) => LocationPropertieScreen(),
    propertyDescriptionScreen: (context) => PropertyDescriptionScreen(),
    propertyPriceScreen: (context) => PropertyPriceScreen()
  };
}
