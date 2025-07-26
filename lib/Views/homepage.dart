import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Singapore Attractions",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(
            color:
                Color.fromARGB(255, 0, 0, 0)), // Set back icon color to white
      ),
      backgroundColor: const Color.fromARGB(
          255, 255, 255, 255), // Set the background color to black
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/SINGAPORE.png',
              fit: BoxFit.cover,
            ),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildSection(
                  'Art Science Museum',
                  "Discover the ArtScience Museum in Singapore, where art and science converge in captivating exhibitions. Immerse yourself in a world of creativity and innovation, where every exhibit tells a unique story and sparks inspiration.",
                  'assets/SINGAPORE_ARTSCIENCE.png',
                ),
                _buildSection(
                  'Night Safari',
                  'Embark on a nocturnal adventure at Night Safari, the world’s first wildlife park for nocturnal animals. Explore diverse habitats and encounter fascinating creatures under the stars.',
                  'assets/SINGAPORE_NIGHT_SAFARI.png',
                ),
                _buildSection(
                  'Merlion Park',
                  "Discover the iconic Merlion, Singapore's mythical symbol and guardian of prosperity. Enjoy breathtaking views of the city skyline and Marina Bay, with the majestic Merlion as your backdrop.",
                  'assets/SINGAPORE_MERLION.png',
                ),
                _buildSection(
                  'Marina Bay Sands',
                  "Experience luxury and entertainment at Marina Bay Sands, an iconic integrated resort with world-class amenities. Indulge in shopping, dining, and stunning skyline views from the legendary rooftop pool.",
                  'assets/SINGAPORE_MARINA_BAY.png',
                ),
                _buildSection(
                  'Gardens By The Bay',
                  "Immerse yourself in the enchanting beauty of Gardens By The Bay, a futuristic nature park featuring stunning gardens, iconic Supertrees, and the awe-inspiring Cloud Forest and Flower Dome.",
                  'assets/SINGAPORE_GARDENS_BY_THE_BAY.png',
                ),
                _buildSection(
                  'Universal Studios Singapore',
                  "Step into the magical world of Universal Studios Singapore, where thrilling rides, captivating shows, and beloved characters come to life. Embark on an adventure of blockbuster proportions!",
                  'assets/SINGAPORE_UNIVERSAL.png',
                ),
                _buildSection(
                  'Sentosa Island',
                  "Escape to Sentosa Island, Singapore's premier leisure destination offering endless fun and relaxation. From pristine beaches to thrilling attractions, it's the perfect getaway for all ages.",
                  'assets/SINGAPORE_SENTOSA.png',
                ),
                _buildSection(
                  'Chinatown',
                  "Explore the vibrant streets of Chinatown, a cultural enclave bursting with history, heritage, and culinary delights. From traditional markets to modern boutiques, it's a feast for the senses.",
                  'assets/SINGAPORE_CHINATOWN.png',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String description, String imagePath) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 238, 238, 238),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: 100,
            height: 150,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
