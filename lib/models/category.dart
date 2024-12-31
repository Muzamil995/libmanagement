
import 'dart:convert';

BooksModel booksModelFromJson(String str) => BooksModel.fromJson(json.decode(str));

String booksModelToJson(BooksModel data) => json.encode(data.toJson());

class BooksModel {
  final String? docId;
  final String? catId;
  final String? userId;
  final String? name;
  final String? totalPages;
  final String? authorName;
  final String? imageUrl;
  final String? stock;
  final String? createdAt;

  BooksModel({
    this.docId,
    this.catId,
    this.userId,
    this.name,
    this.totalPages,
    this.authorName,
    this.imageUrl,
    this.stock,
    this.createdAt,
  });

  factory BooksModel.fromJson(Map<String, dynamic> json) => BooksModel(
    docId: json["docId"],
    catId: json["catID"],
    userId: json["userID"],
    name: json["name"],
    totalPages: json["totalPages"],
    authorName: json["authorName"],
    imageUrl: json["image"],
    stock: json["stock"],
    createdAt: json["createdAt"],
  );

  Map<String, dynamic> toJson() => {
    "docId": docId,
    "catID": catId,
    "userID": userId,
    "name": name,
    "totalPages": totalPages,
    "authorName": authorName,
    "image": imageUrl,
    "stock": stock,
    "createdAt": createdAt,
  };
}
