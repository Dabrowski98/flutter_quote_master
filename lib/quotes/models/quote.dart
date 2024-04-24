import 'package:hive/hive.dart';

class Quote {
  final String content;
  final String author;
  final String authorSlug;
  final List<dynamic> tags;
  final int length;
  final String id;
  bool isFavorite;
  int key;

  Quote(
      {required this.content,
      required this.author,
      required this.authorSlug,
      required this.tags,
      required this.length,
      required this.id,
      this.isFavorite = false,
       this.key = -1});

}

class QuoteAdapter extends TypeAdapter<Quote> {
  @override
  read(BinaryReader reader) {
    final content = reader.readString();
    final author = reader.readString();
    final authorSlug = reader.readString();
    final tags = reader.readList();
    final length = reader.readInt();
    final id = reader.readString();
    final isFavorite = reader.readBool();
    final key = reader.readInt();

    // Return the deserialized object
    return Quote(
      content: content,
      author: author,
      authorSlug: authorSlug,
      tags: tags,
      length: length,
      id: id,
      isFavorite: isFavorite,
      key: key,
    );
  }

  @override
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, obj) {
    writer.writeString(obj.content);
    writer.writeString(obj.author);
    writer.writeString(obj.authorSlug);
    writer.writeList(obj.tags);
    writer.writeInt(obj.length);
    writer.writeString(obj.id);
    writer.writeBool(obj.isFavorite);
    writer.writeInt(obj.key);
  }
}
