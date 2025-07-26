import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kuantan_tour_app/JsonModels/tourbook.dart';

class BookingDialog extends StatefulWidget {
  final TourBooking booking;

  const BookingDialog({required this.booking, super.key});

  @override
  _BookingDialogState createState() => _BookingDialogState();
}

class _BookingDialogState extends State<BookingDialog> {
  late TextEditingController _startTourController;
  late TextEditingController _endTourController;
  late TextEditingController _noPeopleController;
  late String _selectedPackage;
  late double _packagePrice;
  final DateFormat _dateFormat = DateFormat.yMMMd();

  // List of package options.
  final List<String> packageOptions = [
    'Expensive Package',
    'Premium Package',
    'Deluxe Package',
    'Classic Package',
    'Standard Package'
  ];

  @override
  void initState() {
    super.initState();
    _selectedPackage = widget.booking.tourPackage;
    _startTourController = TextEditingController(
        text: _dateFormat.format(widget.booking.startTour));
    _endTourController =
        TextEditingController(text: _dateFormat.format(widget.booking.endTour));
    _noPeopleController =
        TextEditingController(text: widget.booking.noPeople.toString());
    _calculatePackagePrice();
  }

  @override
  void dispose() {
    _startTourController.dispose();
    _endTourController.dispose();
    _noPeopleController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime initialDate = DateTime.now();
    try {
      initialDate = _dateFormat.parse(controller.text);
    } catch (_) {}

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = _dateFormat.format(picked);
    }
  }

  void _calculatePackagePrice() {
    switch (_selectedPackage) {
      case 'Expensive Package':
        _packagePrice = 3500;
        break;
      case 'Premium Package':
        _packagePrice = 2500;
        break;
      case 'Deluxe Package':
        _packagePrice = 2000;
        break;
      case 'Classic Package':
        _packagePrice = 1500;
        break;
      case 'Standard Package':
        _packagePrice = 1000;
        break;
      default:
        _packagePrice = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Booking'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            // Packages field
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Package'),
              value: _selectedPackage,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPackage = newValue!;
                  _calculatePackagePrice();
                });
              },
              items:
                  packageOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              validator: (value) {
                if (value == null) {
                  return 'Package is required';
                }
                return null;
              },
            ),
            TextField(
              controller: _startTourController,
              decoration: InputDecoration(
                labelText: 'Start Tour',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(_startTourController),
                ),
              ),
            ),
            TextField(
              controller: _endTourController,
              decoration: InputDecoration(
                labelText: 'End Tour',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(_endTourController),
                ),
              ),
            ),
            TextField(
              controller: _noPeopleController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Number of People'),
            ),
            TextFormField(
              initialValue: _packagePrice.toString(),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Package Price'),
              readOnly: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            try {
              final updatedBooking = TourBooking(
                bookId: widget.booking.bookId,
                userId: widget.booking.userId,
                tourPackage: _selectedPackage,
                startTour: _dateFormat.parse(_startTourController.text),
                endTour: _dateFormat.parse(_endTourController.text),
                noPeople: int.parse(_noPeopleController.text),
                packagePrice: _packagePrice,
              );
              Navigator.of(context).pop(updatedBooking);
            } catch (e) {
              // Handle the error gracefully
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Invalid input: $e')),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
