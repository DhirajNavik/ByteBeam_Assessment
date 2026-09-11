// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_details_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VehicleDetailsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleDetailsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VehicleDetailsEvent()';
}


}

/// @nodoc
class $VehicleDetailsEventCopyWith<$Res>  {
$VehicleDetailsEventCopyWith(VehicleDetailsEvent _, $Res Function(VehicleDetailsEvent) __);
}


/// Adds pattern-matching-related methods to [VehicleDetailsEvent].
extension VehicleDetailsEventPatterns on VehicleDetailsEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Watch value)?  watch,TResult Function( _WatchHistory value)?  watchHistory,TResult Function( _StopWatching value)?  stopWatching,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that);case _WatchHistory() when watchHistory != null:
return watchHistory(_that);case _StopWatching() when stopWatching != null:
return stopWatching(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Watch value)  watch,required TResult Function( _WatchHistory value)  watchHistory,required TResult Function( _StopWatching value)  stopWatching,}){
final _that = this;
switch (_that) {
case _Watch():
return watch(_that);case _WatchHistory():
return watchHistory(_that);case _StopWatching():
return stopWatching(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Watch value)?  watch,TResult? Function( _WatchHistory value)?  watchHistory,TResult? Function( _StopWatching value)?  stopWatching,}){
final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that);case _WatchHistory() when watchHistory != null:
return watchHistory(_that);case _StopWatching() when stopWatching != null:
return stopWatching(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int vehicleId)?  watch,TResult Function( int vehicleId)?  watchHistory,TResult Function()?  stopWatching,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that.vehicleId);case _WatchHistory() when watchHistory != null:
return watchHistory(_that.vehicleId);case _StopWatching() when stopWatching != null:
return stopWatching();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int vehicleId)  watch,required TResult Function( int vehicleId)  watchHistory,required TResult Function()  stopWatching,}) {final _that = this;
switch (_that) {
case _Watch():
return watch(_that.vehicleId);case _WatchHistory():
return watchHistory(_that.vehicleId);case _StopWatching():
return stopWatching();case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int vehicleId)?  watch,TResult? Function( int vehicleId)?  watchHistory,TResult? Function()?  stopWatching,}) {final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that.vehicleId);case _WatchHistory() when watchHistory != null:
return watchHistory(_that.vehicleId);case _StopWatching() when stopWatching != null:
return stopWatching();case _:
  return null;

}
}

}

/// @nodoc


class _Watch implements VehicleDetailsEvent {
  const _Watch({required this.vehicleId});
  

 final  int vehicleId;

/// Create a copy of VehicleDetailsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchCopyWith<_Watch> get copyWith => __$WatchCopyWithImpl<_Watch>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Watch&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId));
}


@override
int get hashCode => Object.hash(runtimeType,vehicleId);

@override
String toString() {
  return 'VehicleDetailsEvent.watch(vehicleId: $vehicleId)';
}


}

