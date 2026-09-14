// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geofence_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GeofenceEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeofenceEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GeofenceEvent()';
}


}

/// @nodoc
class $GeofenceEventCopyWith<$Res>  {
$GeofenceEventCopyWith(GeofenceEvent _, $Res Function(GeofenceEvent) __);
}


/// Adds pattern-matching-related methods to [GeofenceEvent].
extension GeofenceEventPatterns on GeofenceEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Watch value)?  watch,TResult Function( _Create value)?  create,TResult Function( _Update value)?  update,TResult Function( _Toggle value)?  toggle,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that);case _Create() when create != null:
return create(_that);case _Update() when update != null:
return update(_that);case _Toggle() when toggle != null:
return toggle(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Watch value)  watch,required TResult Function( _Create value)  create,required TResult Function( _Update value)  update,required TResult Function( _Toggle value)  toggle,}){
final _that = this;
switch (_that) {
case _Watch():
return watch(_that);case _Create():
return create(_that);case _Update():
return update(_that);case _Toggle():
return toggle(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Watch value)?  watch,TResult? Function( _Create value)?  create,TResult? Function( _Update value)?  update,TResult? Function( _Toggle value)?  toggle,}){
final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that);case _Create() when create != null:
return create(_that);case _Update() when update != null:
return update(_that);case _Toggle() when toggle != null:
return toggle(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  watch,TResult Function( String name,  double latitude,  double longitude,  double radiusMeters)?  create,TResult Function( int id,  String name,  double latitude,  double longitude,  double radiusMeters)?  update,TResult Function( int id,  bool isActive)?  toggle,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch();case _Create() when create != null:
return create(_that.name,_that.latitude,_that.longitude,_that.radiusMeters);case _Update() when update != null:
return update(_that.id,_that.name,_that.latitude,_that.longitude,_that.radiusMeters);case _Toggle() when toggle != null:
return toggle(_that.id,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  watch,required TResult Function( String name,  double latitude,  double longitude,  double radiusMeters)  create,required TResult Function( int id,  String name,  double latitude,  double longitude,  double radiusMeters)  update,required TResult Function( int id,  bool isActive)  toggle,}) {final _that = this;
switch (_that) {
case _Watch():
return watch();case _Create():
return create(_that.name,_that.latitude,_that.longitude,_that.radiusMeters);case _Update():
return update(_that.id,_that.name,_that.latitude,_that.longitude,_that.radiusMeters);case _Toggle():
return toggle(_that.id,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  watch,TResult? Function( String name,  double latitude,  double longitude,  double radiusMeters)?  create,TResult? Function( int id,  String name,  double latitude,  double longitude,  double radiusMeters)?  update,TResult? Function( int id,  bool isActive)?  toggle,}) {final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch();case _Create() when create != null:
return create(_that.name,_that.latitude,_that.longitude,_that.radiusMeters);case _Update() when update != null:
return update(_that.id,_that.name,_that.latitude,_that.longitude,_that.radiusMeters);case _Toggle() when toggle != null:
return toggle(_that.id,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc


class _Watch implements GeofenceEvent {
  const _Watch();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Watch);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GeofenceEvent.watch()';
}


}




/// @nodoc


class _Create implements GeofenceEvent {
  const _Create({required this.name, required this.latitude, required this.longitude, required this.radiusMeters});
  

 final  String name;
 final  double latitude;
 final  double longitude;
 final  double radiusMeters;

/// Create a copy of GeofenceEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateCopyWith<_Create> get copyWith => __$CreateCopyWithImpl<_Create>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Create&&(identical(other.name, name) || other.name == name)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.radiusMeters, radiusMeters) || other.radiusMeters == radiusMeters));
}


@override
int get hashCode => Object.hash(runtimeType,name,latitude,longitude,radiusMeters);

@override
String toString() {
  return 'GeofenceEvent.create(name: $name, latitude: $latitude, longitude: $longitude, radiusMeters: $radiusMeters)';
}


}

