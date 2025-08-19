import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _selectedGender = 'Male';

  final List<String> _sportsList = [
    "Football",
    "Cricket",
    "Hockey",
    "Basketball",
    "Tennis",
    "Badminton",
    "Volleyball",
    "Running",
    "Swimming",
  ];
  final List<String> _selectedSports = [];

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    aboutController.dispose();
    super.dispose();
  }
  
  Future signUp() async {
    if(passwordConfirmed()) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text.trim(),
          password: passwordController.text.trim(),
      );
      adduserDetails(
          firstNameController.text.trim(),
          lastNameController.text.trim(),
          emailController.text.trim(),
          int.parse(phoneController.text.trim()),
          int.parse(heightController.text.trim()),
          int.parse(weightController.text.trim()),
          int.parse(ageController.text.trim()),
          addressController.text.trim(),
      );
    }
  }
  
  Future adduserDetails(
      String firstName,String lastName,int age,int height,int weight,String address,int phoneNumber,String email) async{
    await FirebaseFirestore.instance.collection('user').add({
      'first name':firstName,
      'last name': lastName,
      'age':age,
      'height':height,
      'weight':weight,
      'address':address,
      'phone number':phoneNumber,
      'email':email,


    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create a New Account',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade400,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.green.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            shadowColor: Colors.blueAccent.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    /// First & Last Name
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: "First Name",
                            icon: Icons.person_outline,
                            controller: firstNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter first name';
                              } else if (value.length < 3) {
                                return 'Min 3 characters';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTextField(
                            label: "Last Name",
                            icon: Icons.person_outline,
                            controller: lastNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter last name';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    /// Email
                    _buildTextField(
                      label: "Email",
                      icon: Icons.email_outlined,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        return value == null || !emailRegex.hasMatch(value)
                            ? 'Enter a valid email'
                            : null;
                      },
                    ),
                    const SizedBox(height: 15),

                    /// Phone
                    _buildTextField(
                      label: "Phone Number",
                      icon: Icons.phone_android_outlined,
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        final phoneRegex = RegExp(r'^\d{10}$');
                        return value == null || !phoneRegex.hasMatch(value)
                            ? 'Enter valid 10-digit number'
                            : null;
                      },
                    ),
                    const SizedBox(height: 15),

                    /// Gender + Age Row
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedGender,
                            items: ['Male', 'Female', 'Other']
                                .map((gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            ))
                                .toList(),
                            onChanged: (value) =>
                                setState(() => _selectedGender = value),
                            decoration: _inputDecoration("Gender", Icons.person),
                            validator: (value) =>
                            value == null ? 'Select gender' : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTextField(
                            label: "Age",
                            icon: Icons.calendar_today,
                            controller: ageController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter age';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    /// Height + Weight Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: "Height (cm)",
                            icon: Icons.height,
                            controller: heightController,
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                            value == null || value.isEmpty ? 'Enter height' : null,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTextField(
                            label: "Weight (kg)",
                            icon: Icons.monitor_weight,
                            controller: weightController,
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                            value == null || value.isEmpty ? 'Enter weight' : null,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    /// Address
                    TextFormField(
                      controller: addressController,
                      decoration: _inputDecoration("Address", Icons.location_on_outlined),
                      maxLines: 3,
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Enter address' : null,
                    ),
                    const SizedBox(height: 15),

                    /// About Yourself
                    TextFormField(
                      controller: aboutController,
                      decoration: _inputDecoration("Tell about yourself", Icons.info_outline),
                      maxLines: 4,
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Enter details' : null,
                    ),
                    const SizedBox(height: 15),

                    /// Sports Interest Chips
                    const Text(
                      "Sports Interests",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _sportsList.map((sport) {
                        final isSelected = _selectedSports.contains(sport);
                        return FilterChip(
                          label: Text(sport),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedSports.add(sport);
                              } else {
                                _selectedSports.remove(sport);
                              }
                            });
                          },
                          selectedColor: Colors.blue.shade200,
                          checkmarkColor: Colors.white,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    /// Password
                    TextFormField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: _inputDecoration("Password", Icons.lock_outline).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () =>
                              setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: (value) {
                        final regex = RegExp(
                            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%^&*()_+{}|:<>?~]).{8,}$');
                        return value == null || !regex.hasMatch(value)
                            ? 'Password must be 8+ chars, include caps, number & special char'
                            : null;
                      },
                    ),
                    const SizedBox(height: 15),

                    /// Confirm Password
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: _inputDecoration("Confirm Password", Icons.lock_outline)
                          .copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () => setState(() =>
                          _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm password';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),

                    /// Sign Up Button
                    ElevatedButton.icon(
                      icon: const Icon(Icons.person_add_alt_1, size: 22),
                      label: const Text(
                        'Sign Up',
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          print("First Name: ${firstNameController.text}");
                          print("Last Name: ${lastNameController.text}");
                          print("Email: ${emailController.text}");
                          print("Phone: ${phoneController.text}");
                          print("Gender: $_selectedGender");
                          print("Age: ${ageController.text}");
                          print("Height: ${heightController.text}");
                          print("Weight: ${weightController.text}");
                          print("Address: ${addressController.text}");
                          print("About: ${aboutController.text}");
                          print("Sports Interests: $_selectedSports");
                          print("Password: ${passwordController.text}");

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Sign Up Successful')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 6,
                      ),
                    ),
                    const SizedBox(height: 15),

                    /// Already have account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? ",
                            style: TextStyle(fontSize: 15)),
                        TextButton(
                          onPressed: () {
                            // Navigate to Login Page
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blue[700]),
      filled: true,
      fillColor: Colors.grey[200],
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade400),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    TextEditingController? controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label, icon),
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
    );
  }
}
