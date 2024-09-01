class LoginResponse {
  final String token;

  LoginResponse({required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(token: json['token']);
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }
}

class Items {
  final int id;
  final String name;

  Items({
    required this.id,
    required this.name,
  });

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class ApiResponse{
  final String message;
  final Map<String, dynamic> user;
  final List<Items> items;

  ApiResponse({
    required this.message,
    required this.user,
    required this.items,
  }); 


   factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      message: json['message'],
      user: json['user'],
      items: (json['items'] as List<dynamic>)
          .map((itemJson) => Items.fromJson(itemJson as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'user': user,
        'items': items.map((item) => item.toJson()).toList(),
      };
}
