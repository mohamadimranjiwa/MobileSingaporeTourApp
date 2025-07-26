import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kuantan_tour_app/JsonModels/tourbook.dart';
import 'package:kuantan_tour_app/SQLite/sqlite.dart';
import 'package:kuantan_tour_app/Views/bookingdialog.dart';
import 'package:kuantan_tour_app/Views/myhomepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final db = DatabaseHelper.instance;

  void _editBooking(TourBooking booking) async {
    final result = await showDialog<TourBooking>(
      context: context,
      builder: (context) => BookingDialog(booking: booking),
    );

    if (result != null) {
      await db.updateBooking(result);
      setState(() {}); // Refresh the UI
    }
  }

  Future<void> _deleteBooking(int bookId) async {
    await db.deleteBooking(bookId);
    setState(() {}); // Refresh the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('id');

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(
                      title: 'VISIT SINGAPORE!',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.logout))
        ],
        title: const Text('Admin Page'),
      ),
      body: FutureBuilder(
        future: db.getAllTourBookingsWithUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No bookings found.'));
          } else {
            final List<Map<String, dynamic>> bookings = snapshot.data!;
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> data = bookings[index];
                final booking = TourBooking.fromMap(data);

                return Card(
                  child: ListTile(
                    title: Text('Tour: ${booking.tourPackage}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Book ID: ${booking.bookId}'),
                        Text('User ID: ${booking.userId}'),
                        Text('User Name: ${data['name']}'),
                        Text(
                            'Start: ${DateFormat.yMMMd().format(booking.startTour)}'),
                        Text(
                            'End: ${DateFormat.yMMMd().format(booking.endTour)}'),
                        Text('People: ${booking.noPeople}'),
                        Text('Price: RM ${booking.packagePrice}'),
                        Text(
                            'Total Price: RM ${booking.packagePrice * booking.noPeople!}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _editBooking(booking);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteBooking(booking.bookId!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
