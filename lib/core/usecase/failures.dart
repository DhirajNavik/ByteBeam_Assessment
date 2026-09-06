sealed class Failure {
  final String message;
  const Failure(this.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class LocalFailue extends Failure {
  const LocalFailue(super.message);
}