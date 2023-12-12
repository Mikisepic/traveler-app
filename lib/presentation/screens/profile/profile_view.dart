import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveler/presentation/components/components.dart';
import 'package:traveler/providers/providers.dart';

import 'profile_authentication.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({
    super.key,
  });

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  @override
  Widget build(BuildContext context) {
    return WrapScaffold(
      label: 'Profile',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Consumer<UserProvider>(builder: (context, provider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Consumer<AuthenticationProvider>(
                builder: (context, appState, _) => Authentication(
                    isAuthenticated: appState.isAuthenticated,
                    signOut: () {
                      FirebaseAuth.instance.signOut();
                    }),
              ),
              _buildRow([
                buildCard(
                  context: context,
                  title: 'First Name',
                  content: provider.user.firstName,
                ),
                buildCard(
                  context: context,
                  title: 'Last Name',
                  content: provider.user.lastName,
                ),
              ]),
              _buildRow([
                buildCard(
                  context: context,
                  title: 'Trips',
                  items: provider.user.trips.map((e) => e.title).toList(),
                ),
                buildCard(
                    context: context,
                    title: 'Markers',
                    items: provider.user.markers.map((e) => e.title).toList()),
              ]),
              _buildRow([
                buildCard(
                  context: context,
                  title: 'Email',
                  content: provider.user.email,
                ),
                buildCard(
                  context: context,
                  title: 'About',
                  content: provider.user.about,
                ),
              ]),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildRow(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
