import 'dart:convert';
import 'dart:html';
import 'dart:ui';
import 'package:flutter_application_1/employee/employee_functions/6_distribution_orders.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfService {
  Future<void> printCustomersPdf(List<drivers> data) async {
    int totalCustomers = data.length;
    int count = 0;

    PdfDocument document = PdfDocument();
    PdfPage page = document.pages.add();
    PdfGraphics graphics = page.graphics;

//////////////////////title
    graphics.drawString(
        'Distribution of orders',
        PdfStandardFont(
          PdfFontFamily.timesRoman,
          18,
          style: PdfFontStyle.underline,
        ),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(0, 20, page.getClientSize().width, 30),
        format: PdfStringFormat(
            lineAlignment: PdfVerticalAlignment.middle,
            alignment: PdfTextAlignment.center));

    /////////////////////
    PdfGrid grid = PdfGrid();

    grid.columns.add(count: 3);
    grid.headers.add(1);
    PdfGridRow header = grid.headers[0];
    header.cells[0].value = "Name";
    header.cells[1].value = "Id";
    header.cells[2].value = "Address";

    //Add header style
    header.style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightGray,
      textBrush: PdfBrushes.black,
      font: PdfStandardFont(PdfFontFamily.timesRoman, 12),
    );

    //Add rows to grid
    for (final customer in data) {
      count++;
      for (int i = 0; i < customer.packages_id.length; i++) {
        PdfGridRow row = grid.rows.add();
        row.cells[0].value = customer.driver_name;
        row.cells[1].value = customer.packages_id[i];
        row.cells[2].value = customer.address;
      }
      if (count != totalCustomers) {
        PdfGridRow row2 = grid.rows.add();
        row2.cells[0].value = "Name";
        row2.cells[1].value = "Id";
        row2.cells[2].value = "Address";
        row2.style.backgroundBrush = PdfBrushes.lightGray;
      }
    }
    //Add rows style
    grid.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 10, right: 3, top: 4, bottom: 5),
      backgroundBrush: PdfBrushes.white,
      textBrush: PdfBrushes.black,
      font: PdfStandardFont(PdfFontFamily.timesRoman, 12),
    );

    //Draw the grid
    grid.draw(page: page, bounds: const Rect.fromLTWH(0, 60, 0, 0));
    List<int> bytes = await document.save();

    AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      ..setAttribute("download", "report.pdf")
      ..click();

    document.dispose();
  }
}
