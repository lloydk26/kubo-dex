// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeState {

 List<ScanRecord> get recentScans; int get totalScans; String get averageGrade; bool get isLoading; bool get hasError; String get errorMessage;
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeStateCopyWith<HomeState> get copyWith => _$HomeStateCopyWithImpl<HomeState>(this as HomeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeState&&const DeepCollectionEquality().equals(other.recentScans, recentScans)&&(identical(other.totalScans, totalScans) || other.totalScans == totalScans)&&(identical(other.averageGrade, averageGrade) || other.averageGrade == averageGrade)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(recentScans),totalScans,averageGrade,isLoading,hasError,errorMessage);

@override
String toString() {
  return 'HomeState(recentScans: $recentScans, totalScans: $totalScans, averageGrade: $averageGrade, isLoading: $isLoading, hasError: $hasError, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $HomeStateCopyWith<$Res>  {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) = _$HomeStateCopyWithImpl;
@useResult
$Res call({
 List<ScanRecord> recentScans, int totalScans, String averageGrade, bool isLoading, bool hasError, String errorMessage
});




}
/// @nodoc
class _$HomeStateCopyWithImpl<$Res>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._self, this._then);

  final HomeState _self;
  final $Res Function(HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recentScans = null,Object? totalScans = null,Object? averageGrade = null,Object? isLoading = null,Object? hasError = null,Object? errorMessage = null,}) {
  return _then(_self.copyWith(
recentScans: null == recentScans ? _self.recentScans : recentScans // ignore: cast_nullable_to_non_nullable
as List<ScanRecord>,totalScans: null == totalScans ? _self.totalScans : totalScans // ignore: cast_nullable_to_non_nullable
as int,averageGrade: null == averageGrade ? _self.averageGrade : averageGrade // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeState value)  $default,){
final _that = this;
switch (_that) {
case _HomeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeState value)?  $default,){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ScanRecord> recentScans,  int totalScans,  String averageGrade,  bool isLoading,  bool hasError,  String errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.recentScans,_that.totalScans,_that.averageGrade,_that.isLoading,_that.hasError,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ScanRecord> recentScans,  int totalScans,  String averageGrade,  bool isLoading,  bool hasError,  String errorMessage)  $default,) {final _that = this;
switch (_that) {
case _HomeState():
return $default(_that.recentScans,_that.totalScans,_that.averageGrade,_that.isLoading,_that.hasError,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ScanRecord> recentScans,  int totalScans,  String averageGrade,  bool isLoading,  bool hasError,  String errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.recentScans,_that.totalScans,_that.averageGrade,_that.isLoading,_that.hasError,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _HomeState implements HomeState {
  const _HomeState({final  List<ScanRecord> recentScans = const <ScanRecord>[], this.totalScans = 0, this.averageGrade = '--', this.isLoading = false, this.hasError = false, this.errorMessage = ''}): _recentScans = recentScans;
  

 final  List<ScanRecord> _recentScans;
@override@JsonKey() List<ScanRecord> get recentScans {
  if (_recentScans is EqualUnmodifiableListView) return _recentScans;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentScans);
}

@override@JsonKey() final  int totalScans;
@override@JsonKey() final  String averageGrade;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool hasError;
@override@JsonKey() final  String errorMessage;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeStateCopyWith<_HomeState> get copyWith => __$HomeStateCopyWithImpl<_HomeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeState&&const DeepCollectionEquality().equals(other._recentScans, _recentScans)&&(identical(other.totalScans, totalScans) || other.totalScans == totalScans)&&(identical(other.averageGrade, averageGrade) || other.averageGrade == averageGrade)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_recentScans),totalScans,averageGrade,isLoading,hasError,errorMessage);

@override
String toString() {
  return 'HomeState(recentScans: $recentScans, totalScans: $totalScans, averageGrade: $averageGrade, isLoading: $isLoading, hasError: $hasError, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$HomeStateCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory _$HomeStateCopyWith(_HomeState value, $Res Function(_HomeState) _then) = __$HomeStateCopyWithImpl;
@override @useResult
$Res call({
 List<ScanRecord> recentScans, int totalScans, String averageGrade, bool isLoading, bool hasError, String errorMessage
});




}
/// @nodoc
class __$HomeStateCopyWithImpl<$Res>
    implements _$HomeStateCopyWith<$Res> {
  __$HomeStateCopyWithImpl(this._self, this._then);

  final _HomeState _self;
  final $Res Function(_HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recentScans = null,Object? totalScans = null,Object? averageGrade = null,Object? isLoading = null,Object? hasError = null,Object? errorMessage = null,}) {
  return _then(_HomeState(
recentScans: null == recentScans ? _self._recentScans : recentScans // ignore: cast_nullable_to_non_nullable
as List<ScanRecord>,totalScans: null == totalScans ? _self.totalScans : totalScans // ignore: cast_nullable_to_non_nullable
as int,averageGrade: null == averageGrade ? _self.averageGrade : averageGrade // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
