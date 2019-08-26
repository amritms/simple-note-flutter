

class Mynote {
  String id;
  String _title;
  String _note;
  String _createdAt;
  String _updatedAt;
  String _sortDate;

  Mynote(this._title, this._note, this._createdAt, this._updatedAt,
      this._sortDate);

    Mynote.map(dynamic obj)
    {
      this._title = obj["title"];
      this._note = obj["note"];
      this._createdAt = obj["createdAt"];
      this._updatedAt = obj["updatedAt"];
      this._sortDate = obj["sortDate"];
    }

    String get title => _title;
    String get note => _note;
    String get createdAt => _createdAt;
    String get updateAt => _updatedAt;
    String get sortDate => _sortDate;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = id;
    map["title"] = title;
    map["note"] = note;
    map["createdAt"] = _createdAt;
    map["updatedAt"] = _updatedAt;
    map["sortDate"] = _sortDate;

    return map;
  }

  void setNodeId(String id) {
    this.id = id;
  }
}
