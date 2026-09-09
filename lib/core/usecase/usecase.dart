import 'package:fpdart/fpdart.dart';

import 'failures.dart';

abstract class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params) {
    throw UnimplementedError();
  }

  Stream<Either<Failure, SuccessType>> watch(Params params) {
    throw UnimplementedError();
  }
}

final class NoParams {
  const NoParams();
}
