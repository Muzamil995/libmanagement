import 'package:flutter/material.dart';

import '../models/usermodel.dart';
import '../services/user_service.dart';



class UpdateProfileView extends StatefulWidget {
  final UserModel user;

  const UpdateProfileView({super.key, required this.user});

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  final _formKey = GlobalKey<FormState>();
  late String name, email, phone, address;

  @override
  void initState() {
    super.initState();
    name = widget.user.name;
    email = widget.user.email;
    phone = widget.user.phone;
    address = widget.user.address;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: "Name"),
                onChanged: (value) => name = value,
              ),
              TextFormField(
                initialValue: email,
                decoration: const InputDecoration(labelText: "Email"),
                onChanged: (value) => email = value,
              ),
              TextFormField(
                initialValue: phone,
                decoration: const InputDecoration(labelText: "Phone"),
                onChanged: (value) => phone = value,
              ),
              TextFormField(
                initialValue: address,
                decoration: const InputDecoration(labelText: "Address"),
                onChanged: (value) => address = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await UserServices().updateUser(
                    UserModel(
                      id: widget.user.id,
                      name: name,
                      email: email,
                      phone: phone,
                      address: address,
                      imageUrl: widget.user.imageUrl,
                    ),
                    null, // Pass image file if needed
                  );
                  Navigator.pop(context);
                },
                child: const Text("Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
