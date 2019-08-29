import '../models/base_model.dart';

class MovieGenre {
  final String next;
  final int genre;

  MovieGenre(this.next, this.genre);

  MovieGenre.fromJson(Map<String, dynamic> json)
      : genre = BaseModel.parseInt('id', json),
        next = BaseModel.parseString('name', json);
}
