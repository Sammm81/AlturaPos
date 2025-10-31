import 'package:dartz/dartz.dart';
import 'package:altura_pos/core/errors/failures.dart';
import 'package:altura_pos/domain/entities/transaction.dart';
import 'package:altura_pos/domain/repositories/transaction_repository.dart';

/// Use case for creating a transaction
class CreateTransaction {
  CreateTransaction(this._repository);

  final TransactionRepository _repository;

  Future<Either<Failure, Transaction>> call(Transaction transaction) async {
    return _repository.createTransaction(transaction);
  }
}
