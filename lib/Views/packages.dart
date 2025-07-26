import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Packages(),
  ));
}

class Packages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Our Packages'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildPackage(
              [
                'assets/SINGAPORE_UNIVERSAL.png',
                'assets/SINGAPORE_NIGHT_SAFARI.png',
                'assets/SINGAPORE_MERLION.png',
                'assets/SINGAPORE_ARTSCIENCE.png',
                'assets/SINGAPORE_MARINA_BAY.png',
                'assets/SINGAPORE_GARDENS_BY_THE_BAY.png',
                'assets/SINGAPORE_SENTOSA.png'
              ],
              'Expensive Package',
              4,
              '''
    Package Price: RM 3500 per pax

    Immerse yourself in a world of cinematic wonder at Universal Studios Singapore. From heart-pounding rides to captivating shows, the magic of your favorite movies comes to life. After an exhilarating adventure, embark on a captivating journey through the nocturnal wonders of Night Safari, where you'll encounter fascinating creatures under the stars. Then, stand in awe of the majestic Merlion at Merlion Park and soak in breathtaking views of Marina Bay. Explore the fascinating exhibits at the ArtScience Museum, where art, science, design, and technology converge in a truly unique experience. Conclude your adventure with a visit to the iconic Gardens By The Bay, where futuristic landscapes and stunning flora await. With each attraction offering a unique experience, this package promises a memorable adventure for all.
    ''',
              context,
            ),
            buildPackage(
              [
                'assets/SINGAPORE_NIGHT_SAFARI.png',
                'assets/SINGAPORE_MERLION.png',
                'assets/SINGAPORE_MARINA_BAY.png',
                'assets/SINGAPORE_GARDENS_BY_THE_BAY.png',
                'assets/SINGAPORE_SENTOSA.png'
              ],
              'Premium Package',
              3.5,
              '''
    Package Price: RM 2500 per pax

    Embark on a thrilling nocturnal safari at Night Safari, where you'll encounter the fascinating world of nocturnal animals. As night falls, explore diverse habitats and witness the magic of the animal kingdom under the stars. Then, journey to Merlion Park and marvel at the iconic symbol of Singapore, standing tall against the stunning backdrop of Marina Bay. Continue your adventure with a visit to Marina Bay Sands, an architectural marvel offering unparalleled luxury and entertainment. Conclude your experience with a leisurely stroll through Gardens By The Bay, where futuristic landscapes and vibrant flora await. This package promises an enchanting blend of adventure and relaxation for the discerning traveler.
    ''',
              context,
            ),
            buildPackage(
                [
                  'assets/SINGAPORE_MERLION.png',
                  'assets/SINGAPORE_MARINA_BAY.png',
                  'assets/SINGAPORE_GARDENS_BY_THE_BAY.png',
                  'assets/SINGAPORE_CHINATOWN.png'
                ],
                'Deluxe Package',
                4.5,
                '''
      Package Price: RM 2000 per pax

      Experience the essence of Singapore's heritage and modernity with the Deluxe Package. Begin your journey at Merlion Park, where the iconic Merlion stands as a symbol of the city's prosperity. Enjoy panoramic views of Marina Bay and explore the vibrant streets of Chinatown, steeped in rich culture and history. Then, indulge in the luxurious amenities of Marina Bay Sands, where world-class entertainment and dining options await. Conclude your adventure with a tranquil retreat to Gardens By The Bay, where lush gardens and stunning Supertrees create an unforgettable ambiance. With a perfect blend of culture, luxury, and natural beauty, this package offers an unparalleled Singapore experience.
      ''',
                context),
            buildPackage(
                [
                  'assets/SINGAPORE_MARINA_BAY.png',
                  'assets/SINGAPORE_CHINATOWN.png',
                  'assets/SINGAPORE_NIGHT_SAFARI.png'
                ],
                'Classic Package',
                5,
                '''
      Package Price: RM 1500 per pax

      Dive into the heart of Singapore's cultural and architectural wonders with the Classic Package. Start your journey at Marina Bay, where the iconic skyline and legendary rooftop pool of Marina Bay Sands await. Explore the bustling streets of Chinatown, brimming with vibrant markets and delectable cuisine. Then, immerse yourself in the rich heritage of Baba Nyonya culture, with a visit to the Baba Nyonya Heritage Museum. With its exquisite architecture and fascinating artifacts, it offers a glimpse into Singapore's multicultural past. Discover the perfect blend of tradition and modernity as you explore the iconic landmarks of the Lion City.
      ''',
                context),
            buildPackage(
                [
                  'assets/SINGAPORE_GARDENS_BY_THE_BAY.png',
                  'assets/SINGAPORE_CHINATOWN.png'
                ],
                'Standard Package',
                3,
                '''
      Package Price: RM 1000 per pax

      Experience the best of Singapore's natural and cultural attractions with the Standard Package. Begin your journey at Gardens By The Bay, a futuristic oasis where lush gardens and towering Supertrees await. Then, dive into the vibrant streets of Chinatown, where traditional markets and historic temples offer a glimpse into Singapore's past. With its captivating blend of nature and heritage, this package promises an enriching and memorable experience for travelers of all ages.
      ''',
                context),
          ],
        ),
      ),
    );
  }

  Widget buildPackage(List<String> images, String title, double initialRating,
      String packageDetails, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PackageDetail(
                    images,
                    title,
                    initialRating,
                    packageDetails,
                  )),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 200,
                enableInfiniteScroll: true,
                autoPlay: true,
                viewportFraction: 1.0, // Set to 1.0 to show one item per slide
              ),
              items: images.map((image) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                      ),
                      child: Image.asset(
                        image,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 15.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PackageDetail extends StatelessWidget {
  final List<String> images;
  final String title;
  final double initialRating;
  final String packageDetails;

  PackageDetail(
      this.images, this.title, this.initialRating, this.packageDetails);

  @override
  Widget build(BuildContext context) {
    // Function to parse HTML-like tags and apply formatting
    List<TextSpan> parsePackageDetails(String text) {
      final RegExp boldTag = RegExp(r'<b>(.*?)</b>');
      final List<TextSpan> children = [];
      text.splitMapJoin(
        boldTag,
        onMatch: (Match match) {
          children.add(
            TextSpan(
              text: match.group(1),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
          return '';
        },
        onNonMatch: (String text) {
          if (text.isNotEmpty) {
            children.add(TextSpan(text: text));
          }
          return '';
        },
      );
      return children;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  viewportFraction:
                      1.0, // Set to 1.0 to show one item per slide
                ),
                items: images.map((image) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                        ),
                        child: Image.asset(
                          image,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              SizedBox(height: 20),
              Text(
                'RATING',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              RatingBar.builder(
                initialRating: initialRating,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.deepPurple,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
                ignoreGestures: true,
              ),
              SizedBox(height: 20),
              // Display specific package details
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Package Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          children: parsePackageDetails(packageDetails),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
