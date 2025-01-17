import 'package:flutter/material.dart';
import 'attendence.dart'; // Ensure this file is correct and accessible

class EventDetailsPage extends StatelessWidget {
  final String eventName;
  final ImageProvider eventPoster; // Correct type for eventPoster
  final String eventDescription;
  final String eventDate;
  final String eventTime;
  final String eligibility;
  final String applicationLink;

  const EventDetailsPage({
    Key? key,
    required this.eventName,
    required this.eventPoster,
    required this.eventDescription,
    required this.eventDate,
    required this.eventTime,
    required this.eligibility,
    required this.applicationLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          eventName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Poster
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image(
                  image: eventPoster, // Use ImageProvider directly
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Description Section
            _buildSectionTitle("Description"),
            const SizedBox(height: 8),
            Text(
              eventDescription,
              style: const TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            // Event Date and Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoCard("Date", eventDate),
                _buildInfoCard("Time", eventTime),
              ],
            ),
            const SizedBox(height: 16),
            // Eligibility Section
            _buildSectionTitle("Eligibility"),
            const SizedBox(height: 8),
            Text(
              eligibility,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blueAccent,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            // Action Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BulkUpload()),
                  );
                },
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                ),
                label: const Text(
                  "Add Attendance",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build section titles
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  // Helper widget to build information cards
  Widget _buildInfoCard(String title, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
