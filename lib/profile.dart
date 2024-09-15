// import 'package:flutter/material.dart';

// class ProfilePage extends StatefulWidget {
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFEFF3F6),
//       appBar: AppBar(
//         title: Text('Profile'),
//         centerTitle: true,
//         backgroundColor: Colors.blueGrey[200],
//         elevation: 0.0,
//       ),
//       body: Padding(
//         padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: CircleAvatar(
//                 backgroundImage: AssetImage('../images/rohit.jpg'),
//                 radius: 60.0,
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'NAME:',
//               style: TextStyle(
//                 color: Colors.black87,
//                 letterSpacing: 1.0,
//               ),
//             ),
//             SizedBox(height: 2),
//             Text(
//               'ROHIT SHARMA',
//               style: TextStyle(
//                 color: Colors.blue[900],
//                 letterSpacing: 1.0,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20.0,
//               ),
//             ),
            
//             SizedBox(height: 20),
//             Row(
//               children: [
//                 Icon(
//                   Icons.email_rounded,
//                   color: Colors.deepPurple[800],
//                 ),
//                 SizedBox(width: 8.0),
//                 Text(
//                   'rohitsharma264@gmail.com',
//                   style: TextStyle(
//                     color: Colors.brown[800],
//                     fontSize: 16.0,
//                     letterSpacing: 1.0,
//                   ),
//                 ),
//               ],
//             ),
            
//             SizedBox(height: 40),
//             Center(
//               child: Column(
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {},
//                     child: Text(
//                       'Edit Profile',
//                       style: TextStyle(color: Colors.white),
//                     )
//                   ),
//                   SizedBox(height: 20),
                  
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
    
//     );
//   }
// }
