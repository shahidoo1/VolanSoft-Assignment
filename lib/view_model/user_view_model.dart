import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserViewModel extends ChangeNotifier {
  List<User> _users = [];
  List<User> _filteredUsers = [];
  bool _isInternetAvailable = true;
  bool _isLoading = false;
  String _errorMessage = '';
  late Connectivity _connectivity;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  List<User> get users => _filteredUsers;
  bool get isInternetAvailable => _isInternetAvailable;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  UserViewModel() {
    _connectivity = Connectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    // Perform an initial connectivity check
    _initialize();
  }

  Future<void> _initialize() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    _isInternetAvailable = connectivityResult != ConnectivityResult.none;

    if (_isInternetAvailable) {
      await fetchData();
    } else {
      _errorMessage = 'No internet connection available';
      notifyListeners();
    }
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    _isInternetAvailable =
        results.any((result) => result != ConnectivityResult.none);

    if (_isInternetAvailable && _users.isEmpty) {
      _errorMessage = ''; // Clear the error message when internet is available
      await fetchData(); // Fetch data when internet becomes available
    } else if (!_isInternetAvailable) {
      _errorMessage = 'No internet connection available';
    }
    notifyListeners();
  }

  Future<void> fetchData() async {
    _isLoading = true;
    _errorMessage = ''; // Clear any previous error message
    notifyListeners();

    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _users = data.map((item) => User.fromJson(item)).toList();
        _filteredUsers = _users;
      } else {
        _errorMessage = 'Failed to load data';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void applyFilters({String? nameQuery, String? zipQuery}) {
    _filteredUsers = _users;

    if (nameQuery != null && nameQuery.isNotEmpty) {
      nameQuery = nameQuery.trim().replaceAll(RegExp(r'\s+'), ' ');
      _filteredUsers = _filteredUsers
          .where((user) =>
              user.name.toLowerCase().contains(nameQuery!.toLowerCase()))
          .toList();
    }

    if (zipQuery != null && zipQuery.isNotEmpty) {
      zipQuery = zipQuery.trim().replaceAll(RegExp(r'\s+'), ' ');
      _filteredUsers = _filteredUsers
          .where((user) => user.address.zipcode.contains(zipQuery!))
          .toList();
    }

    notifyListeners();
  }

  void clearFilters() {
    _filteredUsers = _users;
    notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
