
import 'package:bai5/dao/address_dao.dart';
import 'package:bai5/dao/user_dao.dart';
import 'package:bai5/models/address.dart';
import 'package:bai5/widgets/show_message.dart';
import 'package:flutter/material.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  UserDao userDao = UserDao();

  int userId = 0;

  bool isAgree = false;

  AddressDao addressDao = AddressDao();


  

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text('Add Address',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          width: double.infinity,
          height: size.height * 0.85,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: double.infinity,
                height: size.height * 0.55,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Name',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'your name',
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                        filled: true, // Kích hoạt nền
                        fillColor: const Color(0xffF5F6FA),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size.width * 0.45,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Country',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                controller: _countryController,
                                decoration: InputDecoration(
                                  hintText: 'your country',
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.circular(10)),
                                  filled: true, // Kích hoạt nền
                                  fillColor: const Color(0xffF5F6FA),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'City',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                controller: _cityController,
                                decoration: InputDecoration(
                                  hintText: 'your city',
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.circular(10)),
                                  filled: true, // Kích hoạt nền
                                  fillColor: const Color(0xffF5F6FA),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Text(
                      'Phone Number',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                    TextField(
                      controller: _phoneNumberController,
                      keyboardType: const TextInputType.numberWithOptions(),
                      decoration: InputDecoration(
                        hintText: 'your phone',
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                        filled: true, // Kích hoạt nền
                        fillColor: const Color(0xffF5F6FA),
                      ),
                    ),
                    const Text(
                      'Address',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        hintText: 'your address ',
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                        filled: true, // Kích hoạt nền
                        fillColor: const Color(0xffF5F6FA),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Save as primary address',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        Switch(
                            value: isAgree,
                            onChanged: (value) {
                              setState(() {
                                isAgree = value;
                              });
                            })
                      ],
                    )
                  ],
                ),
              ),
    
              //code here
              ElevatedButton(
                  onPressed: () async {
                    Address address = Address(
                        id: 0,
                        userId: userId,
                        name: _nameController.text,
                        country: _countryController.text,
                        city: _cityController.text,
                        phoneNumber: _phoneNumberController.text,
                        address: _addressController.text);
    
                    bool isSucess = await addressDao.insertAddress(address);
                    if (isSucess) {
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    } else {
                      // ignore: use_build_context_synchronously
                      showMessage(context, 'Add address not sucessfully');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(size.width * 0.9, 48),
                      backgroundColor: const Color(0xff4A4E69),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6))),
                  child: const Text(
                    'Submit Review',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
