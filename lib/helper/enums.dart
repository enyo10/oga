enum RepairStatus {
  onHold("onHold", "En attente"),
  inProgress("inProgress", "En cours"),
  ended("ended", "Terminée");

  final String key;
  final String label;

  const RepairStatus(this.key, this.label);

  static RepairStatus fromKey(String key) {
    return RepairStatus.values.firstWhere((status) => status.key == key);
  }
}
