// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HistoryEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() fetchPaidOrders,
    required TResult Function() fetchCookingOrders,
    required TResult Function() fetchCompletedOrders,
    required TResult Function(int orderId, String status) updateOrderStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? fetchPaidOrders,
    TResult? Function()? fetchCookingOrders,
    TResult? Function()? fetchCompletedOrders,
    TResult? Function(int orderId, String status)? updateOrderStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? fetchPaidOrders,
    TResult Function()? fetchCookingOrders,
    TResult Function()? fetchCompletedOrders,
    TResult Function(int orderId, String status)? updateOrderStatus,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_FetchPaidOrders value) fetchPaidOrders,
    required TResult Function(_FetchCookingOrders value) fetchCookingOrders,
    required TResult Function(_FetchCompletedOrders value) fetchCompletedOrders,
    required TResult Function(_UpdateOrderStatus value) updateOrderStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_FetchPaidOrders value)? fetchPaidOrders,
    TResult? Function(_FetchCookingOrders value)? fetchCookingOrders,
    TResult? Function(_FetchCompletedOrders value)? fetchCompletedOrders,
    TResult? Function(_UpdateOrderStatus value)? updateOrderStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_FetchPaidOrders value)? fetchPaidOrders,
    TResult Function(_FetchCookingOrders value)? fetchCookingOrders,
    TResult Function(_FetchCompletedOrders value)? fetchCompletedOrders,
    TResult Function(_UpdateOrderStatus value)? updateOrderStatus,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoryEventCopyWith<$Res> {
  factory $HistoryEventCopyWith(
          HistoryEvent value, $Res Function(HistoryEvent) then) =
      _$HistoryEventCopyWithImpl<$Res, HistoryEvent>;
}

/// @nodoc
class _$HistoryEventCopyWithImpl<$Res, $Val extends HistoryEvent>
    implements $HistoryEventCopyWith<$Res> {
  _$HistoryEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HistoryEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$StartedImplCopyWith<$Res> {
  factory _$$StartedImplCopyWith(
          _$StartedImpl value, $Res Function(_$StartedImpl) then) =
      __$$StartedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StartedImplCopyWithImpl<$Res>
    extends _$HistoryEventCopyWithImpl<$Res, _$StartedImpl>
    implements _$$StartedImplCopyWith<$Res> {
  __$$StartedImplCopyWithImpl(
      _$StartedImpl _value, $Res Function(_$StartedImpl) _then)
      : super(_value, _then);

  /// Create a copy of HistoryEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StartedImpl implements _Started {
  const _$StartedImpl();

  @override
  String toString() {
    return 'HistoryEvent.started()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$StartedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() fetchPaidOrders,
    required TResult Function() fetchCookingOrders,
    required TResult Function() fetchCompletedOrders,
    required TResult Function(int orderId, String status) updateOrderStatus,
  }) {
    return started();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? fetchPaidOrders,
    TResult? Function()? fetchCookingOrders,
    TResult? Function()? fetchCompletedOrders,
    TResult? Function(int orderId, String status)? updateOrderStatus,
  }) {
    return started?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? fetchPaidOrders,
    TResult Function()? fetchCookingOrders,
    TResult Function()? fetchCompletedOrders,
    TResult Function(int orderId, String status)? updateOrderStatus,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_FetchPaidOrders value) fetchPaidOrders,
    required TResult Function(_FetchCookingOrders value) fetchCookingOrders,
    required TResult Function(_FetchCompletedOrders value) fetchCompletedOrders,
    required TResult Function(_UpdateOrderStatus value) updateOrderStatus,
  }) {
    return started(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_FetchPaidOrders value)? fetchPaidOrders,
    TResult? Function(_FetchCookingOrders value)? fetchCookingOrders,
    TResult? Function(_FetchCompletedOrders value)? fetchCompletedOrders,
    TResult? Function(_UpdateOrderStatus value)? updateOrderStatus,
  }) {
    return started?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_FetchPaidOrders value)? fetchPaidOrders,
    TResult Function(_FetchCookingOrders value)? fetchCookingOrders,
    TResult Function(_FetchCompletedOrders value)? fetchCompletedOrders,
    TResult Function(_UpdateOrderStatus value)? updateOrderStatus,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started(this);
    }
    return orElse();
  }
}