/// @nodoc
abstract mixin class _$WatchCopyWith<$Res> implements $VehicleDetailsEventCopyWith<$Res> {
  factory _$WatchCopyWith(_Watch value, $Res Function(_Watch) _then) = __$WatchCopyWithImpl;
@useResult
$Res call({
 int vehicleId
});




}
/// @nodoc
class __$WatchCopyWithImpl<$Res>
    implements _$WatchCopyWith<$Res> {
  __$WatchCopyWithImpl(this._self, this._then);

  final _Watch _self;
  final $Res Function(_Watch) _then;

/// Create a copy of VehicleDetailsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? vehicleId = null,}) {
  return _then(_Watch(
vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _WatchHistory implements VehicleDetailsEvent {
  const _WatchHistory({required this.vehicleId});
  

 final  int vehicleId;

/// Create a copy of VehicleDetailsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchHistoryCopyWith<_WatchHistory> get copyWith => __$WatchHistoryCopyWithImpl<_WatchHistory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchHistory&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId));
}


@override
int get hashCode => Object.hash(runtimeType,vehicleId);

@override
String toString() {
  return 'VehicleDetailsEvent.watchHistory(vehicleId: $vehicleId)';
}


}

/// @nodoc
abstract mixin class _$WatchHistoryCopyWith<$Res> implements $VehicleDetailsEventCopyWith<$Res> {
  factory _$WatchHistoryCopyWith(_WatchHistory value, $Res Function(_WatchHistory) _then) = __$WatchHistoryCopyWithImpl;
@useResult
$Res call({
 int vehicleId
});




}
/// @nodoc
class __$WatchHistoryCopyWithImpl<$Res>
    implements _$WatchHistoryCopyWith<$Res> {
  __$WatchHistoryCopyWithImpl(this._self, this._then);

  final _WatchHistory _self;
  final $Res Function(_WatchHistory) _then;

/// Create a copy of VehicleDetailsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? vehicleId = null,}) {
  return _then(_WatchHistory(
vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _StopWatching implements VehicleDetailsEvent {
  const _StopWatching();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StopWatching);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VehicleDetailsEvent.stopWatching()';
}


}




/// @nodoc
mixin _$VehicleDetailsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleDetailsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VehicleDetailsState()';
}


}

/// @nodoc
class $VehicleDetailsStateCopyWith<$Res>  {
$VehicleDetailsStateCopyWith(VehicleDetailsState _, $Res Function(VehicleDetailsState) __);
}


/// Adds pattern-matching-related methods to [VehicleDetailsState].
extension VehicleDetailsStatePatterns on VehicleDetailsState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Error value)?  error,TResult Function( _Loaded value)?  loaded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Error() when error != null:
return error(_that);case _Loaded() when loaded != null:
return loaded(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Error value)  error,required TResult Function( _Loaded value)  loaded,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Error():
return error(_that);case _Loaded():
return loaded(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Error value)?  error,TResult? Function( _Loaded value)?  loaded,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Error() when error != null:
return error(_that);case _Loaded() when loaded != null:
return loaded(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String message)?  error,TResult Function( VehicleTelemetryEntity? telemetry,  List<SOCHistoryEntity> socHistory)?  loaded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Error() when error != null:
return error(_that.message);case _Loaded() when loaded != null:
return loaded(_that.telemetry,_that.socHistory);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String message)  error,required TResult Function( VehicleTelemetryEntity? telemetry,  List<SOCHistoryEntity> socHistory)  loaded,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Error():
return error(_that.message);case _Loaded():
return loaded(_that.telemetry,_that.socHistory);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String message)?  error,TResult? Function( VehicleTelemetryEntity? telemetry,  List<SOCHistoryEntity> socHistory)?  loaded,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Error() when error != null:
return error(_that.message);case _Loaded() when loaded != null:
return loaded(_that.telemetry,_that.socHistory);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements VehicleDetailsState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VehicleDetailsState.initial()';
}


}




/// @nodoc


class _Loading implements VehicleDetailsState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VehicleDetailsState.loading()';
}


}




/// @nodoc


class _Error implements VehicleDetailsState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of VehicleDetailsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'VehicleDetailsState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $VehicleDetailsStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of VehicleDetailsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Loaded implements VehicleDetailsState {
  const _Loaded({this.telemetry = null,  List<SOCHistoryEntity> socHistory = const []}): _socHistory = socHistory;
  

@JsonKey() final  VehicleTelemetryEntity? telemetry;
 final  List<SOCHistoryEntity> _socHistory;
@JsonKey() List<SOCHistoryEntity> get socHistory {
  if (_socHistory is EqualUnmodifiableListView) return _socHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_socHistory);
}


/// Create a copy of VehicleDetailsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.telemetry, telemetry) || other.telemetry == telemetry)&&const DeepCollectionEquality().equals(other._socHistory, _socHistory));
}


@override
int get hashCode => Object.hash(runtimeType,telemetry,const DeepCollectionEquality().hash(_socHistory));

@override
String toString() {
  return 'VehicleDetailsState.loaded(telemetry: $telemetry, socHistory: $socHistory)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $VehicleDetailsStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 VehicleTelemetryEntity? telemetry, List<SOCHistoryEntity> socHistory
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of VehicleDetailsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? telemetry = freezed,Object? socHistory = null,}) {
  return _then(_Loaded(
telemetry: freezed == telemetry ? _self.telemetry : telemetry // ignore: cast_nullable_to_non_nullable
as VehicleTelemetryEntity?,socHistory: null == socHistory ? _self._socHistory : socHistory // ignore: cast_nullable_to_non_nullable
as List<SOCHistoryEntity>,
  ));
}


}

// dart format on
