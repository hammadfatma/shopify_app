import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify_app/providers/profile_provider.dart';
import 'package:shopify_app/screens/edit_profile_screen.dart';
import 'package:shopify_app/widgets/custom_button_icon.dart';

import '../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: SingleChildScrollView(
        child: StreamBuilder(
          stream: Provider.of<ProfileProvider>(context).profileStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Error While Get Data');
            } else if (snapshot.hasData) {
              return FutureBuilder(
                  future: Provider.of<ProfileProvider>(context)
                      .getDataFromProfile(),
                  builder: (context, snapShot) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xffe7eaf0),
                                      offset: Offset(0, 10),
                                      blurRadius: 5,
                                      spreadRadius: 2,
                                    )
                                  ]),
                              child: Center(
                                child: snapShot.data?.imageUrl == ''
                                    ? Icon(Icons.person)
                                    : ClipOval(
                                        child: Image.network(
                                          snapShot.data?.imageUrl ??
                                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNgzWAan9TYETCLgNxYmJuUgpDKZgWT4FF84GJyo12bZde672xL0l-gsSaeA&s',
                                          fit: BoxFit.cover,
                                          width: 100,
                                          height: 100,
                                        ),
                                      ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    FirebaseAuth.instance.currentUser?.email ??
                                        '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Color(0xff515c6f),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProfileScreen()));
                                    },
                                    child: Container(
                                      width: 121,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                              color: Color(0xff727c8e))),
                                      child: Center(
                                        child: Text(
                                          'EDIT PROFILE',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff727c8e),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Name: ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff727c8e),
                                  ),
                                ),
                                Text(
                                  snapShot.data?.name ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Color(0xff515c6f),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Phone: ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff727c8e),
                                  ),
                                ),
                                Text(
                                  snapShot.data?.phone ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Color(0xff515c6f),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        CustomButtonWidget(
                            txt: 'LOG OUT',
                            onTap: () {
                              Provider.of<AuthProviderApp>(context,
                                      listen: false)
                                  .signOut(context);
                            },
                            width: 165),
                      ],
                    );
                  });
            } else {
              return Text('Connection Statue ${snapshot.connectionState}');
            }
          },
        ),
      ),
    );
  }
}
