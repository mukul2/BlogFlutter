class CustomBodyModel {
  String type;
  String body;

  CustomBodyModel({this.type, this.body});

  CustomBodyModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['body'] = this.body;
    return data;
  }
}