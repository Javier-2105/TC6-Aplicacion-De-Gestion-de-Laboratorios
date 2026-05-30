//TC6 Platas Molina Rodolfo Javier 23328061310458

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../data/models/computadora.dart';
import '../data/models/inventario.dart';
import '../data/models/reserva.dart';
import '../data/models/reporte_falla.dart';
import '../data/models/mantenimiento.dart';

// Servicio local para generar y exportar reportes en formato PDF
class PdfService {
  
  // Generar reporte de computadoras
  static Future<void> exportarComputadoras(List<Computadora> computadoras) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        build: (context) => [
          _crearCabecera("Reporte General de Computadoras"),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headers: ['PC #', 'Marca/Modelo', 'Procesador', 'RAM', 'Almacenamiento', 'IP', 'Estado'],
            data: computadoras.map((pc) => [
              pc.numeroPc.toString(),
              "${pc.marca} ${pc.modelo}",
              pc.procesador,
              pc.memoriaRam,
              pc.almacenamiento,
              pc.direccionIp,
              pc.estado
            ]).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF203A43)),
            cellHeight: 30,
            cellAlignments: {
              0: pw.Alignment.center,
              1: pw.Alignment.centerLeft,
              6: pw.Alignment.center,
            },
          ),
          pw.SizedBox(height: 30),
          _crearFirma(),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  // Generar reporte del inventario tecnológico
  static Future<void> exportarInventario(List<Inventario> items) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        build: (context) => [
          _crearCabecera("Reporte de Inventario Tecnológico"),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headers: ['Nombre', 'Categoría', 'Cantidad', 'Estado', 'Ubicación', 'Adquisición'],
            data: items.map((item) => [
              item.nombre,
              item.categoria,
              item.cantidad.toString(),
              item.estado,
              item.ubicacion,
              item.fechaAdquisicion
            ]).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF203A43)),
            cellHeight: 30,
          ),
          pw.SizedBox(height: 30),
          _crearFirma(),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  // Generar reporte de reservas
  static Future<void> exportarReservas(List<Reserva> reservas) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        build: (context) => [
          _crearCabecera("Reporte de Reservas de Laboratorio"),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headers: ['Profesor', 'Materia', 'Grupo', 'Laboratorio', 'Fecha', 'Horario'],
            data: reservas.map((res) => [
              res.profesor,
              res.materia,
              res.grupo,
              res.laboratorio,
              res.fecha,
              res.horario
            ]).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF203A43)),
            cellHeight: 30,
          ),
          pw.SizedBox(height: 30),
          _crearFirma(),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  // Generar reporte de fallas
  static Future<void> exportarFallas(List<ReporteFalla> fallas) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        build: (context) => [
          _crearCabecera("Reporte de Fallas Reportadas"),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headers: ['PC #', 'Problema', 'Prioridad', 'Fecha', 'Estado'],
            data: fallas.map((falla) => [
              falla.computadoraId.toString(),
              falla.problema,
              falla.prioridad,
              falla.fecha,
              falla.estado
            ]).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF203A43)),
            cellHeight: 30,
          ),
          pw.SizedBox(height: 30),
          _crearFirma(),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  // Generar reporte de mantenimientos
  static Future<void> exportarMantenimientos(List<Mantenimiento> mantenimientos) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        build: (context) => [
          _crearCabecera("Reporte de Mantenimientos Realizados"),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headers: ['Equipo/PC', 'Fecha', 'Problema', 'Solución', 'Costo', 'Estado'],
            data: mantenimientos.map((m) => [
              m.equipo,
              m.fecha,
              m.problemaDetectado,
              m.solucionAplicada,
              "\$${m.costo.toStringAsFixed(2)}",
              m.estado
            ]).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF203A43)),
            cellHeight: 30,
          ),
          pw.SizedBox(height: 30),
          _crearFirma(),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  // Helper para crear el encabezado del documento PDF
  static pw.Widget _crearCabecera(String titulo) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              "LabControl",
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: const PdfColor.fromInt(0xFF0F2027)),
            ),
            pw.Text(
              "Preparatoria Oficial",
              style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
            ),
          ],
        ),
        pw.Divider(thickness: 2, color: const PdfColor.fromInt(0xFF00B4DB)),
        pw.SizedBox(height: 10),
        pw.Text(
          titulo,
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(
          "Generado de forma local el: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
        ),
      ],
    );
  }

  // Helper para crear el bloque de firma y créditos académicos del desarrollador
  static pw.Widget _crearFirma() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Divider(thickness: 1, color: PdfColors.grey400),
        pw.SizedBox(height: 15),
        pw.Center(
          child: pw.Text(
            "Desarrollado por: Rodolfo Javier Platas Molina",
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Center(
          child: pw.Text(
            "Identificación: TC6 Platas Molina Rodolfo Javier 23328061310458",
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
        ),
      ],
    );
  }
}
