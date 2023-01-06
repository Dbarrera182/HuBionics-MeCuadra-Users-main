import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class EmployeeModel {
  String? id;
  String? name;
  String? personalNumber;
  String? businessNumber;
  String? image;
  String? createDate;
  String? direction;
  String? email;
  int? assignedProperties;
  String? propertyType;
  String? specializedSector;
  String? position;
  bool? emailVerified;

  EmployeeModel(
      {this.id,
      this.name,
      this.personalNumber,
      this.businessNumber,
      this.image,
      this.createDate,
      this.direction,
      this.email,
      this.assignedProperties,
      this.propertyType,
      this.specializedSector,
      this.position,
      this.emailVerified});

  Map<String, dynamic> emptyMap() {
    return {
      'id': '',
      'name': '',
      'personalNumber': '',
      'businessNumber': '',
      'image': '',
      'createDate': '',
      'direction': '',
      'email': '',
      'assignedProperties': 0,
      'propertyType': '',
      'specializedSector': '',
      'position': '',
      'emailVerified': false,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id ?? '',
      'name': name ?? '',
      'personalNumber': personalNumber ?? '',
      'businessNumber': businessNumber ?? '',
      'image': image ?? '',
      'createDate': createDate ?? '',
      'direction': direction ?? '',
      'email': email ?? '',
      'assignedProperties': assignedProperties ?? 0,
      'propertyType': propertyType ?? '',
      'specializedSector': specializedSector ?? '',
      'position': position ?? '',
      'emailVerified': emailVerified ?? false,
    };
  }

  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      id: map['id'] != null ? map['id'] as String : '',
      name: map['name'] != null ? map['name'] as String : '',
      personalNumber:
          map['personalNumber'] != null ? map['personalNumber'] as String : '',
      businessNumber:
          map['businessNumber'] != null ? map['businessNumber'] as String : '',
      image: map['image'] != null ? map['image'] as String : '',
      createDate: map['createDate'] != null ? map['createDate'] as String : '',
      direction: map['direction'] != null ? map['direction'] as String : '',
      email: map['email'] != null ? map['email'] as String : '',
      assignedProperties: map['assignedProperties'] != null
          ? map['assignedProperties'] as int
          : 0,
      propertyType:
          map['propertyType'] != null ? map['propertyType'] as String : '',
      specializedSector: map['specializedSector'] != null
          ? map['specializedSector'] as String
          : '',
      position: map['position'] != null ? map['position'] as String : '',
      emailVerified:
          map['emailVerified'] != null ? map['emailVerified'] as bool : false,
    );
  }

  String toJson() => json.encode(toMap());

  factory EmployeeModel.fromJson(String source) =>
      EmployeeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EmployeeModel(id: $id, name: $name, personalNumber: $personalNumber, businessNumber: $businessNumber, image: $image, createDate: $createDate, direction: $direction, email: $email, assignedProperties: $assignedProperties, propertyType: $propertyType, specializedSector: $specializedSector, position: $position, emailVerified: $emailVerified)';
  }

  @override
  bool operator ==(covariant EmployeeModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.personalNumber == personalNumber &&
        other.businessNumber == businessNumber &&
        other.image == image &&
        other.createDate == createDate &&
        other.direction == direction &&
        other.email == email &&
        other.assignedProperties == assignedProperties &&
        other.propertyType == propertyType &&
        other.specializedSector == specializedSector &&
        other.position == position &&
        other.emailVerified == emailVerified;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        personalNumber.hashCode ^
        businessNumber.hashCode ^
        image.hashCode ^
        createDate.hashCode ^
        direction.hashCode ^
        email.hashCode ^
        assignedProperties.hashCode ^
        propertyType.hashCode ^
        specializedSector.hashCode ^
        position.hashCode ^
        emailVerified.hashCode;
  }
}
