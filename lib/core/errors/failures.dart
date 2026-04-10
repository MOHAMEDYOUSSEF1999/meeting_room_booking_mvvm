abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});
}

class TimeoutFailure extends Failure {
  const TimeoutFailure() : super('Connection timed out. Please try again.');
}

class UnknownFailure extends Failure {
  const UnknownFailure() : super('An unexpected error occurred.');
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class ConflictFailure extends Failure {
  const ConflictFailure(super.message);
}
