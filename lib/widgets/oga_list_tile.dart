import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../helper/oga_colors.dart';

class OgaListTile extends StatelessWidget {
  const OgaListTile({super.key,required this.data, required this.widget});
  final dynamic data;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.98,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.28,
                    maxHeight: MediaQuery.of(context).size.width * 0.28,
                  ),
                  child: Container(
                   // color: Colors.red,
                   //child: widget,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                      child: Center(
                        child: AutoSizeText(
                          data.name.toUpperCase(),
                          maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: OgaColors.white4),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 30, 0, 0),
                      child: Text(data.desc,
                       // data.desc,
                        style: TextStyle(fontSize: 16, color: OgaColors.grey2),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
