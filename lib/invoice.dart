import 'package:auto_size_text/auto_size_text.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pw ;

/*void main() async {




  // Initialize a new Firebase App instance
  // await Firebase.initializeApp();
 // runApp(PDfHomePage());

 *//* final pdf = Document();
  pdf.addPage(pw.Page(build: (pw.Context context){
    return pw.Padding(
      padding: pw.EdgeInsets.all(10.0),
      child: pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.only(right: 10),
                child: pw.Container(
                  color: pw.Colors.black12,
                  child:  pw.Padding(
                    padding: pw.EdgeInsets.all(4.0),
                    child: pw.Text(
                      " B.P.F:  50.000 CFA",
                      style: const pw.TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ),

            ],
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 20, right: 10),
            child: pw.Text.rich(
              pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: "       Reçu ",
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 35),
                  ),
                  const pw.TextSpan(text: "de: Mr/Mme"),
                  pw.TextSpan(text: " BLA BLA BG kkdkd kkdkd\n".toUpperCase()),
                  const pw.TextSpan(text: "la somme de:"),
                ],
                text: "\n",
                style: const pw.TextStyle(fontSize: 30),
              ),
            ),
          ),
           pw.SizedBox(
            height: 5,
          ),
          pw.RichText(
            pw.TextSpan(
              children: [
                WidgetSpan(
                  child: Container(
                    color: Colors.black26,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 10),
                      child: AutoSizeText(
                        'Cinquante milles francs CFA',
                        maxLines: 2,
                        minFontSize: 28,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          pw.SizedBox(
            height: 5,
          ),
          AutoSizeText.rich(
              maxLines: 2,
              TextSpan(
                  text: "Motif:  ",
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  children: [
                    TextSpan(
                        text: "Loyer des mois juin - juillet".toUpperCase(),
                        style: const TextStyle(fontSize: 24))
                  ])),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              AutoSizeText.rich(TextSpan(
                text: "Fait à Lomé le",
                style: TextStyle(
                    fontWeight: FontWeight.bold,fontSize: 22,
                    fontStyle: FontStyle.italic),
                children: [TextSpan(text: "27/20/2023")],
              ))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Text("Signature", style: TextStyle(fontSize: 22),)
        ],
      ),
    ),
  }));*//*
}*/



Future<void> main() async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Center(
        child: pw.Text('Hello World!'),
      ),
    ),
  );

  final file = File('example.pdf');
  await file.writeAsBytes(await pdf.save());
}

class PDfHomePage extends StatelessWidget {
  final pdf = pw.Document();

  PDfHomePage({super.key});

  writeOnPdf() {
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return <pw.Widget>[
        pw.Header(
        level: 0,
        child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: <pw.Widget>[
        pw.Text('Geeksforgeeks', textScaleFactor: 2),
        ])),
        pw.Header(level: 1, text: 'What is Lorem Ipsum?'),

        // Write All the paragraph in one line.
        // For clear understanding
        // here there are line breaks.
        pw.Padding(padding: const pw.EdgeInsets.all(10)),
        pw.Table.fromTextArray(context: context, data: const <List<String>>[
        <String>['Year', 'Sample'],
        <String>['SN0', 'GFG1'],
        <String>['SN1', 'GFG2'],
        <String>['SN2', 'GFG3'],
        <String>['SN3', 'GFG4'],
        ]),
        ];
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return writeOnPdf();
  }
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Kindacode.com',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const InvoiceWidget(),
    );
  }
}

class InvoiceWidget extends StatelessWidget {
  const InvoiceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pdf = pw.Document();
    const space = SizedBox(height: 50);
    return Scaffold(

      body:Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    color: Colors.black12,
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        " B.P.F:  50.000 CFA",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 10),
              child: AutoSizeText.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: "       Reçu ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 35),
                    ),
                    const TextSpan(text: "de: Mr/Mme"),
                    TextSpan(text: " BLA BLA BG kkdkd kkdkd\n".toUpperCase()),
                    const TextSpan(text: "la somme de:"),
                  ],
                  text: "\n",
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text.rich(
              TextSpan(
                children: [
                  WidgetSpan(
                    child: Container(
                      color: Colors.black26,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 10),
                        child: AutoSizeText(
                          'Cinquante milles francs CFA',
                          maxLines: 2,
                          minFontSize: 28,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            AutoSizeText.rich(
                maxLines: 2,
                TextSpan(
                    text: "Motif:  ",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    children: [
                      TextSpan(
                          text: "Loyer des mois juin - juillet".toUpperCase(),
                          style: const TextStyle(fontSize: 24))
                    ])),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                AutoSizeText.rich(TextSpan(
                  text: "Fait à Lomé le",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,fontSize: 22,
                      fontStyle: FontStyle.italic),
                  children: [TextSpan(text: "27/20/2023")],
                ))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Signature", style: TextStyle(fontSize: 22),)
          ],
        ),
      ),
    );
  }
}

