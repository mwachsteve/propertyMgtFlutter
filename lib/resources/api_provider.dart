import 'package:dio/dio.dart';
import 'package:property_bloc_fetch_api/models/property_model.dart';

class ApiProvider {
  final Dio _dio = Dio();
  final String _url = 'http://localhost:8000/api/properties';

  Future<PropertyModel> fetchPropertyList() async {
    try {
      Response response = await _dio.get(_url);
      return PropertyModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return PropertyModel.withError("Data not found / Connection issue");
    }
  }

  Future<void> addPropertyList(String name, String description, int cost) async {
      try {
    // Example of calling the request method with parameters
    final response = await  _dio.post(_url, param: {'name': name, 'description': description, 'cost': cost},
      contentType: 'application/json',
    );
// Handle the response
    if (response.statusCode == 200) {
      // Success: Process the response data
      print('API call successful: ${response.data}');
    } else {
      // Error: Handle the error response
      print('API call failed: ${response.statusMessage}');
    }
  } catch (e) {
    // Error: Handle network errors
    print('Network error occurred: $e');
  }
  }

  Future<void> _updateData(int id, String name, String description, int cost) async {
    try {
      final response = await _dio.put(
          Uri.parse('http://localhost:8000/api/properties/$id'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'name': name,
            'description':description,
            'cost': cost,
          }));

      if (response.statusCode == 200) {
        _fetchData();
      } else {
        throw Exception('Failed to update data');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _deleteData(int id) async {
    try {
      final response = await _dio
          .delete(Uri.parse('http://localhost:8000/api/properties/$id'));

      if (response.statusCode == 200) {
        _fetchData();
      } else {
        throw Exception('Failed to delete data');
      }
    } catch (error) {
      print(error);
    }
  }

}
