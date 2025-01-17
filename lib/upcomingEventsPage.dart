import 'package:flutter/material.dart';
import 'eventDetailsPage.dart'; // Ensure you have this file

class UpcomingEventsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _eventList = [
    {
      "name": "AI and Machine Learning Workshop",
      "poster": "images/IEEE Computational Society.png", // Replace with your asset image path
      "description": "Learn the fundamentals of AI and ML in this hands-on workshop.",
      "date": "Jan 20, 2025",
      "time": "10:00 AM",
      "eligibility": "Open to All",
      "link": "https://example.com/ai-workshop",
    },
    {
      "name": "Internet Ignite",
      "poster": "images/internet ignite.jpg", // Replace with your asset image path
      "description": "Explore the latest trends and applications of blockchain technology.",
      "date": "Feb 15, 2025",
      "time": "9:00 AM",
      "eligibility": "Tech Enthusiasts",
      "link": "https://example.com/blockchain-summit",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Events",
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF000029), // Dark blue color for the app bar
      ),
      body: Container(
        color: const Color(0xFF000029), // Dark blue background for the entire screen
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: _eventList.length,
            itemBuilder: (context, index) {
              return _buildEventCard(context, _eventList[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, Map<String, dynamic> event) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      color: Colors.white, // White card background for contrast
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailsPage(
                eventName: event["name"],
                eventPoster: AssetImage(event["poster"]),
                eventDescription: event["description"],
                eventDate: event["date"],
                eventTime: event["time"],
                eligibility: event["eligibility"],
                applicationLink: event["link"],
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Poster
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.asset(
                event["poster"],
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            // Event Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event["name"],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Date: ${event["date"]}",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Eligibility: ${event["eligibility"]}",
                    style: const TextStyle(fontSize: 14, color: Colors.blueAccent),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // View Details Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF000029), // Use dark blue for buttons
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailsPage(
                          eventName: event["name"],
                          eventPoster: AssetImage(event["poster"]),
                          eventDescription: event["description"],
                          eventDate: event["date"],
                          eventTime: event["time"],
                          eligibility: event["eligibility"],
                          applicationLink: event["link"],
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "View Details",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
