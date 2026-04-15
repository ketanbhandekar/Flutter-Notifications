import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(EmployeeApp());
}

class EmployeeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EmployeePage(),
    );
  }
}

class EmployeePage extends StatefulWidget {
  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref().child('employees');

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  List<Map<dynamic, dynamic>> _employeeList = [];

  void _addEmployee() async {
    if (_nameController.text.isNotEmpty &&
        _ageController.text.isNotEmpty &&
        _locationController.text.isNotEmpty) {
      // Add employee data to Firebase
      await _databaseReference.push().set({
        'name': _nameController.text,
        'age': _ageController.text,
        'location': _locationController.text,
      });

      // Clear the input fields
      _nameController.clear();
      _ageController.clear();
      _locationController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Employee added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields.')),
      );
    }
  }

  void _showEmployeeDetails() async {
    // Fetch employee details from Firebase
    final snapshot = await _databaseReference.get();
    if (snapshot.exists) {
      setState(() {
        _employeeList = (snapshot.value as Map).entries.map((e) {
          return {'key': e.key, ...e.value};
        }).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No employee data found.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _addEmployee,
                  child: Text('Add Employee'),
                ),
                ElevatedButton(
                  onPressed: _showEmployeeDetails,
                  child: Text('Show Details'),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _employeeList.length,
                itemBuilder: (context, index) {
                  final employee = _employeeList[index];
                  return ListTile(
                    title: Text('Name: ${employee['name']}'),
                    subtitle: Text('Age: ${employee['age']}\nLocation: ${employee['location']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}