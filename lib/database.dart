import 'package:firebase_database/firebase_database.dart';
import 'employee.dart';

class DatabaseMethods {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref("employees");

  /// Adds employee details to Realtime Database
  Future<void> addEmployeeDetails(Map<String, dynamic> employeeInfoMap, String id) async {
    try {
      await dbRef.child(id).set(employeeInfoMap);
    } catch (e) {
      print("Error adding employee details: $e");
    }
  }
  /// Gets employee details as a stream
  Stream<DatabaseEvent> getEmployeeDetails() {
    return dbRef.onValue; // Listens for changes in the "employees" node
  }

  /// Updates an employee's details in Realtime Database
  Future<void> updateEmployeeDetail(String id, Map<String, dynamic> updateInfo) async {
    try {
      await dbRef.child(id).update(updateInfo);
    } catch (e) {
      print("Error updating employee details: $e");
    }
  }

  /// Deletes an employee's document from Realtime Database
  Future<void> deleteEmployeeDetail(String id) async {
    try {
      await dbRef.child(id).remove();
    } catch (e) {
      print("Error deleting employee details: $e");
    }
  }

  /// Safely retrieves an employee's field, e.g., "Name"
  Future<String?> getEmployeeName(String id) async {
    try {
      DataSnapshot snapshot = await dbRef.child(id).get();
      if (snapshot.exists) {
        Map<String, dynamic>? data = Map<String, dynamic>.from(snapshot.value as Map);
        if (data.containsKey("Name")) {
          return data["Name"] as String?;
        } else {
          print('Field "Name" does not exist.');
          return null;
        }
      } else {
        print('Document does not exist.');
        return null;
      }
    } catch (e) {
      print('Error fetching employee name: $e');
      return null;
    }
  }
}