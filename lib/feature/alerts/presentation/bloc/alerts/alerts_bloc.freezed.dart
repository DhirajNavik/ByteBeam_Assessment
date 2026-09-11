// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alerts_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AlertsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlertsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AlertsEvent()';
}


}

/// @nodoc
class $AlertsEventCopyWith<$Res>  {
$AlertsEventCopyWith(AlertsEvent _, $Res Function(AlertsEvent) __);
}


/// Adds pattern-matching-related methods to [AlertsEvent].
extension AlertsEventPatterns on AlertsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Watch value)?  watch,TResult Function( _Dismiss value)?  dismiss,TResult Function( _UndoDismiss value)?  undoDismiss,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that);case _Dismiss() when dismiss != null:
return dismiss(_that);case _UndoDismiss() when undoDismiss != null:
return undoDismiss(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Watch value)  watch,required TResult Function( _Dismiss value)  dismiss,required TResult Function( _UndoDismiss value)  undoDismiss,}){
final _that = this;
switch (_that) {
case _Watch():
return watch(_that);case _Dismiss():
return dismiss(_that);case _UndoDismiss():
return undoDismiss(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Watch value)?  watch,TResult? Function( _Dismiss value)?  dismiss,TResult? Function( _UndoDismiss value)?  undoDismiss,}){
final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch(_that);case _Dismiss() when dismiss != null:
return dismiss(_that);case _UndoDismiss() when undoDismiss != null:
return undoDismiss(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  watch,TResult Function( int alertId,  DismissReason reason)?  dismiss,TResult Function( int alertId)?  undoDismiss,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch();case _Dismiss() when dismiss != null:
return dismiss(_that.alertId,_that.reason);case _UndoDismiss() when undoDismiss != null:
return undoDismiss(_that.alertId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  watch,required TResult Function( int alertId,  DismissReason reason)  dismiss,required TResult Function( int alertId)  undoDismiss,}) {final _that = this;
switch (_that) {
case _Watch():
return watch();case _Dismiss():
return dismiss(_that.alertId,_that.reason);case _UndoDismiss():
return undoDismiss(_that.alertId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  watch,TResult? Function( int alertId,  DismissReason reason)?  dismiss,TResult? Function( int alertId)?  undoDismiss,}) {final _that = this;
switch (_that) {
case _Watch() when watch != null:
return watch();case _Dismiss() when dismiss != null:
return dismiss(_that.alertId,_that.reason);case _UndoDismiss() when undoDismiss != null:
return undoDismiss(_that.alertId);case _:
  return null;

}
}

}

/// @nodoc


class _Watch implements AlertsEvent {
  const _Watch();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Watch);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AlertsEvent.watch()';
}


}




/// @nodoc


class _Dismiss implements AlertsEvent {
  const _Dismiss({required this.alertId, required this.reason});
  

 final  int alertId;
 final  DismissReason reason;

/// Create a copy of AlertsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DismissCopyWith<_Dismiss> get copyWith => __$DismissCopyWithImpl<_Dismiss>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Dismiss&&(identical(other.alertId, alertId) || other.alertId == alertId)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,alertId,reason);

@override
String toString() {
  return 'AlertsEvent.dismiss(alertId: $alertId, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$DismissCopyWith<$Res> implements $AlertsEventCopyWith<$Res> {
  factory _$DismissCopyWith(_Dismiss value, $Res Function(_Dismiss) _then) = __$DismissCopyWithImpl;
@useResult
$Res call({
 int alertId, DismissReason reason
});




}
/// @nodoc
class __$DismissCopyWithImpl<$Res>
    implements _$DismissCopyWith<$Res> {
  __$DismissCopyWithImpl(this._self, this._then);

  final _Dismiss _self;
  final $Res Function(_Dismiss) _then;

/// Create a copy of AlertsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? alertId = null,Object? reason = null,}) {
  return _then(_Dismiss(
alertId: null == alertId ? _self.alertId : alertId // ignore: cast_nullable_to_non_nullable
as int,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as DismissReason,
  ));
}


}

