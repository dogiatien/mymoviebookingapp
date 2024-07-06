import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moviebookingapp/app_colors.dart';

import '../database/firestore_service.dart';
import '../models/showtime.dart';

class ManageShowtimesPage extends StatefulWidget {
  const ManageShowtimesPage({super.key});

  @override
  State<ManageShowtimesPage> createState() => _ManageShowtimesPageState();
}

class _ManageShowtimesPageState extends State<ManageShowtimesPage> {
  List<Showtime> data = [];
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  TextEditingController stidController = TextEditingController();
  TextEditingController movieIdController = TextEditingController();
  TextEditingController theaterIdController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    data.clear();
    List<Showtime> showtimes = await FirestoreService().getShowtimes();
    setState(() {
      // Update state with the fetched data
      data.addAll(showtimes);
    });
    print('data size: ${showtimes.length}');
  }

  void _addShowtime({Showtime? showtime}) async {
    stidController.text = '';
    movieIdController.text = '';
    theaterIdController.text = '';
    startTimeController.text = '';
    endTimeController.text = '';
    dateController.text = '';

    bool isEdit = false;
    if (showtime != null) {
      isEdit = true;
      stidController.text = showtime.stid;
      movieIdController.text = showtime.movieId;
      theaterIdController.text = showtime.theaterId;
      try {
        startTimeController.text =
            DateFormat('yyyy-MM-dd HH:mm').format(showtime.startTime);
        endTimeController.text =
            DateFormat('yyyy-MM-dd HH:mm').format(showtime.endTime);
        dateController.text =
            DateFormat('yyyy-MM-dd HH:mm').format(showtime.date);
      } catch (e) {}
    }

    showBottomSheet(
        context: context,
        builder: (c) {
          return Container(
            color: AppColors.admin_color,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      isEdit ? 'Sửa dữ liệu' : 'Thêm dữ liệu',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  isEdit
                      ? Text('ShowTimeID: ${stidController.text}')
                      : TextField(
                          textAlign: TextAlign.start,
                          controller: stidController,
                          decoration: const InputDecoration(
                            // border: B,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            alignLabelWithHint: true,
                            label: Text(
                              'stid',
                            ),
                          ),
                        ),
                  TextField(
                    textAlign: TextAlign.start,
                    controller: movieIdController,
                    decoration: const InputDecoration(
                      // border: B,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      alignLabelWithHint: true,
                      label: Text(
                        'movieId',
                      ),
                    ),
                  ),
                  TextField(
                    textAlign: TextAlign.start,
                    controller: theaterIdController,
                    decoration: const InputDecoration(
                      // border: B,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      alignLabelWithHint: true,
                      label: Text(
                        'theaterId',
                      ),
                    ),
                  ),
                  TextField(
                    textAlign: TextAlign.start,
                    controller: startTimeController,
                    maxLength: 16,
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                      // border: B,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      alignLabelWithHint: true,
                      label: Text(
                        'startTime',
                      ),
                    ),
                    onChanged: (value) {
                      _handleDateInput(value, 0);
                    },
                  ),
                  TextField(
                    textAlign: TextAlign.start,
                    controller: endTimeController,
                    keyboardType: TextInputType.datetime,
                    maxLength: 16,
                    decoration: const InputDecoration(
                      // border: B,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      alignLabelWithHint: true,
                      label: Text(
                        'endTime',
                      ),
                    ),
                    onChanged: (value) {
                      _handleDateInput(value, 1);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    textAlign: TextAlign.start,
                    controller: dateController,
                    keyboardType: TextInputType.datetime,
                    maxLength: 16,
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      alignLabelWithHint: true,
                      label: Text(
                        'date',
                      ),
                    ),
                    onChanged: (value) {
                      _handleDateInput(value, 2);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                        onPressed: () {
                          if (startTimeController.text == '' ||
                              endTimeController.text == '' ||
                              stidController.text == '' ||
                              theaterIdController.text == '' ||
                              movieIdController.text == '' ||
                              dateController.text == '') {
                            return;
                          }
                          Showtime newShowtime = Showtime(
                              stid: stidController.text,
                              movieId: movieIdController.text,
                              theaterId: theaterIdController.text,
                              startTime: DateTime(2024, 6, 21, 18, 0),
                              endTime: DateTime(2024, 6, 21, 18, 0),
                              date: DateTime(2024, 6, 21, 18, 0));

                          isEdit
                              ? _readyEditShowtime(newShowtime)
                              : _readyAddShowtime(newShowtime);
                        },
                        child: Text('Đồng ý')),
                  ),
                ],
              ),
            ),
          );
        });
    // await FirestoreService().addShowtimes();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: (data.length == 0)
                ? Center(
                    child: Text('Không có dữ liệu'),
                  )
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      Showtime showtime = data[index];
                      return _itemShowtimeWidget(showtime);
                    }),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
                onPressed: () {
                  _addShowtime();
                },
                child: Text('Thêm dữ liệu')),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Widget _itemShowtimeWidget(Showtime showtime) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        // color: Colors.white,
        child: Container(
          margin: EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('stid: ${showtime.stid}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'BeVietnamPro')),
                    Text('movieId: ${showtime.movieId}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'BeVietnamPro')),
                    Text('theaterId: ${showtime.theaterId}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'BeVietnamPro')),
                    Text(
                        'startTime: ${DateFormat('yyyy-MM-dd HH:mm').format(showtime.startTime)}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'BeVietnamPro')),
                    Text(
                        'endTime: ${DateFormat('yyyy-MM-dd HH:mm').format(showtime.endTime)}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'BeVietnamPro')),
                    Text(
                        'date: ${DateFormat('yyyy-MM-dd HH:mm').format(showtime.date)}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'BeVietnamPro')),
                  ],
                ),
              ),
              SizedBox(
                width: 40,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            _addShowtime(showtime: showtime);
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.black,
                          )),
                      IconButton(
                          onPressed: () {
                            _readyRemoveShowtime(showtime);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.orangeAccent,
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _handleDateInput(String value, int type) {
    try {
      // Remove any non-digit characters and check if we have 8 digits (ddMMyyyy)
      String digitsOnly = value.replaceAll(RegExp(r'\D'), '');
      if (digitsOnly.length == 8) {
        // Format the input as dd/MM/yyyy
        String formatted =
            '${digitsOnly.substring(0, 2)}/${digitsOnly.substring(2, 4)}/${digitsOnly.substring(4, 8)}';
        DateTime date = dateFormat.parse(formatted);

        if (type == 0) {
          startTimeController.value = TextEditingValue(
            text: dateFormat.format(date),
            selection: TextSelection.fromPosition(
              TextPosition(offset: dateFormat.format(date).length),
            ),
          );
        } else if (type == 1) {
          endTimeController.value = TextEditingValue(
            text: dateFormat.format(date),
            selection: TextSelection.fromPosition(
              TextPosition(offset: dateFormat.format(date).length),
            ),
          );
        } else {
          dateController.value = TextEditingValue(
            text: dateFormat.format(date),
            selection: TextSelection.fromPosition(
              TextPosition(offset: dateFormat.format(date).length),
            ),
          );
        }
      }
    } catch (e) {
      // Handle any parsing errors if needed
    }
  }

  void _readyAddShowtime(Showtime showtime) async {
    await FirestoreService().addShowtimes(showtime);
    Navigator.pop(context);
    fetchData();
  }

  void _readyEditShowtime(Showtime newShowtime) async {
    await FirestoreService().updateShowtimes(newShowtime);
    Navigator.pop(context);
    fetchData();
  }

  void _readyRemoveShowtime(Showtime newShowtime) async {
    await FirestoreService().deleteShowtimes(newShowtime.stid);
    fetchData();
  }
}