abstract class _Started implements HistoryEvent {
  const factory _Started() = _$StartedImpl;
}

/// @nodoc
abstract class _$$FetchPaidOrdersImplCopyWith<$Res> {
  factory _$$FetchPaidOrdersImplCopyWith(_$FetchPaidOrdersImpl value,
          $Res Function(_$FetchPaidOrdersImpl) then) =
      __$$FetchPaidOrdersImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FetchPaidOrdersImplCopyWithImpl<$Res>
    extends _$HistoryEventCopyWithImpl<$Res, _$FetchPaidOrdersImpl>
    implements _$$FetchPaidOrdersImplCopyWith<$Res> {
  __$$FetchPaidOrdersImplCopyWithImpl(
      _$FetchPaidOrdersImpl _value, $Res Function(_$FetchPaidOrdersImpl) _then)
      : super(_value, _then);

  /// Create a copy of HistoryEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$FetchPaidOrdersImpl implements _FetchPaidOrders {
  const _$FetchPaidOrdersImpl();

  @override
  String toString() {
    return 'HistoryEvent.fetchPaidOrders()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$FetchPaidOrdersImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() fetchPaidOrders,
    required TResult Function() fetchCookingOrders,
    required TResult Function() fetchCompletedOrders,
    required TResult Function(int orderId, String status) updateOrderStatus,
  }) {
    return fetchPaidOrders();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? fetchPaidOrders,
    TResult? Function()? fetchCookingOrders,
    TResult? Function()? fetchCompletedOrders,
    TResult? Function(int orderId, String status)? updateOrderStatus,
  }) {
    return fetchPaidOrders?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? fetchPaidOrders,
    TResult Function()? fetchCookingOrders,
    TResult Function()? fetchCompletedOrders,
    TResult Function(int orderId, String status)? updateOrderStatus,
    required TResult orElse(),
  }) {
    if (fetchPaidOrders != null) {
      return fetchPaidOrders();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_FetchPaidOrders value) fetchPaidOrders,
    required TResult Function(_FetchCookingOrders value) fetchCookingOrders,
    required TResult Function(_FetchCompletedOrders value) fetchCompletedOrders,
    required TResult Function(_UpdateOrderStatus value) updateOrderStatus,
  }) {
    return fetchPaidOrders(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_FetchPaidOrders value)? fetchPaidOrders,
    TResult? Function(_FetchCookingOrders value)? fetchCookingOrders,
    TResult? Function(_FetchCompletedOrders value)? fetchCompletedOrders,
    TResult? Function(_UpdateOrderStatus value)? updateOrderStatus,
  }) {
    return fetchPaidOrders?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_FetchPaidOrders value)? fetchPaidOrders,
    TResult Function(_FetchCookingOrders value)? fetchCookingOrders,
    TResult Function(_FetchCompletedOrders value)? fetchCompletedOrders,
    TResult Function(_UpdateOrderStatus value)? updateOrderStatus,
    required TResult orElse(),
  }) {
    if (fetchPaidOrders != null) {
      return fetchPaidOrders(this);
    }
    return orElse();
  }
}

abstract class _FetchPaidOrders implements HistoryEvent {
  const factory _FetchPaidOrders() = _$FetchPaidOrdersImpl;
}

