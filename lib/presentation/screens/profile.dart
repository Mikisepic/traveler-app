import 'package:flutter/material.dart';
import 'package:traveler/presentation/widgets/widgets.dart';

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
              buildCard(
                context: context,
                title: 'First Name',
                content: widget.firstName,
              ),
              buildCard(
                context: context,
                title: 'Last Name',
                content: widget.lastName,
              ),
              buildCard(
                context: context,
                title: 'Email',
                content: widget.email,
              ),
            ]),
            const SizedBox(height: 20.0),
            _buildRow([
              buildCard(
                context: context,
                title: 'Trips',
                items: widget.trips,
              ),
              buildCard(
                  context: context,
                  title: 'Added Locations',
                  items: widget.addedLocations),
            ]),
            const SizedBox(height: 20.0),
            _buildRow([
              buildCard(
                context: context,
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
}