/// @nodoc
abstract mixin class _$CreateCopyWith<$Res> implements $GeofenceEventCopyWith<$Res> {
  factory _$CreateCopyWith(_Create value, $Res Function(_Create) _then) = __$CreateCopyWithImpl;
@useResult
$Res call({
 String name, double latitude, double longitude, double radiusMeters
});




}
/// @nodoc
class __$CreateCopyWithImpl<$Res>
    implements _$CreateCopyWith<$Res> {
  __$CreateCopyWithImpl(this._self, this._then);

  final _Create _self;
  final $Res Function(_Create) _then;

/// Create a copy of GeofenceEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,Object? latitude = null,Object? longitude = null,Object? radiusMeters = null,}) {
  return _then(_Create(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,radiusMeters: null == radiusMeters ? _self.radiusMeters : radiusMeters // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class _Update implements GeofenceEvent {
  const _Update({required this.id, required this.name, required this.latitude, required this.longitude, required this.radiusMeters});
  

 final  int id;
 final  String name;
 final  double latitude;
 final  double longitude;
 final  double radiusMeters;

/// Create a copy of GeofenceEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateCopyWith<_Update> get copyWith => __$UpdateCopyWithImpl<_Update>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Update&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.radiusMeters, radiusMeters) || other.radiusMeters == radiusMeters));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,latitude,longitude,radiusMeters);

@override
String toString() {
  return 'GeofenceEvent.update(id: $id, name: $name, latitude: $latitude, longitude: $longitude, radiusMeters: $radiusMeters)';
}


}

/// @nodoc
abstract mixin class _$UpdateCopyWith<$Res> implements $GeofenceEventCopyWith<$Res> {
  factory _$UpdateCopyWith(_Update value, $Res Function(_Update) _then) = __$UpdateCopyWithImpl;
@useResult
$Res call({
 int id, String name, double latitude, double longitude, double radiusMeters
});




}
/// @nodoc
class __$UpdateCopyWithImpl<$Res>
    implements _$UpdateCopyWith<$Res> {
  __$UpdateCopyWithImpl(this._self, this._then);

  final _Update _self;
  final $Res Function(_Update) _then;

/// Create a copy of GeofenceEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? latitude = null,Object? longitude = null,Object? radiusMeters = null,}) {
  return _then(_Update(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,radiusMeters: null == radiusMeters ? _self.radiusMeters : radiusMeters // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class _Toggle implements GeofenceEvent {
  const _Toggle({required this.id, required this.isActive});
  

 final  int id;
 final  bool isActive;

/// Create a copy of GeofenceEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ToggleCopyWith<_Toggle> get copyWith => __$ToggleCopyWithImpl<_Toggle>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Toggle&&(identical(other.id, id) || other.id == id)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,id,isActive);

@override
String toString() {
  return 'GeofenceEvent.toggle(id: $id, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$ToggleCopyWith<$Res> implements $GeofenceEventCopyWith<$Res> {
  factory _$ToggleCopyWith(_Toggle value, $Res Function(_Toggle) _then) = __$ToggleCopyWithImpl;
@useResult
$Res call({
 int id, bool isActive
});




}
/// @nodoc
class __$ToggleCopyWithImpl<$Res>
    implements _$ToggleCopyWith<$Res> {
  __$ToggleCopyWithImpl(this._self, this._then);

  final _Toggle _self;
  final $Res Function(_Toggle) _then;

/// Create a copy of GeofenceEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? isActive = null,}) {
  return _then(_Toggle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$GeofenceState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeofenceState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GeofenceState()';
}


}

/// @nodoc
class $GeofenceStateCopyWith<$Res>  {
$GeofenceStateCopyWith(GeofenceState _, $Res Function(GeofenceState) __);
}


/// Adds pattern-matching-related methods to [GeofenceState].
extension GeofenceStatePatterns on GeofenceState {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String message)?  error,TResult Function( List<GeofenceEntity> geofences,  Map<int, int> vehicleCounts,  List<VehicleGeofenceEntity> vehicleGeofences)?  loaded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Error() when error != null:
return error(_that.message);case _Loaded() when loaded != null:
return loaded(_that.geofences,_that.vehicleCounts,_that.vehicleGeofences);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String message)  error,required TResult Function( List<GeofenceEntity> geofences,  Map<int, int> vehicleCounts,  List<VehicleGeofenceEntity> vehicleGeofences)  loaded,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Error():
return error(_that.message);case _Loaded():
return loaded(_that.geofences,_that.vehicleCounts,_that.vehicleGeofences);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String message)?  error,TResult? Function( List<GeofenceEntity> geofences,  Map<int, int> vehicleCounts,  List<VehicleGeofenceEntity> vehicleGeofences)?  loaded,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Error() when error != null:
return error(_that.message);case _Loaded() when loaded != null:
return loaded(_that.geofences,_that.vehicleCounts,_that.vehicleGeofences);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements GeofenceState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GeofenceState.initial()';
}


}




/// @nodoc


class _Loading implements GeofenceState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GeofenceState.loading()';
}


}