/// @nodoc
abstract class _$$FetchCookingOrdersImplCopyWith<$Res> {
  factory _$$FetchCookingOrdersImplCopyWith(_$FetchCookingOrdersImpl value,
          $Res Function(_$FetchCookingOrdersImpl) then) =
      __$$FetchCookingOrdersImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FetchCookingOrdersImplCopyWithImpl<$Res>
    extends _$HistoryEventCopyWithImpl<$Res, _$FetchCookingOrdersImpl>
    implements _$$FetchCookingOrdersImplCopyWith<$Res> {
  __$$FetchCookingOrdersImplCopyWithImpl(_$FetchCookingOrdersImpl _value,
      $Res Function(_$FetchCookingOrdersImpl) _then)
      : super(_value, _then);

  /// Create a copy of HistoryEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$FetchCookingOrdersImpl implements _FetchCookingOrders {
  const _$FetchCookingOrdersImpl();

  @override
  String toString() {
    return 'HistoryEvent.fetchCookingOrders()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$FetchCookingOrdersImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() fetchPaidOrders,
    required TResult Function() fetchCookingOrders,
    required TResult Function() fetchCompletedOrders,
    required TResult Function(int orderId, String status) updateOrderStatus,
  }) {
    return fetchCookingOrders();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? fetchPaidOrders,
    TResult? Function()? fetchCookingOrders,
    TResult? Function()? fetchCompletedOrders,
    TResult? Function(int orderId, String status)? updateOrderStatus,
  }) {
    return fetchCookingOrders?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? fetchPaidOrders,
    TResult Function()? fetchCookingOrders,
    TResult Function()? fetchCompletedOrders,
    TResult Function(int orderId, String status)? updateOrderStatus,
    required TResult orElse(),
  }) {
    if (fetchCookingOrders != null) {
      return fetchCookingOrders();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_FetchPaidOrders value) fetchPaidOrders,
    required TResult Function(_FetchCookingOrders value) fetchCookingOrders,
    required TResult Function(_FetchCompletedOrders value) fetchCompletedOrders,
    required TResult Function(_UpdateOrderStatus value) updateOrderStatus,
  }) {
    return fetchCookingOrders(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_FetchPaidOrders value)? fetchPaidOrders,
    TResult? Function(_FetchCookingOrders value)? fetchCookingOrders,
    TResult? Function(_FetchCompletedOrders value)? fetchCompletedOrders,
    TResult? Function(_UpdateOrderStatus value)? updateOrderStatus,
  }) {
    return fetchCookingOrders?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_FetchPaidOrders value)? fetchPaidOrders,
    TResult Function(_FetchCookingOrders value)? fetchCookingOrders,
    TResult Function(_FetchCompletedOrders value)? fetchCompletedOrders,
    TResult Function(_UpdateOrderStatus value)? updateOrderStatus,
    required TResult orElse(),
  }) {
    if (fetchCookingOrders != null) {
      return fetchCookingOrders(this);
    }
    return orElse();
  }
}

abstract class _FetchCookingOrders implements HistoryEvent {
  const factory _FetchCookingOrders() = _$FetchCookingOrdersImpl;
}

/// @nodoc
abstract class _$$FetchCompletedOrdersImplCopyWith<$Res> {
  factory _$$FetchCompletedOrdersImplCopyWith(_$FetchCompletedOrdersImpl value,
          $Res Function(_$FetchCompletedOrdersImpl) then) =
      __$$FetchCompletedOrdersImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FetchCompletedOrdersImplCopyWithImpl<$Res>
    extends _$HistoryEventCopyWithImpl<$Res, _$FetchCompletedOrdersImpl>
    implements _$$FetchCompletedOrdersImplCopyWith<$Res> {
  __$$FetchCompletedOrdersImplCopyWithImpl(_$FetchCompletedOrdersImpl _value,
      $Res Function(_$FetchCompletedOrdersImpl) _then)
      : super(_value, _then);

  /// Create a copy of HistoryEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$FetchCompletedOrdersImpl implements _FetchCompletedOrders {
  const _$FetchCompletedOrdersImpl();

  @override
  String toString() {
    return 'HistoryEvent.fetchCompletedOrders()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FetchCompletedOrdersImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() fetchPaidOrders,
    required TResult Function() fetchCookingOrders,
    required TResult Function() fetchCompletedOrders,
    required TResult Function(int orderId, String status) updateOrderStatus,
  }) {
    return fetchCompletedOrders();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? fetchPaidOrders,
    TResult? Function()? fetchCookingOrders,
    TResult? Function()? fetchCompletedOrders,
    TResult? Function(int orderId, String status)? updateOrderStatus,
  }) {
    return fetchCompletedOrders?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? fetchPaidOrders,
    TResult Function()? fetchCookingOrders,
    TResult Function()? fetchCompletedOrders,
    TResult Function(int orderId, String status)? updateOrderStatus,
    required TResult orElse(),
  }) {
    if (fetchCompletedOrders != null) {
      return fetchCompletedOrders();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_FetchPaidOrders value) fetchPaidOrders,
    required TResult Function(_FetchCookingOrders value) fetchCookingOrders,
    required TResult Function(_FetchCompletedOrders value) fetchCompletedOrders,
    required TResult Function(_UpdateOrderStatus value) updateOrderStatus,
  }) {
    return fetchCompletedOrders(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_FetchPaidOrders value)? fetchPaidOrders,
    TResult? Function(_FetchCookingOrders value)? fetchCookingOrders,
    TResult? Function(_FetchCompletedOrders value)? fetchCompletedOrders,
    TResult? Function(_UpdateOrderStatus value)? updateOrderStatus,
  }) {
    return fetchCompletedOrders?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_FetchPaidOrders value)? fetchPaidOrders,
    TResult Function(_FetchCookingOrders value)? fetchCookingOrders,
    TResult Function(_FetchCompletedOrders value)? fetchCompletedOrders,
    TResult Function(_UpdateOrderStatus value)? updateOrderStatus,
    required TResult orElse(),
  }) {
    if (fetchCompletedOrders != null) {
      return fetchCompletedOrders(this);
    }
    return orElse();
  }
}

