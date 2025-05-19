import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/size.dart';
import 'package:my_portfolio/constants/sns_links.dart';

import '../constants/colors.dart';
import 'custom_text_field.dart';
import 'dart:js' as js;

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {

final TextEditingController nameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController messageController = TextEditingController();

bool isValidEmail(String email) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}


@override
void dispose() {
  nameController.dispose();
  emailController.dispose();
  messageController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 60),
      color: CustomColor.bgLight1,
      child: Column(
        children: [
          // title
          const Text(
            "Get in touch",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: CustomColor.whitePrimary,
            ),
          ),

          const SizedBox(height: 50),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 700,
              maxHeight: 100,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= kMinDesktopWidth) {
                  return buildNameEmailFieldDesktop();
                }

                // else
                return buildNameEmailFieldMobile();
              },
            ),
          ),
          const SizedBox(height: 15),
          // message
          ConstrainedBox(
  constraints: const BoxConstraints(
    maxWidth: 700,
  ),
  child: CustomTextField(
    hintText: "Your message",
    maxLines: 16,
    controller: messageController,
  ),
),

          const SizedBox(height: 20),
          // send button
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 700,
            ),
            child: SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
      onPressed: () async {
  String name = nameController.text.trim();
  String email = emailController.text.trim();
  String message = messageController.text.trim();

  if (name.isEmpty || email.isEmpty || message.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill all fields")),
    );
  } else if (!isValidEmail(email)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please enter a valid email address")),
    );
  } else {
    await FirebaseFirestore.instance.collection('messages').add({
      'name': name,
      'email': email,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Message sent!")),
    );

    nameController.clear();
    emailController.clear();
    messageController.clear();
  }
},



                child: const Text("Get in touch"),
              ),
            ),
          ),
          const SizedBox(height: 30),

          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 300,
            ),
            child: const Divider(),
          ),
          const SizedBox(height: 15),

          // SNS icon button links
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  js.context.callMethod('open', [SnsLinks.github]);
                },
                child: Image.asset(
                  "assets/github.png",
                  width: 28,
                ),
              ),
              InkWell(
                onTap: () {
                  js.context.callMethod('open', [SnsLinks.linkedIn]);
                },
                child: Image.asset(
                  "assets/linkedin.png",
                  width: 28,
                ),
              ),
              
            ],
          )
        ],
      ),
    );
  }

  Row buildNameEmailFieldDesktop() {
  return Row(
    children: [
      // name
      Flexible(
        child: CustomTextField(
          hintText: "Your name",
          controller: nameController,
        ),
      ),
      const SizedBox(width: 15),
      // email
      Flexible(
        child: CustomTextField(
          hintText: "Your email",
          controller: emailController,
        ),
      ),
    ],
  );
}


 Column buildNameEmailFieldMobile() {
  return Column(
    children: [
      Flexible(
        child: CustomTextField(
          hintText: "Your name",
          controller: nameController,
        ),
      ),
      const SizedBox(height: 15),
      Flexible(
        child: CustomTextField(
          hintText: "Your email",
          controller: emailController,
        ),
      ),
    ],
  );
}

}