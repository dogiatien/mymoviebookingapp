import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'success_screen.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final Movie movie;

  BookingScreen(this.movie);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _ticketCount = 1;
  String _selectedSeat = 'A1';
  List<String> selectedSeats = [];
  List<String> allSeats = [
    'A1',
    'A2',
    'A3',
    'A4',
    'A5',
    'A6',
    'B1',
    'B2',
    'B3',
    'B4',
    'B5',
    'B6',
    'C1',
    'C2',
    'C3',
    'C4',
    'C5',
    'C6',
    'D1',
    'D2',
    'D3',
    'D4',
    'D5',
    'D6',
  ];

  double _ticketPrice = 70.000; // Giả sử giá vé mặc định là $10

  String? _selectedTheater;
  DateTime? _selectedDate;
  String? _selectedTime;

  final List<String> _theaters = ['Theater 1', 'Theater 2', 'Theater 3'];
  final List<String> _times = ['10:00 AM', '1:00 PM', '4:00 PM', '7:00 PM'];

  // Tính giá vé cho từng ghế
  double _calculateTicketPrice() {
    return selectedSeats.length * _ticketPrice;
  }

  void _toggleSelectedSeat(String seat) {
    setState(() {
      if (selectedSeats.contains(seat)) {
        selectedSeats.remove(seat);
      } else {
        selectedSeats.add(seat);
      }
    });
  }

  // Tạo danh sách các ngày từ hôm nay đến 6 ngày tiếp theo
  List<DateTime> _getDates() {
    return List.generate(
        7, (index) => DateTime.now().add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> dates = _getDates();
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Tickets for ${widget.movie.title}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.movie.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                hint: Text('Select Theater'),
                value: _selectedTheater,
                items: _theaters.map((theater) {
                  return DropdownMenuItem<String>(
                    value: theater,
                    child: Text(theater),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTheater = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Text('Select Date'),
              Container(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: dates.length,
                  itemBuilder: (context, index) {
                    DateTime date = dates[index];
                    bool isSelected =
                        _selectedDate != null && _selectedDate!.day == date.day;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? Colors.blue : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat.E().format(date), // Hiển thị thứ
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              DateFormat.d().format(date), // Hiển thị ngày
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                hint: Text('Select Time'),
                value: _selectedTime,
                items: _times.map((time) {
                  return DropdownMenuItem<String>(
                    value: time,
                    child: Text(time),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTime = value;
                  });
                },
              ),
              SizedBox(height: 20),
              if (_selectedTheater != null &&
                  _selectedDate != null &&
                  _selectedTime != null) ...[
                Text('Select Seat(s)'),
                Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: allSeats.map((seat) {
                    bool isSelected = selectedSeats.contains(seat);
                    return GestureDetector(
                      onTap: () => _toggleSelectedSeat(seat),
                      child: Chip(
                        label: Text(seat),
                        backgroundColor:
                            isSelected ? Colors.blue : Colors.grey.shade300,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Text(
                    'Total Amount: \$${_calculateTicketPrice().toStringAsFixed(2)}'),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedSeats.isNotEmpty) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (ctx) => SuccessScreen(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Please select at least one seat!')),
                        );
                      }
                    },
                    child: Text(
                      'Book Now',
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _handlePayment(String paymentMethod) {
    // Xử lý thanh toán ở đây
    // Sau khi thanh toán thành công, điều hướng đến màn hình thành công
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => SuccessScreen(),
      ),
    );
  }
}
