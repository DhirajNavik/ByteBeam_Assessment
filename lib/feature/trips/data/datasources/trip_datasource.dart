import 'package:bytebeam_assessment/feature/trips/data/models/trip_model.dart';

abstract interface class TripsDataSource {
  Stream<List<TripModel>> watchAll();
  void startReconciliation();
  void stopReconciliation();
}