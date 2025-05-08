import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:studyhive/models/user/user_model.dart';
import 'package:studyhive/providers/auth_provider.dart';
import 'package:studyhive/screens/login_page.dart';
import 'package:studyhive/services/auth_service.dart';
import 'package:studyhive/utils/constants.dart';
import 'package:studyhive/utils/exceptions.dart';
import 'package:studyhive/widgets/error_dialog.dart';
import 'package:studyhive/widgets/loading_indicator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  UserModel? _user;
  bool _isLoading = true;
  bool _isEditingProfile = false;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }
  
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }
  
  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // First check if user data is already available in AuthProvider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      UserModel? user = authProvider.user;
      
      // If not available or if loading, fetch from API
      if (user == null) {
        user = await _authService.getUserProfile();
        // Update the auth provider
        authProvider.setUser(user);
      }
      
      setState(() {
        _user = user;
        _firstNameController.text = user!.firstName;
        _lastNameController.text = user.lastName;
        _bioController.text = user.bio ?? '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => ErrorDialog(
            title: 'Error Loading Profile',
            message: e is ApiException ? e.message : e.toString(),
          ),
        );
      }
    }
  }
  
  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final updatedUser = await _authService.updateUserProfile(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        bio: _bioController.text.trim(),
      );
      
      setState(() {
        _user = updatedUser;
        _isEditingProfile = false;
        _isLoading = false;
      });
      
      // Update the AuthProvider with the new user data
      if (mounted) {
        context.read<AuthProvider>().setUser(updatedUser);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: AppConstants.successColor,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => ErrorDialog(
            title: 'Error Updating Profile',
            message: e is ApiException ? e.message : e.toString(),
          ),
        );
      }
    }
  }
  
  Future<void> _pickAndUploadImage() async {
    try {
      // Try-catch around the ImagePicker initialization and usage
      XFile? image;
      try {
        final ImagePicker picker = ImagePicker();
        image = await picker.pickImage(source: ImageSource.gallery);
      } catch (e) {
        // Show error to user with detailed message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error picking image: ${e.toString()}'),
              backgroundColor: AppConstants.errorColor,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'RETRY',
                onPressed: () => _pickAndUploadImage(),
                textColor: Colors.white,
              ),
            ),
          );
        }
        return;
      }
      
      if (image == null) return;
      
      setState(() {
        _isLoading = true;
      });
      
      final imageBytes = await image.readAsBytes();
      final fileName = image.name;
      
      final updatedUser = await _authService.uploadAvatar(imageBytes, fileName);
      
      setState(() {
        _user = updatedUser;
        _isLoading = false;
      });
      
      // Update the AuthProvider with the new user data
      if (mounted) {
        context.read<AuthProvider>().setUser(updatedUser);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Avatar updated successfully'),
            backgroundColor: AppConstants.successColor,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => ErrorDialog(
            title: 'Error Uploading Avatar',
            message: e is ApiException 
                ? e.message 
                : 'Error: ${e.toString()}\n\nTry restarting the app.',
          ),
        );
      }
    }
  }
  
  Future<void> _signOut() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      await _authService.logout();
      
      if (mounted) {
        // Using context.read to avoid the "use Provider.of with listen: false" warning
        context.read<AuthProvider>().setAuthenticated(false);
        
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => ErrorDialog(
            title: 'Error Signing Out',
            message: e is ApiException ? e.message : e.toString(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive calculations
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF59D), // Light yellow at top
              Color(0xFFFFB74D), // Orange at bottom
            ],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(child: LoadingIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button and profile header
                    Padding(
                      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.black),
                            onPressed: () => Navigator.pop(context),
                          ),
                          SizedBox(width: isSmallScreen ? 12 : 16),
                          // Profile image with upload capability
                          GestureDetector(
                            onTap: _pickAndUploadImage,
                            child: Stack(
                              children: [
                                Container(
                                  width: isSmallScreen ? 60 : 70,
                                  height: isSmallScreen ? 60 : 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[300],
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    image: _user?.avatar != null
                                        ? DecorationImage(
                                            image: NetworkImage(_user!.avatar!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: _user?.avatar == null
                                      ? Icon(
                                          Icons.person,
                                          color: Colors.grey[700],
                                          size: isSmallScreen ? 30 : 35,
                                        )
                                      : null,
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.black,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: isSmallScreen ? 12 : 16),
                          // Name and email
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _user?.fullName ?? 'User',
                                  style: GoogleFonts.poppins(
                                    fontSize: isSmallScreen ? 16 : 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  _user?.email ?? 'user@example.com',
                                  style: GoogleFonts.poppins(
                                    fontSize: isSmallScreen ? 12 : 14,
                                    color: Colors.black54,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // Edit profile button
                          IconButton(
                            icon: Icon(
                              _isEditingProfile ? Icons.close : Icons.edit,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _isEditingProfile = !_isEditingProfile;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const Divider(color: Colors.black26),

                    // Bio section
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 20.0 : 24.0,
                        vertical: isSmallScreen ? 8.0 : 12.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bio',
                            style: GoogleFonts.poppins(
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _isEditingProfile
                              ? TextField(
                                  controller: _bioController,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    hintText: 'Tell us about yourself',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                )
                              : Text(
                                  _user?.bio ?? 'No bio yet',
                                  style: GoogleFonts.poppins(
                                    fontSize: isSmallScreen ? 13 : 15,
                                    color: Colors.black87,
                                  ),
                                ),
                        ],
                      ),
                    ),

                    // Edit profile form
                    if (_isEditingProfile) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 20.0 : 24.0,
                          vertical: isSmallScreen ? 8.0 : 12.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Personal Information',
                              style: GoogleFonts.poppins(
                                fontSize: isSmallScreen ? 14 : 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _firstNameController,
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _lastNameController,
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _updateProfile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Save Changes',
                                  style: GoogleFonts.poppins(
                                    fontSize: isSmallScreen ? 14 : 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      // Menu items when not editing
                      _buildMenuItem(
                        context: context,
                        icon: Icons.person_outline,
                        title: "Personal Information",
                        subtitle: "Manage your personal details",
                        onTap: () {
                          setState(() {
                            _isEditingProfile = true;
                          });
                        },
                      ),

                      _buildMenuItem(
                        context: context,
                        icon: Icons.settings_outlined,
                        title: "Account Settings",
                        subtitle: "Preferences and security",
                        onTap: () {
                          // TODO: Navigate to account settings page
                        },
                      ),
                    ],

                    // Spacer to push sign out button to bottom
                    const Spacer(),

                    // Sign out button
                    Padding(
                      padding: EdgeInsets.all(isSmallScreen ? 20.0 : 24.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: isSmallScreen ? 45 : 50,
                        child: ElevatedButton(
                          onPressed: _signOut,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Sign out",
                            style: GoogleFonts.poppins(
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    // Get screen size for responsive calculations
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 20.0 : 24.0,
            vertical: isSmallScreen ? 12.0 : 16.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.black87, size: isSmallScreen ? 20 : 24),
            SizedBox(width: isSmallScreen ? 12 : 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: isSmallScreen ? 14 : 16,
                      color: Colors.black87,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: isSmallScreen ? 12 : 13,
                        color: Colors.black54,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black54,
              size: isSmallScreen ? 14 : 16,
            ),
          ],
        ),
      ),
    );
  }
}
