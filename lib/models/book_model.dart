class Book {
  final String title;
  final String urlImage;

  const Book({
    required this.title,
    required this.urlImage,
  });
}

const allBooks = [
  Book(title: '1번', urlImage: 'https://picsum.photos/200'),
  Book(title: '2번', urlImage: 'https://picsum.photos/200'),
  Book(title: '3번', urlImage: 'https://picsum.photos/200'),
];
