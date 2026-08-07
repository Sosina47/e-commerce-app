class UserProfile {
  final int id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String phone;
  final String street;
  final String city;
  final String zipcode;

  const UserProfile({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.street,
    required this.city,
    required this.zipcode,
  });

  String get fullName {
    final first = firstName.isNotEmpty
        ? '${firstName[0].toUpperCase()}${firstName.substring(1)}'
        : '';
    final last = lastName.isNotEmpty
        ? '${lastName[0].toUpperCase()}${lastName.substring(1)}'
        : '';
    final name = '$first $last'.trim();
    return name.isNotEmpty ? name : username;
  }

  String get formattedAddress {
    final parts = [street, city, zipcode].where((s) => s.isNotEmpty).toList();
    return parts.isNotEmpty ? parts.join('\n') : 'No address provided';
  }

  factory UserProfile.fromJson(dynamic json) {
    if (json is Map) {
      final map = Map<String, dynamic>.from(json);

      String fName = '';
      String lName = '';
      if (map['name'] is Map) {
        final nameMap = Map<String, dynamic>.from(map['name'] as Map);
        fName = nameMap['firstname'] as String? ?? '';
        lName = nameMap['lastname'] as String? ?? '';
      }

      String streetStr = '';
      String cityStr = '';
      String zipStr = '';
      if (map['address'] is Map) {
        final addrMap = Map<String, dynamic>.from(map['address'] as Map);
        final numVal = addrMap['number']?.toString() ?? '';
        final stVal = addrMap['street'] as String? ?? '';
        streetStr = numVal.isNotEmpty ? '$numVal $stVal' : stVal;
        cityStr = addrMap['city'] as String? ?? '';
        zipStr = addrMap['zipcode'] as String? ?? '';
      }

      return UserProfile(
        id: (map['id'] as num?)?.toInt() ?? 0,
        email: map['email'] as String? ?? '',
        username: map['username'] as String? ?? '',
        firstName: fName,
        lastName: lName,
        phone: map['phone'] as String? ?? '',
        street: streetStr,
        city: cityStr,
        zipcode: zipStr,
      );
    }
    return const UserProfile(
      id: 0,
      email: '',
      username: '',
      firstName: '',
      lastName: '',
      phone: '',
      street: '',
      city: '',
      zipcode: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'name': {
        'firstname': firstName,
        'lastname': lastName,
      },
      'phone': phone,
      'address': {
        'street': street,
        'city': city,
        'zipcode': zipcode,
      },
    };
  }
}
