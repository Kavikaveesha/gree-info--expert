import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Privacy Policy\n\n'
          'Effective Date: [03.04.2024]\n\n'
          'Welcome to this app, the mobile application that [brief description of what the app does]. This Privacy Policy is designed to inform you about the personal information we collect, how we use it, and your rights regarding your data.\n\n'
          'Information Collection We collect information that you provide directly to us, such as when you create an account or contact customer support. Additionally, we may collect certain information automatically, including, but not limited to, your device ID, device type, and usage data.\n\n'
          'Use of Information The information we collect is used to provide, maintain, and improve our services, to develop new services, and to protect our app and our users. We may also use the information to communicate with you, such as to send you app updates and security alerts.\n\n'
          'Sharing of Information We do not share your personal information with companies, organizations, or individuals outside of our app except in the following cases:\n'
          'Contact Us If you have any questions about this Privacy Policy, please contact us at Contact.\n\n'
          'Please remember to replace the placeholders with our app’s specific details and consult with a legal professional to ensure compliance with all applicable laws and regulations. For more detailed templates and guidance, you can refer to resources like Termly and FreePrivacyPolicy.',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
