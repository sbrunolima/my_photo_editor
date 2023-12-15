import 'package:http/http.dart' as http;

class RemoveBgApi {
  static const apiKey = "";

  static var apiUrl = Uri.parse("https://api.remove.bg/v1.0/removebg");

  static removeBackground({required String imagePath}) async {
    var req = http.MultipartRequest("POST", apiUrl);

    req.headers.addAll({"X-API-KEY": apiKey});

    req.files.add(
      await http.MultipartFile.fromPath(
        "image_file",
        imagePath,
      ),
    );

    final response = await req.send();

    if (response.statusCode == 200) {
      http.Response img = await http.Response.fromStream(response);
      print('STATUS: Send OK');
      return img.bodyBytes;
    } else {
      print('STATUS: Send Faild');
      return null;
    }
  }
}
