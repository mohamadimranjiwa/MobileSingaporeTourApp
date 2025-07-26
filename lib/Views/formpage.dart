import 'package:flutter/material.dart';
import 'package:kuantan_tour_app/JsonModels/tourbook.dart';
import 'package:kuantan_tour_app/SQLite/sqlite.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'receipt.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>(); // Key for the form validation.
  DateTime? _startDateTime; // Variable to store the start tour date.
  DateTime? _endDateTime; // Variable to store the end tour date.
  String? _selectedPackage; // Variable to store the selected package.

  // Controllers for handling input data.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberOfPeopleController =
      TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _packagePriceController = TextEditingController();

  // Function to handle form submission.
  void _submit() async {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }

    // Check if end tour date is before start tour date
    if (_startDateTime != null && _endDateTime != null) {
      if (_endDateTime!.isBefore(_startDateTime!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('End tour date cannot be before start tour date.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    // Proceed with form submission if validation passes
    _formKey.currentState?.save();

    // Calculate package price based on selected package
    double packagePrice = double.parse(_packagePriceController.text);

    // Check discount code
    double discountPercentage = 0.0;
    String enteredDiscountCode = _discountController.text.trim();

    if (enteredDiscountCode == 'visitsingapore') {
      discountPercentage = 0.1;
    } else if (enteredDiscountCode == 'welcometosingapore') {
      discountPercentage = 0.15;
    } else if (enteredDiscountCode == 'singaporefun') {
      discountPercentage = 0.2;
    } else {
      discountPercentage = 0.0;
    }

    // Calculate total price before discount (package price * number of people)
    int numberOfPeople = int.parse(_numberOfPeopleController.text);
    double totalPriceBeforeDiscount = packagePrice * numberOfPeople;

    // Calculate discount amount
    double discountAmount = 0.0;
    if (discountPercentage > 0) {
      discountAmount = totalPriceBeforeDiscount * discountPercentage;
    }

    // Calculate total price after discount
    double totalPrice = totalPriceBeforeDiscount - discountAmount;

    // Format the discount amount text
    String discountAmountText =
        '${discountAmount.toStringAsFixed(2)} (${(discountPercentage * 100).toStringAsFixed(0)}% off)';

    final userData = {
      'Name': _nameController.text,
      'Address': _addressController.text,
      'Phone number': _phoneController.text,
      'E-Mail': _emailController.text,
      'Start Tour Date': _startDateTime != null
          ? "${_startDateTime!.day}/${_startDateTime!.month}/${_startDateTime!.year}"
          : "",
      'End Tour Date': _endDateTime != null
          ? "${_endDateTime!.day}/${_endDateTime!.month}/${_endDateTime!.year}"
          : "",
      'Package': _selectedPackage!,
      'Package Price': packagePrice.toStringAsFixed(2),
      'Number of People': numberOfPeople.toString(),
      'Price Amount': totalPriceBeforeDiscount.toStringAsFixed(2),
      'Discount Amount': discountAmountText,
      'Total Price': totalPrice.toStringAsFixed(2),
    };

    SharedPreferences pref = await SharedPreferences.getInstance();
    final userid = pref.getInt('id');

    final TourBooking tourBooking = TourBooking(
      userId: userid,
      startTour: _startDateTime!,
      endTour: _endDateTime!,
      tourPackage: _selectedPackage!,
      packagePrice: packagePrice,
      noPeople: numberOfPeople,
    );

    final db = DatabaseHelper.instance;
    db.insertTourBooking(tourBooking);

    // Navigate to Receipt screen
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Receipt(userData: userData),
    ));
  }

  // Function to select start tour date.
  Future<void> _selectStartDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _startDateTime = picked;
      });
    }
  }

  // Function to select end tour date.
  Future<void> _selectEndDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _endDateTime = picked;
      });
    }
  }

  // List of package options.
  final List<String> packageOptions = [
    'Expensive Package',
    'Premium Package',
    'Deluxe Package',
    'Classic Package',
    'Standard Package'
  ];

  // Package price map.
  final Map<String, double> packagePrices = {
    'Expensive Package': 3500.0,
    'Premium Package': 2500.0,
    'Deluxe Package': 2000.0,
    'Classic Package': 1500.0,
    'Standard Package': 1000.0,
  };

  // Form registration
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Form"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.01,
                ),

                // Name field
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  keyboardType: TextInputType.text,
                  controller: _nameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.01,
                ),

                // Address field
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Address'),
                  keyboardType: TextInputType.text,
                  controller: _addressController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Address is required';
                    }
                    return null;
                  },
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.01,
                ),

                // Phone Number field
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Phone number'),
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Phone number is required';
                    }
                    return null;
                  },
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.01,
                ),

                // Email field
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.01,
                ),

                // Start tour date field
                GestureDetector(
                  onTap: () {
                    _selectStartDateTime(context);
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Start Tour Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      keyboardType: TextInputType.datetime,
                      controller: TextEditingController(
                        text: _startDateTime != null
                            ? "${_startDateTime!.day}/${_startDateTime!.month}/${_startDateTime!.year}"
                            : null,
                      ),
                      validator: (value) {
                        if (_startDateTime == null) {
                          return 'Start Tour Date is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.01,
                ),

                // End tour date field
                GestureDetector(
                  onTap: () {
                    _selectEndDateTime(context);
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'End Tour Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      keyboardType: TextInputType.datetime,
                      controller: TextEditingController(
                        text: _endDateTime != null
                            ? "${_endDateTime!.day}/${_endDateTime!.month}/${_endDateTime!.year}"
                            : null,
                      ),
                      validator: (value) {
                        if (_endDateTime == null) {
                          return 'End Tour Date is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.01,
                ),

                // Number of People field
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Number of people'),
                  keyboardType: TextInputType.number,
                  controller: _numberOfPeopleController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Number of people is required';
                    }
                    // Use regular expression to check if the value contains only positive numbers
                    if (!RegExp(r'^[1-9][0-9]*$').hasMatch(value)) {
                      return 'Please enter a valid input (positive number)';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.01,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Discount Code'),
                  keyboardType: TextInputType.text,
                  controller: _discountController,
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.01,
                ),

                // Packages field
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Package'),
                  value: _selectedPackage,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPackage = newValue;
                      _packagePriceController.text =
                          packagePrices[newValue]!.toStringAsFixed(2);
                    });
                  },
                  items: packageOptions
                      .map<DropdownMenuItem<String>>((String value) {
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

                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.01,
                ),

                // Package price field
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Package Price'),
                  keyboardType: TextInputType.number,
                  controller: _packagePriceController,
                  readOnly: true,
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.1,
                ),

                // Button Submit field
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                        vertical: 5.0,
                      ),
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    onPressed: () => _submit(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
