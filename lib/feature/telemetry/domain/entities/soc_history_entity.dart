class SOCHistoryEntity {
  final int id;
  final double soc;
  final DateTime? time;

  const SOCHistoryEntity({
    required this.id,
    required this.soc,
    required this.time,
  });
}
