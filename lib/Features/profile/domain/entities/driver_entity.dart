class DriverEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String photo;
  final String role;
  final String gender;
  final String country;
  final String vehicleType;
  final String vehicleNumber;
  final String vehicleLicense;
  final String nid;
  final String nidImg;

  DriverEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.photo,
    required this.role,
    required this.gender,
    required this.country,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.vehicleLicense,
    required this.nid,
    required this.nidImg,
  });

  DriverEntity copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? photo,
    String? role,
    String? gender,
    String? country,
    String? vehicleType,
    String? vehicleNumber,
    String? vehicleLicense,
    String? nid,
    String? nidImg,
  }) {
    return DriverEntity(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      role: role ?? this.role,
      gender: gender ?? this.gender,
      country: country ?? this.country,
      vehicleType: vehicleType ?? this.vehicleType,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      vehicleLicense: vehicleLicense ?? this.vehicleLicense,
      nid: nid ?? this.nid,
      nidImg: nidImg ?? this.nidImg,
    );
  }
}
