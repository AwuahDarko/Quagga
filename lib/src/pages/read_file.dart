import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render_widgets.dart';


class ReadFile extends StatelessWidget{


  /// render at 100 dpi
  static const scale = 100.0 / 72.0;
  static const margin = 4.0;
  static const padding = 1.0;
  static const wmargin = (margin + padding) * 2;

  @override
  Widget build(BuildContext context) {

    final Map<String, String> value = ModalRoute.of(context).settings.arguments;
    return Scaffold(
          appBar: new AppBar(
            title: Text('${value["head"]}'),
          ),
          backgroundColor: Colors.grey,
          body: Center(
              child: PdfDocumentLoader(
                assetName: 'assets/${value["file"]}',
                documentBuilder: (context, pdfDocument, pageCount) => LayoutBuilder(
                    builder: (context, constraints) => ListView.builder(
                        itemCount: pageCount,
                        itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.all(margin),
                            padding: EdgeInsets.all(padding),
                            color: Colors.black12,
                            child: PdfPageView(
                                pdfDocument: pdfDocument,
                                pageNumber: index + 1,
                                // calculateSize is used to calculate the rendering page size
                                calculateSize: (pageWidth, pageHeight, aspectRatio) =>
                                    Size(
                                        constraints.maxWidth - wmargin,
                                        (constraints.maxWidth - wmargin) / aspectRatio)
                            )
                        )
                    )
                ),
              )
          )
    );
  }

}


