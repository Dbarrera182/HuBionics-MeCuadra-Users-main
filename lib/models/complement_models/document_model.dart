// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DocumentModel {
  String? documentName;
  String? documentURL;

  DocumentModel({
    this.documentName,
    this.documentURL,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'documentName': documentName ?? "",
      'documentURL': documentURL ?? "",
    };
  }

  Map<String, dynamic> emptyMap() {
    return {
      'documentName': "",
      'documentURL': "",
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      documentName:
          map['documentName'] != null ? map['documentName'] as String : '',
      documentURL:
          map['documentURL'] != null ? map['documentURL'] as String : '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentModel.fromJson(String source) =>
      DocumentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DocumentModel(documentName: $documentName, documentURL: $documentURL)';

  @override
  bool operator ==(covariant DocumentModel other) {
    if (identical(this, other)) return true;

    return other.documentName == documentName &&
        other.documentURL == documentURL;
  }

  @override
  int get hashCode => documentName.hashCode ^ documentURL.hashCode;
}
