import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oga/widgets/oga_scaffold.dart';
import 'package:provider/provider.dart';

import '../../helper/oga_colors.dart';
import '../../models/house.dart';
import '../../widgets/oga_glass_container.dart';
import '../repair/repair_form.dart';
import '../repair/repair_provider.dart';

class HouseInfoView extends StatefulWidget {
  final House house;
  const HouseInfoView({super.key, required this.house});

  @override
  State<HouseInfoView> createState() => _HouseInfoViewState();
}

class _HouseInfoViewState extends State<HouseInfoView> {

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<RepairProvider>();
    provider.loadRepairs(widget.house.id);
    return OgaScaffold(
      appBar: AppBar(
        title: Text("Info maison"),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 30,
          color: OgaColors.myLightBlue.shade100,
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: OgaColors.myLightBlue.shade100,
        shape: CircleBorder(),

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RepairForm(houseId: widget.house.id),
            ),
          );
        },
        child: Icon(Icons.add),
      ),

      body: ListView.builder(
        itemCount: provider.reparations.length,
        itemBuilder: (context, index) {
          final rep = provider.reparations[index];
          
          return OgaGlassContainer(
            child: ListTile(
              title: Text(rep.objet),
              subtitle: Text(rep.description),
              trailing: Text(rep.status.label),
              onLongPress: () => provider.cancelReparation(rep.id),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => RepairForm(houseId: rep.houseId, initial: rep),
                    ),
                  ),
            ),
          );
        },
      ),
    );
  }

  _addRepairInfo() {}
  _loadRepairInfo() {}
}
