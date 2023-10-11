import 'package:flutter/material.dart';
import 'package:traveler/screens/wrap.dart';

class ProfileScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final List<String> trips;
  final List<String> addedLocations;
  final String about;

  const ProfileScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.trips,
    required this.addedLocations,
    required this.about,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WrapScaffold(
      label: 'Profile',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            _buildRow([
              _buildCard(
                title: 'First Name',
                content: widget.firstName,
              ),
              _buildCard(
                title: 'Last Name',
                content: widget.lastName,
              ),
              _buildCard(
                title: 'Email',
                content: widget.email,
              ),
            ]),
            const SizedBox(height: 20.0),
            _buildRow([
              _buildCard(
                title: 'Trips',
                items: widget.trips,
              ),
              _buildCard(
                  title: 'Added Locations', items: widget.addedLocations),
            ]),
            const SizedBox(height: 20.0),
            _buildRow([
              _buildCard(
                title: 'About',
                content: widget.about,
              ),
            ]),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRow(List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: children,
    );
  }

  Widget _buildCard({
    required String title,
    List<String>? items,
    String? content,
  }) {
    return Expanded(
      child: Card(
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (items != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: items
                      .map(
                        (item) => Text(
                          item,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      )
                      .toList(),
                ),
              if (content != null)
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
