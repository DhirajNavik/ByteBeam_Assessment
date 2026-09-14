// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_telemetry_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VehicleTelemetryModel {

 int get vehicleId; double? get soc; double? get speed; double? get batteryTemp; double? get range; double? get odometer; double? get latitude; double? get longitude; DateTime? get lastPingAt; FleetStatus get status;
/// Create a copy of VehicleTelemetryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleTelemetryModelCopyWith<VehicleTelemetryModel> get copyWith => _$VehicleTelemetryModelCopyWithImpl<VehicleTelemetryModel>(this as VehicleTelemetryModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleTelemetryModel&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.soc, soc) || other.soc == soc)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.batteryTemp, batteryTemp) || other.batteryTemp == batteryTemp)&&(identical(other.range, range) || other.range == range)&&(identical(other.odometer, odometer) || other.odometer == odometer)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.lastPingAt, lastPingAt) || other.lastPingAt == lastPingAt)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,vehicleId,soc,speed,batteryTemp,range,odometer,latitude,longitude,lastPingAt,status);

@override
String toString() {
  return 'VehicleTelemetryModel(vehicleId: $vehicleId, soc: $soc, speed: $speed, batteryTemp: $batteryTemp, range: $range, odometer: $odometer, latitude: $latitude, longitude: $longitude, lastPingAt: $lastPingAt, status: $status)';
}


}

