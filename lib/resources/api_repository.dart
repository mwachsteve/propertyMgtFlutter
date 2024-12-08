import 'package:property_bloc_fetch_api/models/property_model.dart';

import 'api_provider.dart';

class ApiRepository {
  final _provider = ApiProvider();

  Future<PropertyModel> fetchPropertyList() {
    return _provider.fetchPropertyList();
  }
}

class NetworkError extends Error {}
