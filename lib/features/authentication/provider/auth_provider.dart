import 'package:hr_management/features/authentication/api/login_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider {
  // Try auto-login
  static Future<bool> tryAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

// logout
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refresh_token');
      final authToken = prefs.getString('auth_token');
      
      if (refreshToken != null && refreshToken.isNotEmpty && authToken != null) {
        await LoginApi.userLogout(authToken, refreshToken);
      }
      
      await prefs.remove('auth_token');
      await prefs.remove('refresh_token');
      await prefs.remove('user_role');
    } catch (e) {
      // Ignore errors on logout
    }
  }
}
