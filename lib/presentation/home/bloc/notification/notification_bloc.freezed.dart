// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NotificationEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() startPolling,
    required TResult Function() stopPolling,
    required TResult Function() checkOrders,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? startPolling,
    TResult? Function()? stopPolling,
    TResult? Function()? checkOrders,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? startPolling,
    TResult Function()? stopPolling,
    TResult Function()? checkOrders,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StartPolling value) startPolling,
    required TResult Function(_StopPolling value) stopPolling,
    required TResult Function(_CheckOrders value) checkOrders,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StartPolling value)? startPolling,
    TResult? Function(_StopPolling value)? stopPolling,
    TResult? Function(_CheckOrders value)? checkOrders,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StartPolling value)? startPolling,
    TResult Function(_StopPolling value)? stopPolling,
    TResult Function(_CheckOrders value)? checkOrders,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationEventCopyWith<$Res> {
  factory $NotificationEventCopyWith(
          NotificationEvent value, $Res Function(NotificationEvent) then) =
      _$NotificationEventCopyWithImpl<$Res, NotificationEvent>;
}

/// @nodoc
class _$NotificationEventCopyWithImpl<$Res, $Val extends NotificationEvent>
    implements $NotificationEventCopyWith<$Res> {
  _$NotificationEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$StartPollingImplCopyWith<$Res> {
  factory _$$StartPollingImplCopyWith(
          _$StartPollingImpl value, $Res Function(_$StartPollingImpl) then) =
      __$$StartPollingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StartPollingImplCopyWithImpl<$Res>
    extends _$NotificationEventCopyWithImpl<$Res, _$StartPollingImpl>
    implements _$$StartPollingImplCopyWith<$Res> {
  __$$StartPollingImplCopyWithImpl(
      _$StartPollingImpl _value, $Res Function(_$StartPollingImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StartPollingImpl implements _StartPolling {
  const _$StartPollingImpl();

  @override
  String toString() {
    return 'NotificationEvent.startPolling()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$StartPollingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() startPolling,
    required TResult Function() stopPolling,
    required TResult Function() checkOrders,
  }) {
    return startPolling();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? startPolling,
    TResult? Function()? stopPolling,
    TResult? Function()? checkOrders,
  }) {
    return startPolling?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? startPolling,
    TResult Function()? stopPolling,
    TResult Function()? checkOrders,
    required TResult orElse(),
  }) {
    if (startPolling != null) {
      return startPolling();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StartPolling value) startPolling,
    required TResult Function(_StopPolling value) stopPolling,
    required TResult Function(_CheckOrders value) checkOrders,
  }) {
    return startPolling(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StartPolling value)? startPolling,
    TResult? Function(_StopPolling value)? stopPolling,
    TResult? Function(_CheckOrders value)? checkOrders,
  }) {
    return startPolling?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StartPolling value)? startPolling,
    TResult Function(_StopPolling value)? stopPolling,
    TResult Function(_CheckOrders value)? checkOrders,
    required TResult orElse(),
  }) {
    if (startPolling != null) {
      return startPolling(this);
    }
    return orElse();
  }
}

abstract class _StartPolling implements NotificationEvent {
  const factory _StartPolling() = _$StartPollingImpl;
}

/// @nodoc
abstract class _$$StopPollingImplCopyWith<$Res> {
  factory _$$StopPollingImplCopyWith(
          _$StopPollingImpl value, $Res Function(_$StopPollingImpl) then) =
      __$$StopPollingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StopPollingImplCopyWithImpl<$Res>
    extends _$NotificationEventCopyWithImpl<$Res, _$StopPollingImpl>
    implements _$$StopPollingImplCopyWith<$Res> {
  __$$StopPollingImplCopyWithImpl(
      _$StopPollingImpl _value, $Res Function(_$StopPollingImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StopPollingImpl implements _StopPolling {
  const _$StopPollingImpl();

  @override
  String toString() {
    return 'NotificationEvent.stopPolling()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$StopPollingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() startPolling,
    required TResult Function() stopPolling,
    required TResult Function() checkOrders,
  }) {
    return stopPolling();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? startPolling,
    TResult? Function()? stopPolling,
    TResult? Function()? checkOrders,
  }) {
    return stopPolling?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? startPolling,
    TResult Function()? stopPolling,
    TResult Function()? checkOrders,
    required TResult orElse(),
  }) {
    if (stopPolling != null) {
      return stopPolling();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StartPolling value) startPolling,
    required TResult Function(_StopPolling value) stopPolling,
    required TResult Function(_CheckOrders value) checkOrders,
  }) {
    return stopPolling(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StartPolling value)? startPolling,
    TResult? Function(_StopPolling value)? stopPolling,
    TResult? Function(_CheckOrders value)? checkOrders,
  }) {
    return stopPolling?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StartPolling value)? startPolling,
    TResult Function(_StopPolling value)? stopPolling,
    TResult Function(_CheckOrders value)? checkOrders,
    required TResult orElse(),
  }) {
    if (stopPolling != null) {
      return stopPolling(this);
    }
    return orElse();
  }
}

