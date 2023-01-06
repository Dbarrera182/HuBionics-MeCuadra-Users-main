import 'dart:convert';

enum MediaType { image, video }

class Story {
  String? url;
  String? imageName;
  String? videoName;
  MediaType? media;
  int? seconds;

  Story({
    this.url,
    this.imageName,
    this.videoName,
    this.media,
    this.seconds,
  });

  Map<String, dynamic> toMap() {
    return {
      'url': url ?? "",
      'imageName': imageName ?? "",
      'videoName': videoName ?? "",
      'media': media.toString(),
      'seconds': seconds.toString(),
    };
  }

  Map<String, dynamic> emptyMap() {
    return {
      'url': "",
      'imageName': "",
      'videoName': "",
      'media': "",
      'seconds': "8",
    };
  }

  factory Story.fromMap(Map<String, dynamic> map) {
    MediaType myMediaType = MediaType.image;
    if (map['media'] == 'MediaType.video') {
      myMediaType = MediaType.video;
    }
    int myDuration = int.parse(map['seconds']);

    return Story(
      url: map['url'] != null ? map['url'] as String : '',
      imageName: map['imageName'] != null ? map['imageName'] as String : '',
      videoName: map['videoName'] != null ? map['videoName'] as String : '',
      media: myMediaType,
      seconds: map['seconds'] != null ? myDuration : 8,
    );
  }

  String toJson() => json.encode(toMap());

  factory Story.fromJson(String source) =>
      Story.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Story(url: $url,imageName: $imageName,videoName: $videoName, media: $media, seconds: $seconds)';

  @override
  bool operator ==(covariant Story other) {
    if (identical(this, other)) return true;

    return other.url == url &&
        other.imageName == imageName &&
        other.videoName == videoName &&
        other.media == media &&
        other.seconds == seconds;
  }

  @override
  int get hashCode =>
      url.hashCode ^
      imageName.hashCode ^
      videoName.hashCode ^
      media.hashCode ^
      seconds.hashCode;
}
