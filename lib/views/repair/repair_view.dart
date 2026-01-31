import 'package:flutter/material.dart';
import 'package:oga/views/repair/repair_form.dart';
import 'package:oga/views/repair/repair_provider.dart';
import 'package:provider/provider.dart';

class ReparationsList extends StatelessWidget {
  const ReparationsList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RepairProvider>();


    return Scaffold(
      appBar: AppBar(title: Text("Réparations")),
      body: ListView.builder(
        itemCount: provider.reparations.length,
        itemBuilder: (context, index) {
          final rep = provider.reparations[index];
          return ListTile(
            title: Text(rep.objet),
            subtitle: Text(rep.description),
            trailing: Text(
              rep.status.toString().split('.').last == "onHold"
                  ? "En attente" ?? ""
                  : rep.status.toString().split('.').last == "inProgress"
                  ? "En cours" ?? ""
                  : "Terminée",
            ),
            onLongPress: () => provider.cancelReparation(rep.id),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => RepairForm(houseId: rep.houseId, initial: rep),
                  ),
                ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: Icon(Icons.add),
      ),
    );
  }
}