/// @nodoc


class _Error implements GeofenceState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of GeofenceState
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
  return 'GeofenceState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $GeofenceStateCopyWith<$Res> {
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

/// Create a copy of GeofenceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Loaded implements GeofenceState {
  const _Loaded({required  List<GeofenceEntity> geofences,  Map<int, int> vehicleCounts = const {},  List<VehicleGeofenceEntity> vehicleGeofences = const []}): _geofences = geofences,_vehicleCounts = vehicleCounts,_vehicleGeofences = vehicleGeofences;
  

 final  List<GeofenceEntity> _geofences;
 List<GeofenceEntity> get geofences {
  if (_geofences is EqualUnmodifiableListView) return _geofences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_geofences);
}

 final  Map<int, int> _vehicleCounts;
@JsonKey() Map<int, int> get vehicleCounts {
  if (_vehicleCounts is EqualUnmodifiableMapView) return _vehicleCounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_vehicleCounts);
}

 final  List<VehicleGeofenceEntity> _vehicleGeofences;
@JsonKey() List<VehicleGeofenceEntity> get vehicleGeofences {
  if (_vehicleGeofences is EqualUnmodifiableListView) return _vehicleGeofences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_vehicleGeofences);
}


/// Create a copy of GeofenceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._geofences, _geofences)&&const DeepCollectionEquality().equals(other._vehicleCounts, _vehicleCounts)&&const DeepCollectionEquality().equals(other._vehicleGeofences, _vehicleGeofences));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_geofences),const DeepCollectionEquality().hash(_vehicleCounts),const DeepCollectionEquality().hash(_vehicleGeofences));

@override
String toString() {
  return 'GeofenceState.loaded(geofences: $geofences, vehicleCounts: $vehicleCounts, vehicleGeofences: $vehicleGeofences)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $GeofenceStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<GeofenceEntity> geofences, Map<int, int> vehicleCounts, List<VehicleGeofenceEntity> vehicleGeofences
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of GeofenceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? geofences = null,Object? vehicleCounts = null,Object? vehicleGeofences = null,}) {
  return _then(_Loaded(
geofences: null == geofences ? _self._geofences : geofences // ignore: cast_nullable_to_non_nullable
as List<GeofenceEntity>,vehicleCounts: null == vehicleCounts ? _self._vehicleCounts : vehicleCounts // ignore: cast_nullable_to_non_nullable
as Map<int, int>,vehicleGeofences: null == vehicleGeofences ? _self._vehicleGeofences : vehicleGeofences // ignore: cast_nullable_to_non_nullable
as List<VehicleGeofenceEntity>,
  ));
}


}

// dart format on
