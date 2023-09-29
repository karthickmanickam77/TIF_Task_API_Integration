import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:easymusic/Event.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EventDetails extends StatefulWidget {
  final int id;
  final String title;
  final String description;
  final String bannerImage;
  final String dateTime;
  final String organiserName;
  final String organiserIcon;
  final String venueName;
  final String venueCity;
  final String venueCountry;

  EventDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.bannerImage,
    required this.dateTime,
    required this.organiserName,
    required this.organiserIcon,
    required this.venueName,
    required this.venueCity,
    required this.venueCountry,
  });
  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  bool isExpanded = false;
  String formatDate(String dateTimeStr) {
    final inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    final outputFormat = DateFormat("d MMMM, yyyy");
    final dateTime = inputFormat.parse(dateTimeStr, true);
    return outputFormat.format(dateTime);
  }
  String formatDateTimeRange(String dateTimeStr) {
    final inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    final outputDayFormat = DateFormat.EEEE(); // Full day name (e.g., Tuesday)
    final outputTimeFormat = DateFormat.jm(); // Time format (e.g., 4:00 PM)
    final dateTime = inputFormat.parse(dateTimeStr, true);

    final startTime = outputTimeFormat.format(dateTime);

    // Calculate end time (e.g., add 5 hours to the start time)
    final endTime = outputTimeFormat.format(dateTime.add(Duration(hours: 5))); // Adjust as needed

    final dayName = outputDayFormat.format(dateTime);

    return '$dayName, $startTime - $endTime';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
           child: Column(
             children: [
             Stack(
             alignment: Alignment.topLeft,
             children: [
               Image.network(widget.bannerImage,),
               Padding(
                 padding: const EdgeInsets.only(left: 18.0,top: 25),
                 child: Row(

                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         GestureDetector(onTap: (){
                           Navigator.of(context)
                               .pop();
                         },child: Icon(Icons.arrow_back,color: Colors.white,)),
                         SizedBox(
                           width: 12,
                         ),
                         Text(
                           'Event Details',
                           style: TextStyle(
                             color: Color(0xffFFFFFF),
                             fontSize: 25,
                             fontFamily: 'Inter',
                             letterSpacing: 1,
                             fontWeight: FontWeight.w500,
                           ),
                         ),

                       ],
                     ),
                     Padding(
                       padding: const EdgeInsets.only(left: 130.0),
                       child: Container(
                         decoration: BoxDecoration(
                           color: Color(0x90bf8f89),
                           borderRadius: BorderRadius.circular(10),
                         ),
                         height: 36,
                         width: 36,
                         child: Icon(Icons.bookmark_rounded,color: Colors.white,size: 22,),
                       ),
                     ),
                   ],
                 ),
               ),
             ],
           ),
             Column(

               children: [
                 Padding(
                   padding: const EdgeInsets.only(left:38,top: 28.0),
                   child: SizedBox(
                     width: 413,
                     height: 84,
                     child: Text(widget.title,
                       maxLines: 2,
                       style: TextStyle(
                       fontSize: 35,
                       fontWeight: FontWeight.w400,
                       fontFamily: 'Inter',
                     ),),
                   ),
                 ),
                 Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Padding(
                       padding: const EdgeInsets.only(left:38,),
                       child: Container(
                         height: 51.68,
                         width: 54,
                         child: ClipRRect(
                           borderRadius: BorderRadius.circular(17),
                           child: widget.organiserIcon.toLowerCase().endsWith('.svg')
                               ? SvgPicture.network(widget.organiserIcon, fit: BoxFit.fitWidth)
                               : Image.network(widget.organiserIcon, fit: BoxFit.fitWidth),
                         ),
                       ),
                     ),
                     SizedBox(
                       width: 10,
                     ),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Row(
                           children: [
                             Text(widget.organiserName,style: TextStyle(
                               fontSize: 15,
                                fontWeight: FontWeight.w400,
                               fontFamily: 'Inter',
                               color: Color(0xff0D0C26),
                             ),),
                           ],
                         ),
                         SizedBox(
                           height: 8,
                         ),
                         Row(
                           children: [
                             Text('Organiser',style: TextStyle(
                               color: Colors.grey,
                             ),),
                           ],
                         ),
                       ],
                     ),
                   ],
                 ),
                 Padding(
                   padding: const EdgeInsets.only(top: 18.0),
                   child: Row(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Padding(
                         padding: const EdgeInsets.only(left:38,),
                         child: Container(
                           height: 48,
                           width: 48,
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(12),
                             color: Color(0xFFEEF0FF),
                           ),
                           child:Icon(Icons.calendar_month_rounded,size: 30,color: Colors.blue,),
                         ),
                       ),
                       SizedBox(
                         width: 15,
                       ),
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Row(
                             children: [
                               Text(formatDate(widget.dateTime),style: TextStyle(
                                 fontSize: 15,
                                 fontWeight: FontWeight.w400,
                                 fontFamily: 'Inter',
                                 color: Color(0xff0D0C26),
                               ),),
                             ],
                           ),
                           SizedBox(
                             height: 8,
                           ),
                           Row(
                             children: [
                               Text(formatDateTimeRange(widget.dateTime),style: TextStyle(
                                 color: Colors.grey,
                               ),),
                             ],
                           ),
                         ],
                       ),
                     ],
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.only(top: 18.0),
                   child: Row(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Padding(
                         padding: const EdgeInsets.only(left:38,),
                         child: Container(
                           height: 48,
                           width: 48,
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(12),
                             color: Color(0xFFEEF0FF),
                           ),
                           child:Icon(Icons.location_on_rounded,
                             color: Colors.blue,size: 30,),
                         ),
                       ),

                       SizedBox(
                         width: 15,
                       ),
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Row(
                             children: [
                               Text(widget.organiserName,style: TextStyle(
                                 fontSize: 15,
                                 fontWeight: FontWeight.w400,
                                 fontFamily: 'Inter',
                                 color: Color(0xff0D0C26),
                               ),),
                             ],
                           ),
                           SizedBox(
                             height: 8,
                           ),
                           Row(
                             children: [
                               SizedBox(
                                 width:280.0,
                                 child: Text(widget.venueName+' '+widget.venueCity+', '+widget.venueCountry,style: TextStyle(
                                   color: Colors.grey,
                                 ),),
                               ),
                             ],
                           ),
                         ],
                       ),
                     ],
                   ),
                 ),

               ],
             ),
               Column(
                 children: [
                   Padding(
                     padding: const EdgeInsets.only(top: 20.0,right: 235),
                     child: Text('About Event',style: TextStyle(
                       fontSize: 18,
                       fontWeight: FontWeight.w500,
                       fontFamily: 'Inter',
                     ),),
                   ),




            GestureDetector(
            onTap: () {
      setState(() {
      isExpanded = !isExpanded;
      });
      },
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, right: 30, left: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.description,
                maxLines: isExpanded ? null : 3, // Remove max lines limit when expanded
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
              if (widget.description.split('\n').length > 3 && !isExpanded)
                Text(
                  'Read more...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue, // Set the text color to blue
                  ),
                ),
            ],
          ),
        ),
      ),


      SizedBox(height: 11,),
                   Container(
                     height: 58,
                     width: 271,
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(20),
                       color: Color(0xff3D56F0),
                     ),
                     child: Container(
                       decoration: BoxDecoration(
                         boxShadow: [
                           BoxShadow(
                             color: Colors.white,
                             spreadRadius: 8, // Increase the spread radius for a spreaded effect
                             blurRadius: 8,
                             offset: Offset(0, -8), // Offset it upwards
                           ),
                         ],
                       ),
                       child: ElevatedButton(
                         onPressed: () {},
                         style: ElevatedButton.styleFrom(
                           primary: Colors.blue, // Set button background color
                           elevation: 0, // Remove the button's own elevation
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(20),
                           ),
                         ),
                         child: Container(
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Padding(
                                 padding: const EdgeInsets.only(left: 60.0),
                                 child: Text(
                                   'Book Now',
                                   style: TextStyle(
                                     fontFamily: 'Inter',
                                     fontSize: 17,
                                     fontWeight: FontWeight.w500,
                                   ),
                                 ),
                               ),
                               SizedBox(width: 60),
                               Container(
                                 height: 30,
                                 width: 30,
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(20),
                                   color: Color(0xff3D56F0),
                                 ),
                                 child: Icon(
                                   Icons.arrow_forward,
                                   color: Colors.white,
                                   size: 15,
                                 ),
                               ),
                             ],
                           ),
                         ),
                       ),
                     ),
                   )
                 ],
               ),
             ],
           ),
          ),
        ),
      ),
    );
  }
}
