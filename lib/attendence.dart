import 'dart:io';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';

class BulkUpload extends StatefulWidget {
  const BulkUpload({Key? key}) : super(key: key);

  @override
  State<BulkUpload> createState() => _BulkUploadState();
}

class _BulkUploadState extends State<BulkUpload> {
  List<List<dynamic>> _data = [];
  String? filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Attendance Sheet",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF000029),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickFile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF000029),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                "Upload File",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _data.isEmpty
                  ? const Center(
                child: Text("No data available"),
              )
                  : SingleChildScrollView(
                child: DataTable(
                  border: TableBorder.all(color: Colors.grey),
                  columns: _generateColumns(),
                  rows: _generateRows(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttendancePage(data: _data),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF000029),
              ),
              child: const Text("Proceed to Attendance"),
            ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> _generateColumns() {
    if (_data.isEmpty) return [];
    return [
      ..._data[0].map<DataColumn>((header) {
        return DataColumn(label: Text(header.toString()));
      }).toList(),
    ];
  }

  List<DataRow> _generateRows() {
    return _data.skip(1).map<DataRow>((row) {
      return DataRow(
        cells: row.map<DataCell>((cell) {
          final value = cell is double ? cell.toInt().toString() : cell.toString();
          return DataCell(Text(value));
        }).toList(),
      );
    }).toList();
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;

    filePath = result.files.first.path!;
    final input = File(filePath!).readAsBytesSync();
    var excel = Excel.decodeBytes(input);

    final sheet = excel.tables[excel.tables.keys.first];
    if (sheet == null || sheet.rows.isEmpty) {
      print("No data found in the selected Excel file.");
      return;
    }

    setState(() {
      _data = sheet.rows.map<List<dynamic>>((row) {
        return row.map((cell) => cell?.value ?? '').toList();
      }).toList();
    });
  }
}

class AttendancePage extends StatefulWidget {
  final List<List<dynamic>> data;

  const AttendancePage({Key? key, required this.data}) : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  List<List<dynamic>> data = [];
  final Map<int, bool> attendance = {};

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mark Attendance",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF000029),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: data.length - 1, // Skip header row
              itemBuilder: (context, index) {
                final row = data[index + 1];
                final rollNo = row[1] is double ? row[1].toInt().toString() : row[1].toString();
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  child: ListTile(
                    title: Text(row[0].toString()), // Name
                    subtitle: Text("Reg No: $rollNo"), // Roll No
                    trailing: Checkbox(
                      value: attendance[index] ?? false,
                      onChanged: (value) {
                        setState(() {
                          attendance[index] = value ?? false;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => _addStudentDialog(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text("Add Student"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    attendance.clear(); // Reset all attendance
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text("Reset"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReportsPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF000029),
                ),
                child: const Text("Generate Reports"),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QRScannerPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF000029),
            ),
            child: const Text("Open Camera"),
          ),
        ],
      ),
    );
  }

  Widget _addStudentDialog() {
    final nameController = TextEditingController();
    final regNoController = TextEditingController();

    return AlertDialog(
      title: const Text("Add Student"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Name"),
          ),
          TextField(
            controller: regNoController,
            decoration: const InputDecoration(labelText: "Reg No"),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              data.add([nameController.text, regNoController.text]);
            });
            Navigator.pop(context);
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({Key? key}) : super(key: key);

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Get the list of available cameras
    cameras = await availableCameras();

    if (cameras != null && cameras!.isNotEmpty) {
      _cameraController = CameraController(cameras![0], ResolutionPreset.high);

      try {
        await _cameraController!.initialize();
        setState(() {}); // Refresh the UI when the camera is ready
      } catch (e) {
        print("Error initializing camera: $e");
      }
    } else {
      print("No cameras found on this device.");
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: Text("QR Scanner"),
          backgroundColor: Color(0xFF000029),
        ),
        body: const Center(
          child: Text(
            "Initializing Camera...",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "QR Scanner",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF000029),
      ),
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(_cameraController!), // Display the camera preview
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF000029),
              ),
              onPressed: () {
                // Add functionality to scan a QR code or take a picture if needed
                print("Capture button pressed.");
              },
              child: const Text("Capture"),
            ),
          ),
        ],
      ),
    );
  }
}


class ReportsPage extends StatelessWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reports",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF000029),
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Report ${index + 1}"),
            subtitle: Text("Generated at ${10 + index}:00 AM"),
            trailing: IconButton(
              icon: const Icon(Icons.print),
              onPressed: () {
                // Handle printing functionality
              },
            ),
          );
        },
      ),
    );
  }
}
