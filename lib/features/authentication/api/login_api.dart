
import 'package:hr_management/core/api/api_endpoints.dart';
import 'package:http/http.dart' as http;
class LoginApi{
  static Future<void> userLogin({
      required String email,
      required String password
    }) async{
      await http.post(Uri.parse(ApiEndpoints.login),
      headers:{'ContentType':'application/json' },
      body: {
        'email':email,
        'password':password
      });
      return;
  }
}