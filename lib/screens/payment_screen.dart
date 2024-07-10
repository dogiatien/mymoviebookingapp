import 'package:flutter/material.dart';
import '../models/ticket.dart';
import '../models/movie.dart';
import '../models/showtime.dart';
import '../screens/success_screen.dart';
import '../database/firestore_service.dart'; // Import your Firestore service

class PaymentScreen extends StatelessWidget {
  final List<Ticket> tickets;
  final double totalAmount;
  final FirestoreService firestoreService = FirestoreService();

  PaymentScreen({required this.tickets, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tickets',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            FutureBuilder(
              future: fetchTicketDetails(),
              builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: tickets.length,
                      itemBuilder: (context, index) {
                        Ticket ticket = tickets[index];
                        Movie movie = snapshot.data![index]['movie'];
                        Showtime showtime = snapshot.data![index]['showtime'];

                        return ListTile(
                          title: Text('Movie: ${movie.title}'),
                          subtitle: Text('Showtime: ${showtime.startTime} - ${showtime.endTime}'),
                        );
                      },
                    );
                  }
                }
              },
            ),
            SizedBox(height: 20),
            Text('Total Amount: \$${totalAmount.toStringAsFixed(2)}'),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add payment processing logic here
                  // For example, call a payment API or navigate to a payment gateway
                  // After successful payment, you can navigate to a success screen
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => SuccessScreen(),
                    ),
                  );
                },
                child: Text('Proceed to Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchTicketDetails() async {
    List<Map<String, dynamic>> ticketDetails = [];

    for (Ticket ticket in tickets) {
      Movie movie = await firestoreService.getMovieById(ticket.movieId);
      Showtime showtime = await firestoreService.getShowtimeById(ticket.stid);

      ticketDetails.add({
        'movie': movie,
        'showtime': showtime,
      });
    }

    return ticketDetails;
  }
}
