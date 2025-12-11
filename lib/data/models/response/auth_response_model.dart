import 'dart:convert';

class AuthResponseModel {
    final String? status;
    final String? token;
    final User? user;
    final Tenant? tenant;

    AuthResponseModel({
        this.status,
        this.token,
        this.user,
        this.tenant,
    });

    factory AuthResponseModel.fromJson(String str) => AuthResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AuthResponseModel.fromMap(Map<String, dynamic> json) => AuthResponseModel(
        status: json["status"] ?? json["message"], // Use message if status not present
        token: json["token"],
        user: json["user"] == null ? null : User.fromMap(json["user"]),
        tenant: json["tenant"] == null ? null : Tenant.fromMap(json["tenant"]),
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "token": token,
        "user": user?.toMap(),
        "tenant": tenant?.toMap(),
    };
}

class User {
    final int? id;
    final String? name;
    final String? email;
    final DateTime? emailVerifiedAt;
    final dynamic twoFactorSecret;
    final dynamic twoFactorRecoveryCodes;
    final dynamic twoFactorConfirmedAt;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final String? role;

    User({
        this.id,
        this.name,
        this.email,
        this.emailVerifiedAt,
        this.twoFactorSecret,
        this.twoFactorRecoveryCodes,
        this.twoFactorConfirmedAt,
        this.createdAt,
        this.updatedAt,
        this.role,
    });

    factory User.fromJson(String str) => User.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"] == null ? null : DateTime.parse(json["email_verified_at"]),
        twoFactorSecret: json["two_factor_secret"],
        twoFactorRecoveryCodes: json["two_factor_recovery_codes"],
        twoFactorConfirmedAt: json["two_factor_confirmed_at"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        role: json["role"] is Map ? json["role"]["name"] : json["role"], // Handle both object and string
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "two_factor_secret": twoFactorSecret,
        "two_factor_recovery_codes": twoFactorRecoveryCodes,
        "two_factor_confirmed_at": twoFactorConfirmedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "role": role,
    };
}

class Tenant {
    final int? id;
    final String? subdomain;
    final String? businessName;
    final String? status;
    final String? statusLabel;
    final DateTime? trialEndsAt;

    Tenant({
        this.id,
        this.subdomain,
        this.businessName,
        this.status,
        this.statusLabel,
        this.trialEndsAt,
    });

    factory Tenant.fromJson(String str) => Tenant.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Tenant.fromMap(Map<String, dynamic> json) => Tenant(
        id: json["id"],
        subdomain: json["subdomain"],
        businessName: json["business_name"],
        status: json["status"],
        statusLabel: json["status_label"],
        trialEndsAt: json["trial_ends_at"] == null ? null : DateTime.parse(json["trial_ends_at"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "subdomain": subdomain,
        "business_name": businessName,
        "status": status,
        "status_label": statusLabel,
        "trial_ends_at": trialEndsAt?.toIso8601String(),
    };
}
