// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'soc_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SOCHistoryModel {

 int get id; double get soc; DateTime? get time;
/// Create a copy of SOCHistoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SOCHistoryModelCopyWith<SOCHistoryModel> get copyWith => _$SOCHistoryModelCopyWithImpl<SOCHistoryModel>(this as SOCHistoryModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SOCHistoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.soc, soc) || other.soc == soc)&&(identical(other.time, time) || other.time == time));
}


@override
int get hashCode => Object.hash(runtimeType,id,soc,time);

@override
String toString() {
  return 'SOCHistoryModel(id: $id, soc: $soc, time: $time)';
}


}

/// @nodoc
abstract mixin class $SOCHistoryModelCopyWith<$Res>  {
  factory $SOCHistoryModelCopyWith(SOCHistoryModel value, $Res Function(SOCHistoryModel) _then) = _$SOCHistoryModelCopyWithImpl;
@useResult
$Res call({
 int id, double soc, DateTime? time
});




}
/// @nodoc
class _$SOCHistoryModelCopyWithImpl<$Res>
    implements $SOCHistoryModelCopyWith<$Res> {
  _$SOCHistoryModelCopyWithImpl(this._self, this._then);

  final SOCHistoryModel _self;
  final $Res Function(SOCHistoryModel) _then;

/// Create a copy of SOCHistoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? soc = null,Object? time = freezed,}) {
  return _then(SOCHistoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,soc: null == soc ? _self.soc : soc // ignore: cast_nullable_to_non_nullable
as double,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SOCHistoryModel].
extension SOCHistoryModelPatterns on SOCHistoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SOCHistoryModell value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SOCHistoryModell() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SOCHistoryModell value)  $default,){
final _that = this;
switch (_that) {
case _SOCHistoryModell():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SOCHistoryModell value)?  $default,){
final _that = this;
switch (_that) {
case _SOCHistoryModell() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  double soc,  DateTime? time)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SOCHistoryModell() when $default != null:
return $default(_that.id,_that.soc,_that.time);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  double soc,  DateTime? time)  $default,) {final _that = this;
switch (_that) {
case _SOCHistoryModell():
return $default(_that.id,_that.soc,_that.time);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  double soc,  DateTime? time)?  $default,) {final _that = this;
switch (_that) {
case _SOCHistoryModell() when $default != null:
return $default(_that.id,_that.soc,_that.time);case _:
  return null;

}
}

}

/// @nodoc


class _SOCHistoryModell extends SOCHistoryModel {
  const _SOCHistoryModell({required this.id, required this.soc, required this.time}): super._();
  

@override final  int id;
@override final  double soc;
@override final  DateTime? time;

/// Create a copy of SOCHistoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SOCHistoryModellCopyWith<_SOCHistoryModell> get copyWith => __$SOCHistoryModellCopyWithImpl<_SOCHistoryModell>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SOCHistoryModell&&(identical(other.id, id) || other.id == id)&&(identical(other.soc, soc) || other.soc == soc)&&(identical(other.time, time) || other.time == time));
}


@override
int get hashCode => Object.hash(runtimeType,id,soc,time);

@override
String toString() {
  return 'SOCHistoryModel(id: $id, soc: $soc, time: $time)';
}


}

/// @nodoc
abstract mixin class _$SOCHistoryModellCopyWith<$Res> implements $SOCHistoryModelCopyWith<$Res> {
  factory _$SOCHistoryModellCopyWith(_SOCHistoryModell value, $Res Function(_SOCHistoryModell) _then) = __$SOCHistoryModellCopyWithImpl;
@override @useResult
$Res call({
 int id, double soc, DateTime? time
});




}
/// @nodoc
class __$SOCHistoryModellCopyWithImpl<$Res>
    implements _$SOCHistoryModellCopyWith<$Res> {
  __$SOCHistoryModellCopyWithImpl(this._self, this._then);

  final _SOCHistoryModell _self;
  final $Res Function(_SOCHistoryModell) _then;

/// Create a copy of SOCHistoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? soc = null,Object? time = freezed,}) {
  return _then(_SOCHistoryModell(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,soc: null == soc ? _self.soc : soc // ignore: cast_nullable_to_non_nullable
as double,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
