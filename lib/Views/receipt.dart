import 'package:flutter/material.dart';

import 'packages.dart';

class Receipt extends StatelessWidget {
  final Map<String, String> userData;

  const Receipt({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Details:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            for (var entry in userData.entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(entry.value),
                  ],
                ),
              ),
            const SizedBox(height: 20),

            // button to navigate to the packages page
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    MaterialPageRoute(builder: (context) => Packages()),
                  );
                },
                child: const Text('Okay'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