abstract class _FetchCompletedOrders implements HistoryEvent {
  const factory _FetchCompletedOrders() = _$FetchCompletedOrdersImpl;
}

/// @nodoc
abstract class _$$UpdateOrderStatusImplCopyWith<$Res> {
  factory _$$UpdateOrderStatusImplCopyWith(_$UpdateOrderStatusImpl value,
          $Res Function(_$UpdateOrderStatusImpl) then) =
      __$$UpdateOrderStatusImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int orderId, String status});
}

/// @nodoc
class __$$UpdateOrderStatusImplCopyWithImpl<$Res>
    extends _$HistoryEventCopyWithImpl<$Res, _$UpdateOrderStatusImpl>
    implements _$$UpdateOrderStatusImplCopyWith<$Res> {
  __$$UpdateOrderStatusImplCopyWithImpl(_$UpdateOrderStatusImpl _value,
      $Res Function(_$UpdateOrderStatusImpl) _then)
      : super(_value, _then);

  /// Create a copy of HistoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? status = null,
  }) {
    return _then(_$UpdateOrderStatusImpl(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$UpdateOrderStatusImpl implements _UpdateOrderStatus {
  const _$UpdateOrderStatusImpl({required this.orderId, required this.status});

  @override
  final int orderId;
  @override
  final String status;

  @override
  String toString() {
    return 'HistoryEvent.updateOrderStatus(orderId: $orderId, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateOrderStatusImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, orderId, status);

  /// Create a copy of HistoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateOrderStatusImplCopyWith<_$UpdateOrderStatusImpl> get copyWith =>
      __$$UpdateOrderStatusImplCopyWithImpl<_$UpdateOrderStatusImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() fetchPaidOrders,
    required TResult Function() fetchCookingOrders,
    required TResult Function() fetchCompletedOrders,
    required TResult Function(int orderId, String status) updateOrderStatus,
  }) {
    return updateOrderStatus(orderId, status);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? fetchPaidOrders,
    TResult? Function()? fetchCookingOrders,
    TResult? Function()? fetchCompletedOrders,
    TResult? Function(int orderId, String status)? updateOrderStatus,
  }) {
    return updateOrderStatus?.call(orderId, status);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? fetchPaidOrders,
    TResult Function()? fetchCookingOrders,
    TResult Function()? fetchCompletedOrders,
    TResult Function(int orderId, String status)? updateOrderStatus,
    required TResult orElse(),
  }) {
    if (updateOrderStatus != null) {
      return updateOrderStatus(orderId, status);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_FetchPaidOrders value) fetchPaidOrders,
    required TResult Function(_FetchCookingOrders value) fetchCookingOrders,
    required TResult Function(_FetchCompletedOrders value) fetchCompletedOrders,
    required TResult Function(_UpdateOrderStatus value) updateOrderStatus,
  }) {
    return updateOrderStatus(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_FetchPaidOrders value)? fetchPaidOrders,
    TResult? Function(_FetchCookingOrders value)? fetchCookingOrders,
    TResult? Function(_FetchCompletedOrders value)? fetchCompletedOrders,
    TResult? Function(_UpdateOrderStatus value)? updateOrderStatus,
  }) {
    return updateOrderStatus?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_FetchPaidOrders value)? fetchPaidOrders,
    TResult Function(_FetchCookingOrders value)? fetchCookingOrders,
    TResult Function(_FetchCompletedOrders value)? fetchCompletedOrders,
    TResult Function(_UpdateOrderStatus value)? updateOrderStatus,
    required TResult orElse(),
  }) {
    if (updateOrderStatus != null) {
      return updateOrderStatus(this);
    }
    return orElse();
  }
}

