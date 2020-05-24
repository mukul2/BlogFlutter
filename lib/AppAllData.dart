class AppAllData {
  List<Categories> categories;
  List<Collections> collections;
  int applicationTypeId;
  String appDataDateTime;
  bool success;

  AppAllData(
      {this.categories,
        this.collections,
        this.applicationTypeId,
        this.appDataDateTime,
        this.success});

  AppAllData.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    if (json['collections'] != null) {
      collections = new List<Collections>();
      json['collections'].forEach((v) {
        collections.add(new Collections.fromJson(v));
      });
    }
    applicationTypeId = json['application_type_id'];
    appDataDateTime = json['app_data_date_time'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    if (this.collections != null) {
      data['collections'] = this.collections.map((v) => v.toJson()).toList();
    }
    data['application_type_id'] = this.applicationTypeId;
    data['app_data_date_time'] = this.appDataDateTime;
    data['success'] = this.success;
    return data;
  }
}

class Categories {
  int id;
  int parentId;
  String title;
  String iconUrl;
  int sortWeight;

  Categories(
      {this.id, this.parentId, this.title, this.iconUrl, this.sortWeight});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    title = json['title'];
    iconUrl = json['icon_url'];
    sortWeight = json['sort_weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['title'] = this.title;
    data['icon_url'] = this.iconUrl;
    data['sort_weight'] = this.sortWeight;
    return data;
  }
}

class Collections {
  int id;
  int categoryId;
  String description;
  String answer;
  int totalUpVote;
  int totalDownVote;
  bool isHtml;

  Collections(
      {this.id,
        this.categoryId,
        this.description,
        this.answer,
        this.totalUpVote,
        this.totalDownVote,
        this.isHtml});

  Collections.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    description = json['description'];
    answer = json['answer'];
    totalUpVote = json['total_up_vote'];
    totalDownVote = json['total_down_vote'];
    isHtml = json['is_html'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['description'] = this.description;
    data['answer'] = this.answer;
    data['total_up_vote'] = this.totalUpVote;
    data['total_down_vote'] = this.totalDownVote;
    data['is_html'] = this.isHtml;
    return data;
  }
}