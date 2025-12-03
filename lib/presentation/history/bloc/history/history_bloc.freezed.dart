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
    required TResult Function(bool? isRefresh) fetchPaidOrders,
    required TResult Function(bool? isRefresh) fetchCookingOrders,
    required TResult Function(bool? isRefresh) fetchCompletedOrders,
    required TResult Function(int orderId, String status) updateOrderStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(bool? isRefresh)? fetchPaidOrders,
    TResult? Function(bool? isRefresh)? fetchCookingOrders,
    TResult? Function(bool? isRefresh)? fetchCompletedOrders,
    TResult? Function(int orderId, String status)? updateOrderStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(bool? isRefresh)? fetchPaidOrders,
    TResult Function(bool? isRefresh)? fetchCookingOrders,
    TResult Function(bool? isRefresh)? fetchCompletedOrders,
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
    required TResult Function(bool? isRefresh) fetchPaidOrders,
    required TResult Function(bool? isRefresh) fetchCookingOrders,
    required TResult Function(bool? isRefresh) fetchCompletedOrders,
    required TResult Function(int orderId, String status) updateOrderStatus,
  }) {
    return started();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(bool? isRefresh)? fetchPaidOrders,
    TResult? Function(bool? isRefresh)? fetchCookingOrders,
    TResult? Function(bool? isRefresh)? fetchCompletedOrders,
    TResult? Function(int orderId, String status)? updateOrderStatus,
  }) {
    return started?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(bool? isRefresh)? fetchPaidOrders,
    TResult Function(bool? isRefresh)? fetchCookingOrders,
    TResult Function(bool? isRefresh)? fetchCompletedOrders,
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
  @useResult
  $Res call({bool? isRefresh});
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
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRefresh = freezed,
  }) {
    return _then(_$FetchPaidOrdersImpl(
      isRefresh: freezed == isRefresh
          ? _value.isRefresh
          : isRefresh // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

class _$FetchPaidOrdersImpl implements _FetchPaidOrders {
  const _$FetchPaidOrdersImpl({this.isRefresh});

  @override
  final bool? isRefresh;

  @override
  String toString() {
    return 'HistoryEvent.fetchPaidOrders(isRefresh: $isRefresh)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FetchPaidOrdersImpl &&
            (identical(other.isRefresh, isRefresh) ||
                other.isRefresh == isRefresh));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isRefresh);

  /// Create a copy of HistoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FetchPaidOrdersImplCopyWith<_$FetchPaidOrdersImpl> get copyWith =>
      __$$FetchPaidOrdersImplCopyWithImpl<_$FetchPaidOrdersImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(bool? isRefresh) fetchPaidOrders,
    required TResult Function(bool? isRefresh) fetchCookingOrders,
    required TResult Function(bool? isRefresh) fetchCompletedOrders,
    required TResult Function(int orderId, String status) updateOrderStatus,
  }) {
    return fetchPaidOrders(isRefresh);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(bool? isRefresh)? fetchPaidOrders,
    TResult? Function(bool? isRefresh)? fetchCookingOrders,
    TResult? Function(bool? isRefresh)? fetchCompletedOrders,
    TResult? Function(int orderId, String status)? updateOrderStatus,
  }) {
    return fetchPaidOrders?.call(isRefresh);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(bool? isRefresh)? fetchPaidOrders,
    TResult Function(bool? isRefresh)? fetchCookingOrders,
    TResult Function(bool? isRefresh)? fetchCompletedOrders,
    TResult Function(int orderId, String status)? updateOrderStatus,
    required TResult orElse(),
  }) {
    if (fetchPaidOrders != null) {
      return fetchPaidOrders(isRefresh);
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
  const factory _FetchPaidOrders({final bool? isRefresh}) =
      _$FetchPaidOrdersImpl;

  bool? get isRefresh;

  /// Create a copy of HistoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FetchPaidOrdersImplCopyWith<_$FetchPaidOrdersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FetchCookingOrdersImplCopyWith<$Res> {
  factory _$$FetchCookingOrdersImplCopyWith(_$FetchCookingOrdersImpl value,
          $Res Function(_$FetchCookingOrdersImpl) then) =
      __$$FetchCookingOrdersImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool? isRefresh});
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
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRefresh = freezed,
  }) {
    return _then(_$FetchCookingOrdersImpl(
      isRefresh: freezed == isRefresh
          ? _value.isRefresh
          : isRefresh // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

class _$FetchCookingOrdersImpl implements _FetchCookingOrders {
  const _$FetchCookingOrdersImpl({this.isRefresh});

  @override
  final bool? isRefresh;

  @override
  String toString() {
    return 'HistoryEvent.fetchCookingOrders(isRefresh: $isRefresh)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FetchCookingOrdersImpl &&
            (identical(other.isRefresh, isRefresh) ||
                other.isRefresh == isRefresh));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isRefresh);

  /// Create a copy of HistoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FetchCookingOrdersImplCopyWith<_$FetchCookingOrdersImpl> get copyWith =>
      __$$FetchCookingOrdersImplCopyWithImpl<_$FetchCookingOrdersImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(bool? isRefresh) fetchPaidOrders,
    required TResult Function(bool? isRefresh) fetchCookingOrders,
    required TResult Function(bool? isRefresh) fetchCompletedOrders,
    required TResult Function(int orderId, String status) updateOrderStatus,
  }) {
    return fetchCookingOrders(isRefresh);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(bool? isRefresh)? fetchPaidOrders,
    TResult? Function(bool? isRefresh)? fetchCookingOrders,
    TResult? Function(bool? isRefresh)? fetchCompletedOrders,
    TResult? Function(int orderId, String status)? updateOrderStatus,
  }) {
    return fetchCookingOrders?.call(isRefresh);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(bool? isRefresh)? fetchPaidOrders,
    TResult Function(bool? isRefresh)? fetchCookingOrders,
    TResult Function(bool? isRefresh)? fetchCompletedOrders,
    TResult Function(int orderId, String status)? updateOrderStatus,
    required TResult orElse(),
  }) {
    if (fetchCookingOrders != null) {
      return fetchCookingOrders(isRefresh);
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
  const factory _FetchCookingOrders({final bool? isRefresh}) =
      _$FetchCookingOrdersImpl;

  bool? get isRefresh;

  /// Create a copy of HistoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FetchCookingOrdersImplCopyWith<_$FetchCookingOrdersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FetchCompletedOrdersImplCopyWith<$Res> {
  factory _$$FetchCompletedOrdersImplCopyWith(_$FetchCompletedOrdersImpl value,
          $Res Function(_$FetchCompletedOrdersImpl) then) =
      __$$FetchCompletedOrdersImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool? isRefresh});
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
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRefresh = freezed,
  }) {
    return _then(_$FetchCompletedOrdersImpl(
      isRefresh: freezed == isRefresh
          ? _value.isRefresh
          : isRefresh // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

class _$FetchCompletedOrdersImpl implements _FetchCompletedOrders {
  const _$FetchCompletedOrdersImpl({this.isRefresh});

  @override
  final bool? isRefresh;

  @override
  String toString() {
    return 'HistoryEvent.fetchCompletedOrders(isRefresh: $isRefresh)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FetchCompletedOrdersImpl &&
            (identical(other.isRefresh, isRefresh) ||
                other.isRefresh == isRefresh));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isRefresh);

  /// Create a copy of HistoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FetchCompletedOrdersImplCopyWith<_$FetchCompletedOrdersImpl>
      get copyWith =>
          __$$FetchCompletedOrdersImplCopyWithImpl<_$FetchCompletedOrdersImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(bool? isRefresh) fetchPaidOrders,
    required TResult Function(bool? isRefresh) fetchCookingOrders,
    required TResult Function(bool? isRefresh) fetchCompletedOrders,
    required TResult Function(int orderId, String status) updateOrderStatus,
  }) {
    return fetchCompletedOrders(isRefresh);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(bool? isRefresh)? fetchPaidOrders,
    TResult? Function(bool? isRefresh)? fetchCookingOrders,
    TResult? Function(bool? isRefresh)? fetchCompletedOrders,
    TResult? Function(int orderId, String status)? updateOrderStatus,
  }) {
    return fetchCompletedOrders?.call(isRefresh);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(bool? isRefresh)? fetchPaidOrders,
    TResult Function(bool? isRefresh)? fetchCookingOrders,
    TResult Function(bool? isRefresh)? fetchCompletedOrders,
    TResult Function(int orderId, String status)? updateOrderStatus,
    required TResult orElse(),
  }) {
    if (fetchCompletedOrders != null) {
      return fetchCompletedOrders(isRefresh);
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
  const factory _FetchCompletedOrders({final bool? isRefresh}) =
      _$FetchCompletedOrdersImpl;

  bool? get isRefresh;

  /// Create a copy of HistoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FetchCompletedOrdersImplCopyWith<_$FetchCompletedOrdersImpl>
      get copyWith => throw _privateConstructorUsedError;
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
    required TResult Function(bool? isRefresh) fetchPaidOrders,
    required TResult Function(bool? isRefresh) fetchCookingOrders,
    required TResult Function(bool? isRefresh) fetchCompletedOrders,
    required TResult Function(int orderId, String status) updateOrderStatus,
  }) {
    return updateOrderStatus(orderId, status);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(bool? isRefresh)? fetchPaidOrders,
    TResult? Function(bool? isRefresh)? fetchCookingOrders,
    TResult? Function(bool? isRefresh)? fetchCompletedOrders,
    TResult? Function(int orderId, String status)? updateOrderStatus,
  }) {
    return updateOrderStatus?.call(orderId, status);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(bool? isRefresh)? fetchPaidOrders,
    TResult Function(bool? isRefresh)? fetchCookingOrders,
    TResult Function(bool? isRefresh)? fetchCompletedOrders,
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
  List<OrderResponseModel> get paidOrders => throw _privateConstructorUsedError;
  List<OrderResponseModel> get cookingOrders =>
      throw _privateConstructorUsedError;
  List<OrderResponseModel> get completedOrders =>
      throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  bool get isStatusUpdated => throw _privateConstructorUsedError;

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HistoryStateCopyWith<HistoryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoryStateCopyWith<$Res> {
  factory $HistoryStateCopyWith(
          HistoryState value, $Res Function(HistoryState) then) =
      _$HistoryStateCopyWithImpl<$Res, HistoryState>;
  @useResult
  $Res call(
      {List<OrderResponseModel> paidOrders,
      List<OrderResponseModel> cookingOrders,
      List<OrderResponseModel> completedOrders,
      bool isLoading,
      String? errorMessage,
      bool isStatusUpdated});
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
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paidOrders = null,
    Object? cookingOrders = null,
    Object? completedOrders = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? isStatusUpdated = null,
  }) {
    return _then(_value.copyWith(
      paidOrders: null == paidOrders
          ? _value.paidOrders
          : paidOrders // ignore: cast_nullable_to_non_nullable
              as List<OrderResponseModel>,
      cookingOrders: null == cookingOrders
          ? _value.cookingOrders
          : cookingOrders // ignore: cast_nullable_to_non_nullable
              as List<OrderResponseModel>,
      completedOrders: null == completedOrders
          ? _value.completedOrders
          : completedOrders // ignore: cast_nullable_to_non_nullable
              as List<OrderResponseModel>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      isStatusUpdated: null == isStatusUpdated
          ? _value.isStatusUpdated
          : isStatusUpdated // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HistoryStateImplCopyWith<$Res>
    implements $HistoryStateCopyWith<$Res> {
  factory _$$HistoryStateImplCopyWith(
          _$HistoryStateImpl value, $Res Function(_$HistoryStateImpl) then) =
      __$$HistoryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<OrderResponseModel> paidOrders,
      List<OrderResponseModel> cookingOrders,
      List<OrderResponseModel> completedOrders,
      bool isLoading,
      String? errorMessage,
      bool isStatusUpdated});
}

/// @nodoc
class __$$HistoryStateImplCopyWithImpl<$Res>
    extends _$HistoryStateCopyWithImpl<$Res, _$HistoryStateImpl>
    implements _$$HistoryStateImplCopyWith<$Res> {
  __$$HistoryStateImplCopyWithImpl(
      _$HistoryStateImpl _value, $Res Function(_$HistoryStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paidOrders = null,
    Object? cookingOrders = null,
    Object? completedOrders = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? isStatusUpdated = null,
  }) {
    return _then(_$HistoryStateImpl(
      paidOrders: null == paidOrders
          ? _value._paidOrders
          : paidOrders // ignore: cast_nullable_to_non_nullable
              as List<OrderResponseModel>,
      cookingOrders: null == cookingOrders
          ? _value._cookingOrders
          : cookingOrders // ignore: cast_nullable_to_non_nullable
              as List<OrderResponseModel>,
      completedOrders: null == completedOrders
          ? _value._completedOrders
          : completedOrders // ignore: cast_nullable_to_non_nullable
              as List<OrderResponseModel>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      isStatusUpdated: null == isStatusUpdated
          ? _value.isStatusUpdated
          : isStatusUpdated // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$HistoryStateImpl implements _HistoryState {
  const _$HistoryStateImpl(
      {final List<OrderResponseModel> paidOrders = const [],
      final List<OrderResponseModel> cookingOrders = const [],
      final List<OrderResponseModel> completedOrders = const [],
      this.isLoading = false,
      this.errorMessage,
      this.isStatusUpdated = false})
      : _paidOrders = paidOrders,
        _cookingOrders = cookingOrders,
        _completedOrders = completedOrders;

  final List<OrderResponseModel> _paidOrders;
  @override
  @JsonKey()
  List<OrderResponseModel> get paidOrders {
    if (_paidOrders is EqualUnmodifiableListView) return _paidOrders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_paidOrders);
  }

  final List<OrderResponseModel> _cookingOrders;
  @override
  @JsonKey()
  List<OrderResponseModel> get cookingOrders {
    if (_cookingOrders is EqualUnmodifiableListView) return _cookingOrders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cookingOrders);
  }

  final List<OrderResponseModel> _completedOrders;
  @override
  @JsonKey()
  List<OrderResponseModel> get completedOrders {
    if (_completedOrders is EqualUnmodifiableListView) return _completedOrders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_completedOrders);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;
  @override
  @JsonKey()
  final bool isStatusUpdated;

  @override
  String toString() {
    return 'HistoryState(paidOrders: $paidOrders, cookingOrders: $cookingOrders, completedOrders: $completedOrders, isLoading: $isLoading, errorMessage: $errorMessage, isStatusUpdated: $isStatusUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoryStateImpl &&
            const DeepCollectionEquality()
                .equals(other._paidOrders, _paidOrders) &&
            const DeepCollectionEquality()
                .equals(other._cookingOrders, _cookingOrders) &&
            const DeepCollectionEquality()
                .equals(other._completedOrders, _completedOrders) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.isStatusUpdated, isStatusUpdated) ||
                other.isStatusUpdated == isStatusUpdated));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_paidOrders),
      const DeepCollectionEquality().hash(_cookingOrders),
      const DeepCollectionEquality().hash(_completedOrders),
      isLoading,
      errorMessage,
      isStatusUpdated);

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoryStateImplCopyWith<_$HistoryStateImpl> get copyWith =>
      __$$HistoryStateImplCopyWithImpl<_$HistoryStateImpl>(this, _$identity);
}

abstract class _HistoryState implements HistoryState {
  const factory _HistoryState(
      {final List<OrderResponseModel> paidOrders,
      final List<OrderResponseModel> cookingOrders,
      final List<OrderResponseModel> completedOrders,
      final bool isLoading,
      final String? errorMessage,
      final bool isStatusUpdated}) = _$HistoryStateImpl;

  @override
  List<OrderResponseModel> get paidOrders;
  @override
  List<OrderResponseModel> get cookingOrders;
  @override
  List<OrderResponseModel> get completedOrders;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;
  @override
  bool get isStatusUpdated;

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HistoryStateImplCopyWith<_$HistoryStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