abstract class _UpdateOrderStatus implements HistoryEvent {
  const factory _UpdateOrderStatus(
      {required final int orderId,
      required final String status}) = _$UpdateOrderStatusImpl;

  int get orderId;
  String get status;

  /// Create a copy of HistoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateOrderStatusImplCopyWith<_$UpdateOrderStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$HistoryState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<OrderResponseModel> orders) loaded,
    required TResult Function(String message) error,
    required TResult Function() statusUpdated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<OrderResponseModel> orders)? loaded,
    TResult? Function(String message)? error,
    TResult? Function()? statusUpdated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<OrderResponseModel> orders)? loaded,
    TResult Function(String message)? error,
    TResult Function()? statusUpdated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
    required TResult Function(_StatusUpdated value) statusUpdated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
    TResult? Function(_StatusUpdated value)? statusUpdated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    TResult Function(_StatusUpdated value)? statusUpdated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoryStateCopyWith<$Res> {
  factory $HistoryStateCopyWith(
          HistoryState value, $Res Function(HistoryState) then) =
      _$HistoryStateCopyWithImpl<$Res, HistoryState>;
}

/// @nodoc
class _$HistoryStateCopyWithImpl<$Res, $Val extends HistoryState>
    implements $HistoryStateCopyWith<$Res> {
  _$HistoryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$HistoryStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'HistoryState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<OrderResponseModel> orders) loaded,
    required TResult Function(String message) error,
    required TResult Function() statusUpdated,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<OrderResponseModel> orders)? loaded,
    TResult? Function(String message)? error,
    TResult? Function()? statusUpdated,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<OrderResponseModel> orders)? loaded,
    TResult Function(String message)? error,
    TResult Function()? statusUpdated,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
    required TResult Function(_StatusUpdated value) statusUpdated,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
    TResult? Function(_StatusUpdated value)? statusUpdated,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    TResult Function(_StatusUpdated value)? statusUpdated,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements HistoryState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl value, $Res Function(_$LoadingImpl) then) =
      __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$HistoryStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'HistoryState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<OrderResponseModel> orders) loaded,
    required TResult Function(String message) error,
    required TResult Function() statusUpdated,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<OrderResponseModel> orders)? loaded,
    TResult? Function(String message)? error,
    TResult? Function()? statusUpdated,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<OrderResponseModel> orders)? loaded,
    TResult Function(String message)? error,
    TResult Function()? statusUpdated,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
    required TResult Function(_StatusUpdated value) statusUpdated,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
    TResult? Function(_StatusUpdated value)? statusUpdated,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    TResult Function(_StatusUpdated value)? statusUpdated,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements HistoryState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$LoadedImplCopyWith<$Res> {
  factory _$$LoadedImplCopyWith(
          _$LoadedImpl value, $Res Function(_$LoadedImpl) then) =
      __$$LoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<OrderResponseModel> orders});
}

/// @nodoc
class __$$LoadedImplCopyWithImpl<$Res>
    extends _$HistoryStateCopyWithImpl<$Res, _$LoadedImpl>
    implements _$$LoadedImplCopyWith<$Res> {
  __$$LoadedImplCopyWithImpl(
      _$LoadedImpl _value, $Res Function(_$LoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orders = null,
  }) {
    return _then(_$LoadedImpl(
      null == orders
          ? _value._orders
          : orders // ignore: cast_nullable_to_non_nullable
              as List<OrderResponseModel>,
    ));
  }
}