/// @nodoc


class _UndoDismiss implements AlertsEvent {
  const _UndoDismiss(this.alertId);
  

 final  int alertId;

/// Create a copy of AlertsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UndoDismissCopyWith<_UndoDismiss> get copyWith => __$UndoDismissCopyWithImpl<_UndoDismiss>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UndoDismiss&&(identical(other.alertId, alertId) || other.alertId == alertId));
}


@override
int get hashCode => Object.hash(runtimeType,alertId);

@override
String toString() {
  return 'AlertsEvent.undoDismiss(alertId: $alertId)';
}


}

/// @nodoc
abstract mixin class _$UndoDismissCopyWith<$Res> implements $AlertsEventCopyWith<$Res> {
  factory _$UndoDismissCopyWith(_UndoDismiss value, $Res Function(_UndoDismiss) _then) = __$UndoDismissCopyWithImpl;
@useResult
$Res call({
 int alertId
});




}
/// @nodoc
class __$UndoDismissCopyWithImpl<$Res>
    implements _$UndoDismissCopyWith<$Res> {
  __$UndoDismissCopyWithImpl(this._self, this._then);

  final _UndoDismiss _self;
  final $Res Function(_UndoDismiss) _then;

/// Create a copy of AlertsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? alertId = null,}) {
  return _then(_UndoDismiss(
null == alertId ? _self.alertId : alertId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$AlertsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlertsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AlertsState()';
}


}

/// @nodoc
class $AlertsStateCopyWith<$Res>  {
$AlertsStateCopyWith(AlertsState _, $Res Function(AlertsState) __);
}


/// Adds pattern-matching-related methods to [AlertsState].
extension AlertsStatePatterns on AlertsState {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String message)?  error,TResult Function( List<AlertEntity> alerts,  int? justDismissedId)?  loaded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Error() when error != null:
return error(_that.message);case _Loaded() when loaded != null:
return loaded(_that.alerts,_that.justDismissedId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String message)  error,required TResult Function( List<AlertEntity> alerts,  int? justDismissedId)  loaded,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Error():
return error(_that.message);case _Loaded():
return loaded(_that.alerts,_that.justDismissedId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String message)?  error,TResult? Function( List<AlertEntity> alerts,  int? justDismissedId)?  loaded,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Error() when error != null:
return error(_that.message);case _Loaded() when loaded != null:
return loaded(_that.alerts,_that.justDismissedId);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements AlertsState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AlertsState.initial()';
}


}




/// @nodoc


class _Loading implements AlertsState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AlertsState.loading()';
}


}




/// @nodoc


class _Error implements AlertsState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of AlertsState
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
  return 'AlertsState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $AlertsStateCopyWith<$Res> {
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

/// Create a copy of AlertsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Loaded implements AlertsState {
  const _Loaded({required  List<AlertEntity> alerts, this.justDismissedId}): _alerts = alerts;
  

 final  List<AlertEntity> _alerts;
 List<AlertEntity> get alerts {
  if (_alerts is EqualUnmodifiableListView) return _alerts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_alerts);
}

 final  int? justDismissedId;

/// Create a copy of AlertsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._alerts, _alerts)&&(identical(other.justDismissedId, justDismissedId) || other.justDismissedId == justDismissedId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_alerts),justDismissedId);

@override
String toString() {
  return 'AlertsState.loaded(alerts: $alerts, justDismissedId: $justDismissedId)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $AlertsStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<AlertEntity> alerts, int? justDismissedId
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of AlertsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? alerts = null,Object? justDismissedId = freezed,}) {
  return _then(_Loaded(
alerts: null == alerts ? _self._alerts : alerts // ignore: cast_nullable_to_non_nullable
as List<AlertEntity>,justDismissedId: freezed == justDismissedId ? _self.justDismissedId : justDismissedId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