/// @nodoc
abstract mixin class $VehicleTelemetryModelCopyWith<$Res>  {
  factory $VehicleTelemetryModelCopyWith(VehicleTelemetryModel value, $Res Function(VehicleTelemetryModel) _then) = _$VehicleTelemetryModelCopyWithImpl;
@useResult
$Res call({
 int vehicleId, double? soc, double? speed, double? batteryTemp, double? range, double? odometer, double? latitude, double? longitude, DateTime? lastPingAt, FleetStatus status
});




}
/// @nodoc
class _$VehicleTelemetryModelCopyWithImpl<$Res>
    implements $VehicleTelemetryModelCopyWith<$Res> {
  _$VehicleTelemetryModelCopyWithImpl(this._self, this._then);

  final VehicleTelemetryModel _self;
  final $Res Function(VehicleTelemetryModel) _then;

/// Create a copy of VehicleTelemetryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? vehicleId = null,Object? soc = freezed,Object? speed = freezed,Object? batteryTemp = freezed,Object? range = freezed,Object? odometer = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? lastPingAt = freezed,Object? status = null,}) {
  return _then(VehicleTelemetryModel(
vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as int,soc: freezed == soc ? _self.soc : soc // ignore: cast_nullable_to_non_nullable
as double?,speed: freezed == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double?,batteryTemp: freezed == batteryTemp ? _self.batteryTemp : batteryTemp // ignore: cast_nullable_to_non_nullable
as double?,range: freezed == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as double?,odometer: freezed == odometer ? _self.odometer : odometer // ignore: cast_nullable_to_non_nullable
as double?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,lastPingAt: freezed == lastPingAt ? _self.lastPingAt : lastPingAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FleetStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [VehicleTelemetryModel].
extension VehicleTelemetryModelPatterns on VehicleTelemetryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VehicleTelemetryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VehicleTelemetryModel() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VehicleTelemetryModel value)  $default,){
final _that = this;
switch (_that) {
case _VehicleTelemetryModel():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VehicleTelemetryModel value)?  $default,){
final _that = this;
switch (_that) {
case _VehicleTelemetryModel() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int vehicleId,  double? soc,  double? speed,  double? batteryTemp,  double? range,  double? odometer,  double? latitude,  double? longitude,  DateTime? lastPingAt,  FleetStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VehicleTelemetryModel() when $default != null:
return $default(_that.vehicleId,_that.soc,_that.speed,_that.batteryTemp,_that.range,_that.odometer,_that.latitude,_that.longitude,_that.lastPingAt,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int vehicleId,  double? soc,  double? speed,  double? batteryTemp,  double? range,  double? odometer,  double? latitude,  double? longitude,  DateTime? lastPingAt,  FleetStatus status)  $default,) {final _that = this;
switch (_that) {
case _VehicleTelemetryModel():
return $default(_that.vehicleId,_that.soc,_that.speed,_that.batteryTemp,_that.range,_that.odometer,_that.latitude,_that.longitude,_that.lastPingAt,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int vehicleId,  double? soc,  double? speed,  double? batteryTemp,  double? range,  double? odometer,  double? latitude,  double? longitude,  DateTime? lastPingAt,  FleetStatus status)?  $default,) {final _that = this;
switch (_that) {
case _VehicleTelemetryModel() when $default != null:
return $default(_that.vehicleId,_that.soc,_that.speed,_that.batteryTemp,_that.range,_that.odometer,_that.latitude,_that.longitude,_that.lastPingAt,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _VehicleTelemetryModel extends VehicleTelemetryModel {
  const _VehicleTelemetryModel({required this.vehicleId, required this.soc, required this.speed, required this.batteryTemp, required this.range, required this.odometer, required this.latitude, required this.longitude, required this.lastPingAt, required this.status}): super._();
  

@override final  int vehicleId;
@override final  double? soc;
@override final  double? speed;
@override final  double? batteryTemp;
@override final  double? range;
@override final  double? odometer;
@override final  double? latitude;
@override final  double? longitude;
@override final  DateTime? lastPingAt;
@override final  FleetStatus status;

/// Create a copy of VehicleTelemetryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VehicleTelemetryModelCopyWith<_VehicleTelemetryModel> get copyWith => __$VehicleTelemetryModelCopyWithImpl<_VehicleTelemetryModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VehicleTelemetryModel&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.soc, soc) || other.soc == soc)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.batteryTemp, batteryTemp) || other.batteryTemp == batteryTemp)&&(identical(other.range, range) || other.range == range)&&(identical(other.odometer, odometer) || other.odometer == odometer)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.lastPingAt, lastPingAt) || other.lastPingAt == lastPingAt)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,vehicleId,soc,speed,batteryTemp,range,odometer,latitude,longitude,lastPingAt,status);

@override
String toString() {
  return 'VehicleTelemetryModel(vehicleId: $vehicleId, soc: $soc, speed: $speed, batteryTemp: $batteryTemp, range: $range, odometer: $odometer, latitude: $latitude, longitude: $longitude, lastPingAt: $lastPingAt, status: $status)';
}


}

/// @nodoc
abstract mixin class _$VehicleTelemetryModelCopyWith<$Res> implements $VehicleTelemetryModelCopyWith<$Res> {
  factory _$VehicleTelemetryModelCopyWith(_VehicleTelemetryModel value, $Res Function(_VehicleTelemetryModel) _then) = __$VehicleTelemetryModelCopyWithImpl;
@override @useResult
$Res call({
 int vehicleId, double? soc, double? speed, double? batteryTemp, double? range, double? odometer, double? latitude, double? longitude, DateTime? lastPingAt, FleetStatus status
});




}
/// @nodoc
class __$VehicleTelemetryModelCopyWithImpl<$Res>
    implements _$VehicleTelemetryModelCopyWith<$Res> {
  __$VehicleTelemetryModelCopyWithImpl(this._self, this._then);

  final _VehicleTelemetryModel _self;
  final $Res Function(_VehicleTelemetryModel) _then;

/// Create a copy of VehicleTelemetryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? vehicleId = null,Object? soc = freezed,Object? speed = freezed,Object? batteryTemp = freezed,Object? range = freezed,Object? odometer = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? lastPingAt = freezed,Object? status = null,}) {
  return _then(_VehicleTelemetryModel(
vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as int,soc: freezed == soc ? _self.soc : soc // ignore: cast_nullable_to_non_nullable
as double?,speed: freezed == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double?,batteryTemp: freezed == batteryTemp ? _self.batteryTemp : batteryTemp // ignore: cast_nullable_to_non_nullable
as double?,range: freezed == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as double?,odometer: freezed == odometer ? _self.odometer : odometer // ignore: cast_nullable_to_non_nullable
as double?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,lastPingAt: freezed == lastPingAt ? _self.lastPingAt : lastPingAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FleetStatus,
  ));
}


}

// dart format on
