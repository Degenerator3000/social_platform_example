import 'package:equatable/equatable.dart';


//Класс, хранящий базовую информацию о пине
class Pin extends Equatable {
  final String id;
  final String imageUrl;
  final String title;
  final String? description;
  final String author;
  final int likesCount;
//именнованные аргументы с required - современный подход в Dart
  const Pin({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.likesCount,
    this.description,
  });
  //реализация сравнения для последущего тестирования
  @override
  List<Object?> get props => [id, imageUrl, title, description, author, likesCount];
}