class CustomVisionResponse {
  final String id;
  final String project;
  final String iteration;
  final String created;
  final List<Predictions> predictions;

  CustomVisionResponse(
      {this.id, this.project, this.iteration, this.created, this.predictions});

  factory CustomVisionResponse.fromJson(Map<String, dynamic> json) {
    var list = json['predictions'] as List;

    return CustomVisionResponse(
      id: json['id'],
      project: json['project'],
      iteration: json['iteration'],
      created: json['created'],
      predictions: list.map((i) => Predictions.fromJson(i)).toList(),
    );
  }
}

class Predictions {
  var probability;
  String tagName;
  String tagId;

  Predictions({this.probability, this.tagName, this.tagId});

  factory Predictions.fromJson(Map<String, dynamic> json) {
    return Predictions(
      probability: json['probability'],
      tagName: json['tagName'],
      tagId: json['tagId'],
    );
  }
}