abstract class _StopPolling implements NotificationEvent {
  const factory _StopPolling() = _$StopPollingImpl;
}

/// @nodoc
abstract class _$$CheckOrdersImplCopyWith<$Res> {
  factory _$$CheckOrdersImplCopyWith(
          _$CheckOrdersImpl value, $Res Function(_$CheckOrdersImpl) then) =
      __$$CheckOrdersImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CheckOrdersImplCopyWithImpl<$Res>
    extends _$NotificationEventCopyWithImpl<$Res, _$CheckOrdersImpl>
    implements _$$CheckOrdersImplCopyWith<$Res> {
  __$$CheckOrdersImplCopyWithImpl(
      _$CheckOrdersImpl _value, $Res Function(_$CheckOrdersImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CheckOrdersImpl implements _CheckOrders {
  const _$CheckOrdersImpl();

  @override
  String toString() {
    return 'NotificationEvent.checkOrders()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CheckOrdersImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() startPolling,
    required TResult Function() stopPolling,
    required TResult Function() checkOrders,
  }) {
    return checkOrders();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? startPolling,
    TResult? Function()? stopPolling,
    TResult? Function()? checkOrders,
  }) {
    return checkOrders?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? startPolling,
    TResult Function()? stopPolling,
    TResult Function()? checkOrders,
    required TResult orElse(),
  }) {
    if (checkOrders != null) {
      return checkOrders();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StartPolling value) startPolling,
    required TResult Function(_StopPolling value) stopPolling,
    required TResult Function(_CheckOrders value) checkOrders,
  }) {
    return checkOrders(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StartPolling value)? startPolling,
    TResult? Function(_StopPolling value)? stopPolling,
    TResult? Function(_CheckOrders value)? checkOrders,
  }) {
    return checkOrders?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StartPolling value)? startPolling,
    TResult Function(_StopPolling value)? stopPolling,
    TResult Function(_CheckOrders value)? checkOrders,
    required TResult orElse(),
  }) {
    if (checkOrders != null) {
      return checkOrders(this);
    }
    return orElse();
  }
}

abstract class _CheckOrders implements NotificationEvent {
  const factory _CheckOrders() = _$CheckOrdersImpl;
}

/// @nodoc
mixin _$NotificationState {
  int get orderCount => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int orderCount) initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int orderCount)? initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int orderCount)? initial,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of NotificationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationStateCopyWith<NotificationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationStateCopyWith<$Res> {
  factory $NotificationStateCopyWith(
          NotificationState value, $Res Function(NotificationState) then) =
      _$NotificationStateCopyWithImpl<$Res, NotificationState>;
  @useResult
  $Res call({int orderCount});
}

/// @nodoc
class _$NotificationStateCopyWithImpl<$Res, $Val extends NotificationState>
    implements $NotificationStateCopyWith<$Res> {
  _$NotificationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderCount = null,
  }) {
    return _then(_value.copyWith(
      orderCount: null == orderCount
          ? _value.orderCount
          : orderCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res>
    implements $NotificationStateCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int orderCount});
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$NotificationStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderCount = null,
  }) {
    return _then(_$InitialImpl(
      orderCount: null == orderCount
          ? _value.orderCount
          : orderCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl({this.orderCount = 0});

  @override
  @JsonKey()
  final int orderCount;

  @override
  String toString() {
    return 'NotificationState.initial(orderCount: $orderCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InitialImpl &&
            (identical(other.orderCount, orderCount) ||
                other.orderCount == orderCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, orderCount);

  /// Create a copy of NotificationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InitialImplCopyWith<_$InitialImpl> get copyWith =>
      __$$InitialImplCopyWithImpl<_$InitialImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int orderCount) initial,
  }) {
    return initial(orderCount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int orderCount)? initial,
  }) {
    return initial?.call(orderCount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int orderCount)? initial,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(orderCount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements NotificationState {
  const factory _Initial({final int orderCount}) = _$InitialImpl;

  @override
  int get orderCount;

  /// Create a copy of NotificationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InitialImplCopyWith<_$InitialImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
