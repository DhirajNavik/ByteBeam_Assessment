// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'telemetry_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TelemetryEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TelemetryEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TelemetryEvent()';
}


}

/// @nodoc
class $TelemetryEventCopyWith<$Res>  {
$TelemetryEventCopyWith(TelemetryEvent _, $Res Function(TelemetryEvent) __);
}


/// Adds pattern-matching-related methods to [TelemetryEvent].
extension TelemetryEventPatterns on TelemetryEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Watch value)?  watch,TResult Function( _StopWatching value)?  stopWatching,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that);case _StopWatching() when stopWatching != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Watch value)  watch,required TResult Function( _StopWatching value)  stopWatching,}){
final _that = this;
switch (_that) {
case _Watch():
return watch(_that);case _StopWatching():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Watch value)?  watch,TResult? Function( _StopWatching value)?  stopWatching,}){
final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that);case _StopWatching() when stopWatching != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<int> vehicleIds)?  watch,TResult Function()?  stopWatching,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that.vehicleIds);case _StopWatching() when stopWatching != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<int> vehicleIds)  watch,required TResult Function()  stopWatching,}) {final _that = this;
switch (_that) {
case _Watch():
return watch(_that.vehicleIds);case _StopWatching():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<int> vehicleIds)?  watch,TResult? Function()?  stopWatching,}) {final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that.vehicleIds);case _StopWatching() when stopWatching != null:
return stopWatching();case _:
  return null;

}
}

}

/// @nodoc


class _Watch implements TelemetryEvent {
  const _Watch( List<int> vehicleIds): _vehicleIds = vehicleIds;
  

 final  List<int> _vehicleIds;
 List<int> get vehicleIds {
  if (_vehicleIds is EqualUnmodifiableListView) return _vehicleIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_vehicleIds);
}


/// Create a copy of TelemetryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchCopyWith<_Watch> get copyWith => __$WatchCopyWithImpl<_Watch>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Watch&&const DeepCollectionEquality().equals(other._vehicleIds, _vehicleIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_vehicleIds));

@override
String toString() {
  return 'TelemetryEvent.watch(vehicleIds: $vehicleIds)';
}


}

/// @nodoc
abstract mixin class _$WatchCopyWith<$Res> implements $TelemetryEventCopyWith<$Res> {
  factory _$WatchCopyWith(_Watch value, $Res Function(_Watch) _then) = __$WatchCopyWithImpl;
@useResult
$Res call({
 List<int> vehicleIds
});




}
/// @nodoc
class __$WatchCopyWithImpl<$Res>
    implements _$WatchCopyWith<$Res> {
  __$WatchCopyWithImpl(this._self, this._then);

  final _Watch _self;
  final $Res Function(_Watch) _then;

/// Create a copy of TelemetryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? vehicleIds = null,}) {
  return _then(_Watch(
null == vehicleIds ? _self._vehicleIds : vehicleIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

/// @nodoc


class _StopWatching implements TelemetryEvent {
  const _StopWatching();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StopWatching);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TelemetryEvent.stopWatching()';
}


}




/// @nodoc
mixin _$TelemetryState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TelemetryState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TelemetryState()';
}


}

/// @nodoc
class $TelemetryStateCopyWith<$Res>  {
$TelemetryStateCopyWith(TelemetryState _, $Res Function(TelemetryState) __);
}


/// Adds pattern-matching-related methods to [TelemetryState].
extension TelemetryStatePatterns on TelemetryState {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String message)?  error,TResult Function( Map<int, VehicleTelemetryEntity> byVehicleId)?  loaded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Error() when error != null:
return error(_that.message);case _Loaded() when loaded != null:
return loaded(_that.byVehicleId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String message)  error,required TResult Function( Map<int, VehicleTelemetryEntity> byVehicleId)  loaded,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Error():
return error(_that.message);case _Loaded():
return loaded(_that.byVehicleId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String message)?  error,TResult? Function( Map<int, VehicleTelemetryEntity> byVehicleId)?  loaded,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Error() when error != null:
return error(_that.message);case _Loaded() when loaded != null:
return loaded(_that.byVehicleId);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements TelemetryState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TelemetryState.initial()';
}


}




/// @nodoc


class _Loading implements TelemetryState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TelemetryState.loading()';
}


}




/// @nodoc


class _Error implements TelemetryState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of TelemetryState
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
  return 'TelemetryState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $TelemetryStateCopyWith<$Res> {
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

/// Create a copy of TelemetryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Loaded implements TelemetryState {
  const _Loaded( Map<int, VehicleTelemetryEntity> byVehicleId): _byVehicleId = byVehicleId;
  

 final  Map<int, VehicleTelemetryEntity> _byVehicleId;
 Map<int, VehicleTelemetryEntity> get byVehicleId {
  if (_byVehicleId is EqualUnmodifiableMapView) return _byVehicleId;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_byVehicleId);
}


/// Create a copy of TelemetryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._byVehicleId, _byVehicleId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_byVehicleId));

@override
String toString() {
  return 'TelemetryState.loaded(byVehicleId: $byVehicleId)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $TelemetryStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 Map<int, VehicleTelemetryEntity> byVehicleId
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of TelemetryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? byVehicleId = null,}) {
  return _then(_Loaded(
null == byVehicleId ? _self._byVehicleId : byVehicleId // ignore: cast_nullable_to_non_nullable
as Map<int, VehicleTelemetryEntity>,
  ));
}


}

// dart format on
