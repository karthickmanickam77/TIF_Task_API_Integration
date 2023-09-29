import 'Details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:easymusic/Event.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';


class Search extends StatefulWidget {

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late Future<List<dynamic>> eventData;
  List<Event> events = [];
  List<Event> filtered = [];

  @override
  void initState() {
    super.initState();
    fetchEventData();
  }

  String formatDateTime(String dateTime) {
    final parsedDateTime = DateTime.parse(dateTime);
    final dayName = DateFormat.E().format(parsedDateTime); // Full day name (e.g., Wednesday)
    final abbreviatedDay = dayName.substring(0, 3); // Shortened to three characters (e.g., Wed)
    final formattedDate = DateFormat.MMMd().format(parsedDateTime); // Date (e.g., Apr 28)
    final time = DateFormat.jm().format(parsedDateTime); // Time (e.g., 5:30 PM)

    return '$abbreviatedDay, $formattedDate · $time';
  }




  Future<void> fetchEventData() async {
    final apiUrl = 'https://sde-007.api.assignment.theinternetfolks.works/v1/event';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        final List<Event> eventList = (jsonData['content']['data'] as List).map((eventData) {
          return Event(
            id: eventData['id'],
            title: eventData['title'],
            description: eventData['description'],
            bannerImage: eventData['banner_image'],
            dateTime: eventData['date_time'],
            organiserName: eventData['organiser_name'],
            organiserIcon: eventData['organiser_icon'],
            venueName: eventData['venue_name'],
            venueCity: eventData['venue_city'],
            venueCountry: eventData['venue_country'],
          );
        }).toList();

        setState(() {
          events = eventList;
        });
      } else {
        throw Exception(
            'API Request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('API Request failed with error: $error');
    }
  }

  void filterEvents(String query) {
    setState(() {
      if (query.isEmpty) {
        // When the query is empty, show all events
        filtered = events;
      } else {
        // Filter events based on the query
        filtered = events
            .where((event) =>
        event.title.toLowerCase().contains(query.toLowerCase()) ||
            event.description.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize filtered list with all events in the 'didChangeDependencies' method
    filtered = events;
  }
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top:18.0),
                child: Row(
                  children: [
                    IconButton(onPressed: (){
                      Navigator.of(context)
                          .pop();
                    }, icon: Icon(Icons.arrow_back),),
                    Text('Search',style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      fontWeight: FontWeight.w500,

                    ),),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0,left: 24),
                    child: Icon(Icons.search,color: Colors.blue,size: 30  ,),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0,left: 10),
                    child: Image.asset('lib/images/line.png',height: 23,color: Colors.blue,),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: TextField(
                        onChanged: (query) {
                          filterEvents(query);
                        },
                        decoration: InputDecoration(
                          labelText: 'Type Event Name',
                          labelStyle: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: events.isEmpty
                    ? Center(
                  child: CircularProgressIndicator(),
                )
                    :ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (BuildContext context, int index) {
                    final event = filtered[index];
                    return GestureDetector(
                      onTap: (){
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                            builder: (context) => EventDetails(
                              id: events[index].id,
                              title: events[index].title,
                              description: events[index].description,
                              bannerImage: events[index].bannerImage,
                              dateTime: events[index].dateTime,
                              organiserName: events[index].organiserName,
                              organiserIcon: events[index].organiserIcon,
                              venueName: events[index].venueName,
                              venueCity: events[index].venueCity,
                              venueCountry: events[index].venueCountry,
                            )));

                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 9.0, right: 9.0, bottom: 9.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: Offset(0, 7),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:Container(
                                      height: 92,
                                      width: 79,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(17),
                                        child: event.organiserIcon.toLowerCase().endsWith('.svg')
                                            ? SvgPicture.network(event.organiserIcon, fit: BoxFit.fitWidth)
                                            : Image.network(event.organiserIcon, fit: BoxFit.fitWidth),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        formatDateTime(event.dateTime),
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 13,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width:200.0,
                                        child: Text(event.organiserName,
                                          maxLines:2,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,

                                          ),),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),

                                  Row(
                                    children: [
                                      Icon(Icons.location_on_rounded, color: Colors.grey),
                                      SizedBox(width: 3),
                                      SizedBox(
                                        width: 200.0,
                                        child: Text(
                                          event.venueName + ' . ' + event.venueCity + ',' + event.venueCountry,
                                          maxLines: 3, // Allow the text to occupy up to two lines
                                          overflow: TextOverflow.ellipsis, // Show ellipsis when overflowing
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
