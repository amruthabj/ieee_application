import 'package:flutter/material.dart';

class EventDetailsPage extends StatelessWidget {

  final String eventName;
  final String eventPoster;
  final String eventDescription;
  final String eventDate;
  final String eventTime;
  final String eligibility;
  final String applicationLink;

  const EventDetailsPage({
    required this.eventName,
    required this.eventPoster,
    required this.eventDescription,
    required this.eventDate,
    required this.eventTime,
    required this.eligibility,
    required this.applicationLink,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(eventName),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                eventPoster,
                width: MediaQuery.of(context).size.width * 0.9,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Description",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              eventDescription,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              "Date: $eventDate",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Time: $eventTime",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              "Eligibility",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              eligibility,
              style: const TextStyle(fontSize: 16, color: Colors.blueAccent),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Apply Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
