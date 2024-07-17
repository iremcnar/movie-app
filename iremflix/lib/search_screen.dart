import 'package:flutter/material.dart';
import 'package:iremflix/api/api.dart';
import 'package:iremflix/constants.dart';
import 'package:iremflix/models/movie.dart';
import 'package:iremflix/screens/detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  Api api = Api();
  List<Movie> searchedMovies = [];
  List<Movie> featuredMovies = [];
  bool showFeaturedMovies = true;

  @override
  void initState() {
    super.initState();
    search('');
  }

  void search(String query) {
    api.getSearchMovies(query).then((results) {
      setState(() {
        searchedMovies = results.where((movie) => movie.title.toLowerCase().contains(query.toLowerCase())).toList();
        showFeaturedMovies = query.isEmpty;
      });
    }).catchError((error) {
      print('Error: $error');
    });

    if (query.isEmpty) {
      api.getTrendingMovies().then((results) {
        setState(() {
          featuredMovies = results;
        });
      }).catchError((error) {
        print('Error: $error');
      });
    } else {
      featuredMovies.clear();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      searchController.clear();
                      search('');
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.grey,
                    ),
                  ),
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  search(value);
                },
              ),
            ),
            SizedBox(height: 20),
            if (showFeaturedMovies && featuredMovies.isNotEmpty) ...[
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Featured Movies",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
            Center(
              child: Column(
                children: searchedMovies.map((movie) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsScreen(movie: movie),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.transparent,
                      child: ListTile(
                        leading: Image.network(
                          '${Constants.imagePath}${movie.posterPath}',
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          movie.title,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      elevation: 0,
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: featuredMovies.map((movie) {
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsScreen(movie: movie),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              '${Constants.imagePath}${movie.posterPath}',
                              height: 200,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              movie.title,
                              style: TextStyle(color: Colors.white, fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
