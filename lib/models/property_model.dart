class PropertyModel {
  String? name;
  String? description;
  int? cost;
  String? image;

  PropertyModel({this.name, this.description, this.cost, this.image});

  PropertyModel.withError(String errorMessage) {
    error = errorMessage;
  }
  
  PropertyModel.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    description = json['Description'];
    cost = json['Cost'];
    image = json['Image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Description'] = this.description;
    data['Cost'] = this.cost;
    data['Image'] = this.image;
    return data;
  }
}