/// @nodoc

class _$LoadedImpl implements _Loaded {
  const _$LoadedImpl(final List<OrderResponseModel> orders) : _orders = orders;

  final List<OrderResponseModel> _orders;
  @override
  List<OrderResponseModel> get orders {
    if (_orders is EqualUnmodifiableListView) return _orders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orders);
  }

  @override
  String toString() {
    return 'HistoryState.loaded(orders: $orders)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadedImpl &&
            const DeepCollectionEquality().equals(other._orders, _orders));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_orders));

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      __$$LoadedImplCopyWithImpl<_$LoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<OrderResponseModel> orders) loaded,
    required TResult Function(String message) error,
    required TResult Function() statusUpdated,
  }) {
    return loaded(orders);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<OrderResponseModel> orders)? loaded,
    TResult? Function(String message)? error,
    TResult? Function()? statusUpdated,
  }) {
    return loaded?.call(orders);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<OrderResponseModel> orders)? loaded,
    TResult Function(String message)? error,
    TResult Function()? statusUpdated,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(orders);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
    required TResult Function(_StatusUpdated value) statusUpdated,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
    TResult? Function(_StatusUpdated value)? statusUpdated,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    TResult Function(_StatusUpdated value)? statusUpdated,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _Loaded implements HistoryState {
  const factory _Loaded(final List<OrderResponseModel> orders) = _$LoadedImpl;

  List<OrderResponseModel> get orders;

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$HistoryStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'HistoryState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<OrderResponseModel> orders) loaded,
    required TResult Function(String message) error,
    required TResult Function() statusUpdated,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<OrderResponseModel> orders)? loaded,
    TResult? Function(String message)? error,
    TResult? Function()? statusUpdated,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<OrderResponseModel> orders)? loaded,
    TResult Function(String message)? error,
    TResult Function()? statusUpdated,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
    required TResult Function(_StatusUpdated value) statusUpdated,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
    TResult? Function(_StatusUpdated value)? statusUpdated,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    TResult Function(_StatusUpdated value)? statusUpdated,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements HistoryState {
  const factory _Error(final String message) = _$ErrorImpl;

  String get message;

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StatusUpdatedImplCopyWith<$Res> {
  factory _$$StatusUpdatedImplCopyWith(
          _$StatusUpdatedImpl value, $Res Function(_$StatusUpdatedImpl) then) =
      __$$StatusUpdatedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StatusUpdatedImplCopyWithImpl<$Res>
    extends _$HistoryStateCopyWithImpl<$Res, _$StatusUpdatedImpl>
    implements _$$StatusUpdatedImplCopyWith<$Res> {
  __$$StatusUpdatedImplCopyWithImpl(
      _$StatusUpdatedImpl _value, $Res Function(_$StatusUpdatedImpl) _then)
      : super(_value, _then);

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StatusUpdatedImpl implements _StatusUpdated {
  const _$StatusUpdatedImpl();

  @override
  String toString() {
    return 'HistoryState.statusUpdated()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$StatusUpdatedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<OrderResponseModel> orders) loaded,
    required TResult Function(String message) error,
    required TResult Function() statusUpdated,
  }) {
    return statusUpdated();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<OrderResponseModel> orders)? loaded,
    TResult? Function(String message)? error,
    TResult? Function()? statusUpdated,
  }) {
    return statusUpdated?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<OrderResponseModel> orders)? loaded,
    TResult Function(String message)? error,
    TResult Function()? statusUpdated,
    required TResult orElse(),
  }) {
    if (statusUpdated != null) {
      return statusUpdated();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
    required TResult Function(_StatusUpdated value) statusUpdated,
  }) {
    return statusUpdated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
    TResult? Function(_StatusUpdated value)? statusUpdated,
  }) {
    return statusUpdated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    TResult Function(_StatusUpdated value)? statusUpdated,
    required TResult orElse(),
  }) {
    if (statusUpdated != null) {
      return statusUpdated(this);
    }
    return orElse();
  }
}

abstract class _StatusUpdated implements HistoryState {
  const factory _StatusUpdated() = _$StatusUpdatedImpl;
}
