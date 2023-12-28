import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:traveler/presentation/components/components.dart';

class Authentication extends StatelessWidget {
  const Authentication({
    super.key,
    required this.isAuthenticated,
    required this.signOut,
  });

  final bool isAuthenticated;
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: StyledButton(
              onPressed: () {
                !isAuthenticated ? context.push('/sign-in') : signOut();
              },
              child: !isAuthenticated
                  ? const Text('Authenticate')
                  : const Text('Logout')),
        ),
        Visibility(
            visible: isAuthenticated,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: StyledButton(
                  onPressed: () {
                    context.push('/profile');
                  },
                  child: const Text('Profile')),
            ))
      ],
    );
  }
}
