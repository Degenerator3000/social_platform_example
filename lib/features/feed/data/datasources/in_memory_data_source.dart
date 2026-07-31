import 'feed_data_source.dart';
import 'package:social_platform_example/features/feed/data/models/pins_page_model.dart';
import 'package:social_platform_example/features/feed/data/models/pin_model.dart';
class InMemoryDataSource implements FeedDataSource{

  late final int _fakeDataLength;

  final List<Map<String, dynamic>> _fakeData = [
    {
      'id': '1',
      'imageUrl': 'https://example.com/images/pin1.jpg',
      'title': 'Закат на побережье',
      'author': 'Анна Морская',
      'likesCount': 243,
      'description': 'Прекрасный закат, снятый на прошлой неделе.',
    },
    {
      'id': '2',
      'imageUrl': 'https://example.com/images/pin2.jpg',
      'title': 'Горы в тумане',
      'author': 'Иван Вершинин',
      'likesCount': 187,
    },
    {
      'id': '3',
      'imageUrl': 'https://example.com/images/pin3.jpg',
      'title': 'Уютное кафе',
      'author': 'Ольга Лавандова',
      'likesCount': 512,
      'description': 'Лучший кофе в городе!',
    },
    {
      'id': '4',
      'imageUrl': 'https://example.com/images/pin4.jpg',
      'title': 'Абстрактная живопись',
      'author': 'Дмитрий Кистев',
      'likesCount': 98,
      'description': null,
    },
    {
      'id': '5',
      'imageUrl': 'https://example.com/images/pin5.jpg',
      'title': 'Ретро автомобиль',
      'author': 'Елена Механик',
      'likesCount': 321,
      'description': 'Найден в гараже дедушки.',
    },
    {
      'id': '6',
      'imageUrl': 'https://example.com/images/pin6.jpg',
      'title': 'Цветущий сад',
      'author': 'Садовник',
      'likesCount': 76,
      'description': 'Весна в моём саду.',
    },
    {
      'id': '7',
      'imageUrl': 'https://example.com/images/pin7.jpg',
      'title': 'Ночной мегаполис',
      'author': 'Павел Огнев',
      'likesCount': 654,
      'description': 'Огни города с высоты птичьего полёта.',
    },
    {
      'id': '8',
      'imageUrl': 'https://example.com/images/pin8.jpg',
      'title': 'Осенний парк',
      'author': 'Мария Листопад',
      'likesCount': 132,
      'description': 'Золотая аллея в парке Горького.',
    },
    {
      'id': '9',
      'imageUrl': 'https://example.com/images/pin9.jpg',
      'title': 'Кот-философ',
      'author': 'Борис Мурлыкин',
      'likesCount': 834,
      'description': null,
    },
    {
      'id': '10',
      'imageUrl': 'https://example.com/images/pin10.jpg',
      'title': 'Волны и скалы',
      'author': 'Морской волк',
      'likesCount': 445,
      'description': 'Суровая красота побережья Ирландии.',
    },
    {
      'id': '11',
      'imageUrl': 'https://example.com/images/pin11.jpg',
      'title': 'Чашка кофе у окна',
      'author': 'Алина Кофеина',
      'likesCount': 523,
      'description': 'Утро начинается не с кофе, а с хорошего кадра.',
    },
    {
      'id': '12',
      'imageUrl': 'https://example.com/images/pin12.jpg',
      'title': 'Футуристичный мост',
      'author': 'Аркадий Строитель',
      'likesCount': 298,
      'description': 'Архитектура будущего уже здесь.',
    },
    {
      'id': '13',
      'imageUrl': 'https://example.com/images/pin13.jpg',
      'title': 'Зимняя сказка',
      'author': 'Евгения Снежная',
      'likesCount': 777,
      'description': 'Лес после снегопада.',
    },
    {
      'id': '14',
      'imageUrl': 'https://example.com/images/pin14.jpg',
      'title': 'Уличный музыкант',
      'author': 'Саундтрекер',
      'likesCount': 201,
      'description': 'Играл на саксофоне на закате.',
    },
    {
      'id': '15',
      'imageUrl': 'https://example.com/images/pin15.jpg',
      'title': 'Пляж с пальмами',
      'author': 'Таити Тур',
      'likesCount': 999,
      'description': 'Место, куда я хочу вернуться.',
    },
    {
      'id': '16',
      'imageUrl': 'https://example.com/images/pin16.jpg',
      'title': 'Минимализм в интерьере',
      'author': 'Дизайн Студия',
      'likesCount': 367,
      'description': 'Меньше вещей — больше воздуха.',
    },
    {
      'id': '17',
      'imageUrl': 'https://example.com/images/pin17.jpg',
      'title': 'Северное сияние',
      'author': 'Полярник',
      'likesCount': 1452,
      'description': 'Один из лучших дней в жизни.',
    },
    {
      'id': '18',
      'imageUrl': 'https://example.com/images/pin18.jpg',
      'title': 'Чёрно-белая драма',
      'author': 'Фотограф без цвета',
      'likesCount': 213,
      'description': null,
    },
    {
      'id': '19',
      'imageUrl': 'https://example.com/images/pin19.jpg',
      'title': 'Лавандовое поле',
      'author': 'Прованс',
      'likesCount': 688,
      'description': 'Запах лета и спокойствия.',
    },
    {
      'id': '20',
      'imageUrl': 'https://example.com/images/pin20.jpg',
      'title': 'Дорога в никуда',
      'author': 'Роудтриппер',
      'likesCount': 176,
      'description': 'Пустынное шоссе в Неваде.',
    },
    {
      'id': '21',
      'imageUrl': 'https://example.com/images/pin21.jpg',
      'title': 'Завтрак в постель',
      'author': 'Шеф-повар дома',
      'likesCount': 438,
      'description': 'Воскресное утро с круассанами.',
    },
    {
      'id': '22',
      'imageUrl': 'https://example.com/images/pin22.jpg',
      'title': 'Древний храм',
      'author': 'Археолог',
      'likesCount': 354,
      'description': 'Забытый богами, но не людьми.',
    },
    {
      'id': '23',
      'imageUrl': 'https://example.com/images/pin23.jpg',
      'title': 'Геймерская сборка',
      'author': 'PC Master Race',
      'likesCount': 892,
      'description': 'RGB-подсветка всему голова.',
    },
    {
      'id': '24',
      'imageUrl': 'https://example.com/images/pin24.jpg',
      'title': 'Старый вокзал',
      'author': 'Ретро-фото',
      'likesCount': 119,
      'description': null,
    },
    {
      'id': '25',
      'imageUrl': 'https://example.com/images/pin25.jpg',
      'title': 'Вид из самолёта',
      'author': 'Частый перелёт',
      'likesCount': 607,
      'description': 'Облака снизу — это магия.',
    },
    {
      'id': '26',
      'imageUrl': 'https://example.com/images/pin26.jpg',
      'title': 'Ёжик в тумане',
      'author': 'Анималист',
      'likesCount': 441,
      'description': 'Тот самый ёжик.',
    },
  ];

  InMemoryDataSource(){
    _fakeDataLength = _fakeData.length;
  }

  @override
  Future<PinsPageModel> fetchPins({required int page, required int limit}) async{
    await Future.delayed(Duration(seconds: 1));
    return PinsPageModel(
        pins: _fakeData.skip((page - 1) * limit).take(limit).map(
                (x) => PinModel.fromJson(x)
        ).toList(),
        hasMore: _fakeDataLength - page * limit > 0,
        page: page);
  }
}