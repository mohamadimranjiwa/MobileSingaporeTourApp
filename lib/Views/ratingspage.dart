import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';

class RatingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ratings and Reviews'),
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
              1,
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
              1,
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
              1,
              context,
            ),
            buildPackage(
              [
                'assets/SINGAPORE_MARINA_BAY.png',
                'assets/SINGAPORE_CHINATOWN.png',
                'assets/SINGAPORE_NIGHT_SAFARI.png'
              ],
              'Classic Package',
              1,
              context,
            ),
            buildPackage(
              [
                'assets/SINGAPORE_GARDENS_BY_THE_BAY.png',
                'assets/SINGAPORE_CHINATOWN.png'
              ],
              'Standard Package',
              1,
              context,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPackage(List<String> images, String title, double initialRating,
      BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailPage(images, title)),
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

class DetailPage extends StatefulWidget {
  final List<String> images;
  final String title;

  DetailPage(this.images, this.title);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final List<Map<String, dynamic>> comments = [];
  final TextEditingController _reviewController = TextEditingController();
  double _currentRating = 3.0;

  void _addReview(String comment, double rating) {
    setState(() {
      comments.add({'comment': comment, 'rating': rating});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                items: widget.images.map((image) {
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
                widget.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              Container(
                height: 300, // Set the desired height
                padding: EdgeInsets.all(10.0), // Adjust padding as needed
                color: Colors.grey[200], // Adjust background color as needed
                child: SingleChildScrollView(
                  child: Column(
                    children: comments.map((comment) {
                      return _buildComment(
                          comment['comment'], comment['rating']);
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Rate this package:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              RatingBar(
                initialRating: _currentRating,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                ratingWidget: RatingWidget(
                  full: Icon(Icons.star),
                  half: Icon(Icons.star_half),
                  empty: Icon(Icons.star_border),
                ),
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                onRatingUpdate: (rating) {
                  setState(() {
                    _currentRating = rating;
                  });
                },
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromARGB(207, 112, 112, 112),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _reviewController,
                      decoration: InputDecoration(
                        labelText: 'Enter your review',
                        border: InputBorder.none,
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (_reviewController.text.isNotEmpty) {
                          _addReview(_reviewController.text, _currentRating);
                          _reviewController.clear();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                      child: Text(
                        'Submit Review',
                        style: TextStyle(
                            color: Colors
                                .black), // Change text color to black here
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

  Widget _buildComment(String comment, double rating) {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: RatingBarIndicator(
          rating: rating,
          itemBuilder: (context, index) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          itemCount: 5,
          itemSize: 20.0,
          direction: Axis.horizontal,
        ),
        title: Text(comment),
      ),
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RatingsPage(),
  ));
}
