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
        child: Consumer<AuthenticationProvider>(
            builder: (context, provider, child) {
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
                  title: 'Display Name',
                  content: provider.userMetadata?.displayName ?? 'No Data',
                ),
                buildCard(
                  context: context,
                  title: 'Email',
                  content: provider.userMetadata?.email ?? 'No Data',
                ),
              ]),
              _buildRow([
                buildCard(
                  context: context,
                  title: 'Trips',
                  items: provider.userMetadata?.trips
                          .map((e) => e.title)
                          .toList() ??
                      ['No Data'],
                ),
                buildCard(
                    context: context,
                    title: 'Markers',
                    items: provider.userMetadata?.markers
                            .map((e) => e.title)
                            .toList() ??
                        ['No Data']),
              ]),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildRow(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
