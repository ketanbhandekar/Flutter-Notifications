// import 'package:firebase_database/firebase_database.dart'; // Import Realtime Database
// import 'package:flutter/material.dart';
// import 'package:notifications/database.dart';
// import 'employee.dart';
//
// class Home extends StatefulWidget {
//   const Home({super.key});
//
//   @override
//   State<Home> createState() => _HomeState();
// }
// class _HomeState extends State<Home> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController ageController = TextEditingController();
//   final TextEditingController locationController = TextEditingController();
//
//   Stream<DatabaseEvent>? employeeStream;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadEmployeeData();
//   }
//
//   Future<void> _loadEmployeeData() async {
//     // Get a stream of the Realtime Database employees
//     employeeStream = FirebaseDatabase.instance.ref("employees").onValue;
//     setState(() {});
//   }
//
//   Widget allEmployeeDetails() {
//     return StreamBuilder(
//       stream: employeeStream,
//       builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
//         if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
//           return Center(child: Text("No data found"));
//         }
//
//         Map<dynamic, dynamic> employees = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
//         List<dynamic> keys = employees.keys.toList();
//
//         return ListView.builder(
//           itemCount: keys.length,
//           itemBuilder: (context, index) {
//             String key = keys[index];
//             Map<dynamic, dynamic> employee = employees[key];
//             return Container(
//               margin: const EdgeInsets.only(bottom: 20.0),
//               child: Material(
//                 elevation: 5.0,
//                 borderRadius: BorderRadius.circular(10),
//                 child: Container(
//                   padding: const EdgeInsets.all(20),
//                   width: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             "Name: ${employee["Name"]}",
//                             style: const TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 20.0,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           const Spacer(),
//                           GestureDetector(
//                             onTap: () {
//                               nameController.text = employee["Name"];
//                               ageController.text = employee["Age"];
//                               locationController.text = employee["Location"];
//                               editEmployeeDetail(key);
//                             },
//                             child: const Icon(Icons.edit, color: Colors.orange),
//                           ),
//                           const SizedBox(width: 5.0),
//                           GestureDetector(
//                             onTap: () async {
//                               await FirebaseDatabase.instance.ref("employees/$key").remove();
//                             },
//                             child: const Icon(Icons.delete, color: Colors.orange),
//                           )
//                         ],
//                       ),
//                       Text(
//                         "Age: ${employee["Age"]}",
//                         style: const TextStyle(
//                             color: Colors.black,
//                             fontSize: 20.0,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         "Location: ${employee["Location"]}",
//                         style: const TextStyle(
//                             color: Colors.black,
//                             fontSize: 20.0,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//   Future<void> editEmployeeDetail(String id) => showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Edit Details",
//             style: TextStyle(color: Colors.orange, fontSize: 20.0, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 20.0),
//           const Text("Name:"),
//           TextField(
//             controller: nameController,
//             decoration: const InputDecoration(border: OutlineInputBorder()),
//           ),
//           const SizedBox(height: 10.0),
//           const Text("Age:"),
//           TextField(
//             controller: ageController,
//             decoration: const InputDecoration(border: OutlineInputBorder()),
//           ),
//           const SizedBox(height: 10.0),
//           const Text("Location:"),
//           TextField(
//             controller: locationController,
//             decoration: const InputDecoration(border: OutlineInputBorder()),
//           ),
//           const SizedBox(height: 20.0),
//           ElevatedButton(
//             onPressed: () async {
//               Map<String, dynamic> updatedInfo = {
//                 "Name": nameController.text,
//                 "Age": ageController.text,
//                 "Location": locationController.text,
//               };
//
//               await FirebaseDatabase.instance.ref("employees/$id").update(updatedInfo);
//               Navigator.pop(context);
//             },
//             child: const Text("Update"),
//           ),
//         ],
//       ),
//     ),
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) =>  EmployeeApp()),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//       appBar: AppBar(
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const [
//             Text(
//               "Flutter",
//               style: TextStyle(color: Colors.blue, fontSize: 24.0, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               "Firebase",
//               style: TextStyle(color: Colors.orange, fontSize: 24.0, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//       body: Container(
//         margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
//         child: Column(
//           children: [
//             Expanded(child: allEmployeeDetails()),
//           ],
//         ),
//       ),
//     );
//   }
// }