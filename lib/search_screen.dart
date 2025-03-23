import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async'; // For debounce

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<Map<String, dynamic>> _searchResults = [];
  String? _errorMessage;
  Timer? _debounce;
  bool _isLoading = false; // Add loading state

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchProducts();
    });
  }

  Future<void> _searchProducts() async {
    String query = _searchController.text.trim();
    print('Searching for: $query');

    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _errorMessage = null;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
      _errorMessage = null;
      _searchResults = [];
    });

    try {
      final response = await http.get(
        Uri.parse(
            'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$query&search_simple=1&json=1'),
      );
      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _errorMessage = null;
          _searchResults = [];

          if (data['products'] != null && data['products'].isNotEmpty) {
            for (var product in data['products']) {
              if (product['product_name'] != null && product['product_name'].isNotEmpty) {
                String foodName = product['product_name'];
                double? sugarContent = double.tryParse(
                    product['nutriments']?['sugars_100g']?.toString() ?? '0');
                // Try to get additional info, like energy (calories)
                double? energy = double.tryParse(
                    product['nutriments']?['energy-kcal_100g']?.toString() ?? '0');

                _searchResults.add({
                  'food': foodName,
                  'sugar': sugarContent ?? 0.0,
                  'energy': energy ?? 0.0, // Add energy for more info
                });
              }
            }
            if (_searchResults.isEmpty) {
              _errorMessage = 'No valid products found for "$query".';
            }
          } else {
            _errorMessage = 'No products found for "$query".';
          }
        });
      } else if (response.statusCode == 429) {
        setState(() {
          _errorMessage = 'Too many requests. Please try again later.';
          _searchResults = [];
        });
      } else {
        setState(() {
          _errorMessage = 'Error fetching data: ${response.statusCode}';
          _searchResults = [];
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error: Unable to connect. Please check your internet and try again.';
        _searchResults = [];
      });
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  void _retrySearch() {
    setState(() {
      _errorMessage = null;
      _searchResults = [];
    });
    _searchProducts();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            hintText: "Enter product name", // Updated to match wireframe
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            prefixIcon: const Icon(Icons.search),
          ),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          onTap: () {
            FocusScope.of(context).requestFocus(_searchFocusNode);
          },
          onSubmitted: (value) {
            _searchFocusNode.unfocus();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _errorMessage!,
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        if (_errorMessage!.contains('Network error') ||
                            _errorMessage!.contains('Too many requests'))
                          ElevatedButton(
                            onPressed: _retrySearch,
                            child: const Text('Retry'),
                          ),
                      ],
                    ),
                  )
                : _searchResults.isEmpty
                    ? const Center(
                        child: Text(
                          "Search for a product to see results.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final result = _searchResults[index];
                          return Card(
                            elevation: 2, // Slight elevation for better visuals
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              title: Text(
                                result['food'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                'Sugar: ${result['sugar'].toStringAsFixed(1)}g/100g\nCalories: ${result['energy'].toStringAsFixed(0)} kcal/100g',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              trailing: Text(
                                "${result['sugar'].toStringAsFixed(1)}g",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
