import 'dart:io';
import 'package:http/http.dart' as http;

class EditProfileService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static Future<http.StreamedResponse> updateProfile({
    required String token,
    required String name,
    required String email,
    String? noTelp,
    int? umur,
    String? alamat,
    String? password,
    String? passwordConfirmation,
    File? profilePhoto,
  }) async {
    var uri = Uri.parse('$baseUrl/profile/update');
    var request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['name'] = name;
    request.fields['email'] = email;

    if (noTelp != null) request.fields['no_telp'] = noTelp;
    if (umur != null) request.fields['umur'] = umur.toString();
    if (alamat != null) request.fields['alamat'] = alamat;
    if (password != null) request.fields['password'] = password;
    if (passwordConfirmation != null) {
      request.fields['password_confirmation'] = passwordConfirmation;
    }

    if (profilePhoto != null) {
      var fileStream = http.ByteStream(profilePhoto.openRead());
      var length = await profilePhoto.length();
      var multipartFile = http.MultipartFile(
        'profile_photo',
        fileStream,
        length,
        filename: profilePhoto.path.split('/').last,
      );
      request.files.add(multipartFile);
    }

    return request.send();
  }
}
