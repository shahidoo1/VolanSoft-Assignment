import 'package:flutter/material.dart';
import 'package:flutter_application/view/user_detail_screen.dart';
import 'package:flutter_application/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  bool hasSearched = false; // Flag to track if a search has been made

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<UserViewModel>(context, listen: false);
    viewModel.fetchData();
  }

  void _applyFilters() {
    final viewModel = Provider.of<UserViewModel>(context, listen: false);
    setState(() {
      hasSearched = true;
    });
    viewModel.applyFilters(
      nameQuery: nameController.text,
      zipQuery: zipController.text,
    );
  }

  void _clearNameField() {
    nameController.clear();
    _applyFilters();
  }

  void _clearZipField() {
    zipController.clear();
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 112, 191, 254),
        title: const Text('HomeScreen'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: nameController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearNameField,
                      )
                    : null,
                labelText: 'Search by Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onChanged: (query) {
                _applyFilters();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: zipController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_on),
                suffixIcon: zipController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearZipField,
                      )
                    : null,
                labelText: 'Search by ZIP Code',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onChanged: (query) {
                _applyFilters();
              },
            ),
          ),
          Expanded(
              child: viewModel.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    )
                  : viewModel.isInternetAvailable
                      ? (hasSearched && viewModel.users.isEmpty
                          ? Center(
                              child: Text(
                                'No matches found',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey[600]),
                              ),
                            )
                          : ListView.builder(
                              itemCount: viewModel.users.length,
                              itemBuilder: (context, index) {
                                final user = viewModel.users[index];
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      child: Text(
                                        user.name[0],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                    title: Text(user.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Email: ${user.email}'),
                                        Text(
                                            'ZIP Code: ${user.address.zipcode}'),
                                      ],
                                    ),
                                    trailing: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        'View',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailScreen(user: user),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ))
                      : Center(
                          child: Text(
                            'No internet connection. Please check your connection and try again.',
                            style:
                                TextStyle(fontSize: 18, color: Colors.red[600]),
                            textAlign: TextAlign
                                .center, // Ensure text is centered horizontally
                          ),
                        )),
        ],
      ),
    );
  }
}
