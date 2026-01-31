import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oga/views/repair/repair_service.dart';

import '../../helper/enums.dart';
import '../../helper/helper.dart';
import '../../models/repair.dart';

class RepairForm extends StatefulWidget {
  final Repair? initial;
  final String houseId;
  final String? apartmentId;

  const RepairForm({
    super.key,
    this.initial,
    required this.houseId,
    this.apartmentId,
  });

  @override
  State<RepairForm> createState() => _RepairFormState();
}

class _RepairFormState extends State<RepairForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _objetCtrl;
  late TextEditingController _descriptionCtrl;
  late TextEditingController _repairmanCtrl;
  late TextEditingController _repairCostCtrl;

  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  RepairStatus _repairStatus = RepairStatus.onHold;

  @override
  void initState() {
    super.initState();

    final r = widget.initial;

    _objetCtrl = TextEditingController(text: r?.objet ?? "");
    _descriptionCtrl = TextEditingController(text: r?.description ?? "");
    _repairmanCtrl = TextEditingController(text: r?.repairman ?? "");
    _repairCostCtrl = TextEditingController(
      text: r?.repairCost != null ? r!.repairCost.toString() : "0",
    );

    _startDate = r?.startDate ?? DateTime.now();
    _endDate = r?.endDate;
    _repairStatus = r?.status ?? RepairStatus.onHold;
  }

  @override
  void dispose() {
    _objetCtrl.dispose();
    _descriptionCtrl.dispose();
    _repairmanCtrl.dispose();
    _repairCostCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate,
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _endDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final reparation = Repair(
      id: "",
      houseId: widget.houseId,
      apartmentId: widget.apartmentId,
      objet: _objetCtrl.text,
      description: _descriptionCtrl.text,
      startDate: _startDate,
      endDate: _endDate,
      repairman: _repairmanCtrl.text,
      repairCost: double.tryParse(_repairCostCtrl.text) ?? 0,
      status: _repairStatus,
    );

    RepairService service = RepairService();
    await service
        .addRepair(reparation)
        .onError((error, stackTrace) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Erreur : $error")));
        })
        .then((value) {
          showMessage(context, "Reparation bien ajouté avec succès");
          Navigator.of(context).pop();
        });
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("dd/MM/yyyy");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initial == null
              ? "Nouvelle réparation"
              : "Modifier réparation",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _objetCtrl,
                decoration: const InputDecoration(labelText: "Objet"),
                validator:
                    (v) => v == null || v.isEmpty ? "Champ obligatoire" : null,
              ),
              TextFormField(
                controller: _descriptionCtrl,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
              ),
              TextFormField(
                controller: _repairmanCtrl,
                decoration: const InputDecoration(labelText: "Réparateur"),
              ),
              TextFormField(
                controller: _repairCostCtrl,
                decoration: const InputDecoration(labelText: "Coût (FCFA)"),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),

              // Date de début
              ListTile(
                title: Text("Début : ${dateFormat.format(_startDate)}"),
                trailing: const Icon(Icons.calendar_month),
                onTap: _pickStartDate,
              ),

              // Date de fin
              ListTile(
                title: Text(
                  _endDate == null
                      ? "Fin : non définie"
                      : "Fin : ${dateFormat.format(_endDate!)}",
                ),
                trailing: const Icon(Icons.calendar_month),
                onTap: _pickEndDate,
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<RepairStatus>(
                initialValue: _repairStatus,
                decoration: const InputDecoration(labelText: "Statut"),
                items:
                    RepairStatus.values.map((s) {
                      return DropdownMenuItem(value: s, child: Text(s.label));
                    }).toList(),

                onChanged: (v) {
                  setState(() => _repairStatus = v!);
                },
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _submit,
                child: const Text("Enregistrer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
