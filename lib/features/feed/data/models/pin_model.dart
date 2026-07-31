import 'package:social_platform_example/features/feed/domain/entities/pin.dart';

class PinModel{

  final String id;
  final String imageUrl;
  final String title;
  final String? description;
  final String author;
  final int likesCount;

  const PinModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.likesCount,
    this.description,
  });
//фабрика для создания модели из json
  factory PinModel.fromJson(Map<String, dynamic> json){
    return PinModel(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      likesCount: json['likesCount'] as int,
      description: json['description'] as String?,
    );
  }
  //метод для обратно сериализации
  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'imageUrl' : imageUrl,
      'title' : title,
      'author' : author,
      'likesCount' : likesCount,
      if (description != null) 'description': description,
    };
  }
//создание пина из моделии
  Pin toEntity(){
    return Pin(
      id: id,
      imageUrl: imageUrl,
      title: title,
      author: author,
      likesCount: likesCount,
      description: description,
    );
  }



}