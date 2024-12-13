// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';

// class NotificationsPage extends StatefulWidget {
//   @override
//   _NotificationsPageState createState() => _NotificationsPageState();
// }

// class _NotificationsPageState extends State<NotificationsPage> {
//   // Example list of notifications, this should ideally be a list of a custom class or map
//   List<Map<String, dynamic>> notifications = [
//     {
//       'icon': 'assets/danger-alert.svg',
//       'title': 'Clear Route Available!',
//       'message': 'Save 15 mins with a faster route for your commute...',
//       'time': '2m'
//     },
//     {
//       'icon': 'assets/danger-alert.svg',
//       'title': 'Major Delay Ahead',
//       'message': 'Expect delays of up to 30 minutes...',
//       'time': '23m'
//     },
//     {
//       'icon': 'assets/rain-alert.svg',
//       'title': 'Rain on Your Route',
//       'message': 'Consider shifting your trip 15 minutes ahead...',
//       'time': '50m'
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text('Notifications'),
//         backgroundColor: Colors.deepPurple, // Customize app bar color
//       ),
//       body: ListView.builder(
//         itemCount: notifications.length,
//         itemBuilder: (context, index) {
//           return _buildNotificationItem(
//             context: context,
//             icon: SvgPicture.asset(notifications[index]['icon'], width: 50, height: 50),
//             title: notifications[index]['title'],
//             message: notifications[index]['message'],
//             time: notifications[index]['time'],
//             onDelete: () {
//               setState(() {
//                 notifications.removeAt(index);
//               });
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildNotificationItem({
//     required BuildContext context,
//     required SvgPicture icon,
//     required String title,
//     required String message,
//     required String time,
//     required VoidCallback onDelete,
//   }) {
//     return Slidable(
//       endActionPane: ActionPane(
//         motion: const StretchMotion(),
//         children: [
//           SlidableAction(
//             onPressed: (context) => onDelete(),
//             icon: Icons.delete,
//             backgroundColor: Colors.red,
//           ),
//         ],
//       ),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         margin: EdgeInsets.symmetric(vertical: 2),
//         decoration: BoxDecoration(
//           border: Border(
//             bottom: BorderSide(color: Colors.grey[300]!),
//           ),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//               ),
//               child: icon, // Directly use the provided icon
//             ),
//             SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     message,
//                     style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(width: 16),
//             Align(
//               alignment: Alignment.bottomRight,
//               child: Text(
//                 time,
//                 style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
