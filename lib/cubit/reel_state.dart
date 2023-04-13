import '../models/reel.dart';

abstract class ReelState {}

class ReelInitial extends ReelState {}

class ReelLoaded extends ReelState {
  final List<ReelItem> reels;

  ReelLoaded(this.reels);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReelLoaded &&
          runtimeType == other.runtimeType &&
          reels == other.reels;

  @override
  int get hashCode => reels.hashCode;
}

class ReelError extends ReelState {
  final String error;

  ReelError(this.error);

  String get message => error;

  @override
  List<Object?> get props => [error];
}
