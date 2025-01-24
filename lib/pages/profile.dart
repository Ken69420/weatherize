import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // For handling file paths
import '../models/profile_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Dummy data - replace this with your database fetch later
  final UserProfile _originalProfile = UserProfile(
    email: "john.doe@example.com",
    name: "John Doe",
    bio: "Flutter developer passionate about creating beautiful apps",
    location: "New York, USA",
    phoneNumber: "+1 234 567 8900",
    joinDate: "January 2024",
  );

  late UserProfile _currentProfile;
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _locationController;
  late TextEditingController _phoneController;

  File? _profileImage; // To store the selected image file

  @override
  void initState() {
    super.initState();
    _currentProfile = _originalProfile;
    _nameController = TextEditingController(text: _currentProfile.name);
    _bioController = TextEditingController(text: _currentProfile.bio);
    _locationController = TextEditingController(text: _currentProfile.location);
    _phoneController = TextEditingController(text: _currentProfile.phoneNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    setState(() {
      _currentProfile = UserProfile(
        email: _currentProfile.email,
        name: _nameController.text,
        bio: _bioController.text,
        location: _locationController.text,
        phoneNumber: _phoneController.text,
        joinDate: _currentProfile.joinDate,
      );
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  void _cancelChanges() {
    setState(() {
      _nameController.text = _originalProfile.name;
      _bioController.text = _originalProfile.bio;
      _locationController.text = _originalProfile.location;
      _phoneController.text = _originalProfile.phoneNumber;
      _profileImage = null; // Reset the profile image
      _isEditing = false;
    });
  }

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path); // Save the selected image file
      });
    }
  }

  Widget _buildProfileField(String label, String value,
      {bool isEditable = true, TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 4),
          _isEditing && isEditable
              ? TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Enter $label',
                    hintStyle: const TextStyle(color: Colors.white54),
                  ),
                )
              : Text(
                  value,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade800, Colors.purple.shade800],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!) as ImageProvider
                          : NetworkImage('https://via.placeholder.com/100'),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 20,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt,
                                size: 20, color: Colors.white),
                            onPressed: _pickImage,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildProfileField('Email', _currentProfile.email,
                  isEditable: false),
              _buildProfileField('Name', _currentProfile.name,
                  controller: _nameController),
              _buildProfileField('Bio', _currentProfile.bio,
                  controller: _bioController),
              _buildProfileField('Location', _currentProfile.location,
                  controller: _locationController),
              _buildProfileField('Phone Number', _currentProfile.phoneNumber,
                  controller: _phoneController),
              _buildProfileField('Join Date', _currentProfile.joinDate,
                  isEditable: false),
              if (_isEditing)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                      ),
                      child: const Text('Save',
                          style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: _cancelChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                      ),
                      child: const Text('Cancel',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
