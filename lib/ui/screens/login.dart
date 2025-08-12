import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resep/ui/screens/home.dart';

class login extends StatelessWidget {
  const login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF6F6F6), Color(0xFFACDDB5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'L’Atelier du Chef \n',
                          style: GoogleFonts.ubuntu(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF02480F),
                          ),
                        ),
                        TextSpan(
                          text: '  BENGKEL SI KOKI',
                          style: GoogleFonts.ubuntu(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF02480F),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ),

                  Text(
                    'Sudah siap memperkaya koleksi masakan\n'
                    ' di rumah? \n'
                    'Ayo, lihat semua resep yang kami sajikan \n '
                    'dan temukan ide-ide baru untuk setiap \n'
                    'waktu makanmu!',
                    style: GoogleFonts.ubuntu(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF02480F),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Center(
                    child: Image.asset(
                      'logo.png',
                      width: 300,
                      height: 293,
                      fit: BoxFit.contain,
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (BuildContext context, StateSetter setState) {
                                  return Wrap(
                                    children: [
                                      Container(
                                        height: 400,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFB6EDC0),
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(30),
                                            topLeft: Radius.circular(30),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            SizedBox(height: 30),
                                            Text(
                                              'Login',
                                              style: GoogleFonts.ubuntu(
                                                fontSize: 48,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF584A4A),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            SizedBox(
                                              width: 400,
                                              height: 60,
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  hintText: "ricko11@gmail.com",
                                                  hintStyle: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                  labelText: "Username/email",
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              20,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: Colors.white,
                                                          width: 3.0,
                                                        ),
                                                      ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              20,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: Colors.white,
                                                          width: 3.0,
                                                        ),
                                                      ),
                                                ),
                                              ),
                                            ),

                                            SizedBox(height: 20),

                                            SizedBox(
                                              width: 400,
                                              height: 60,
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  labelStyle:
                                                      GoogleFonts.poppins(
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              20,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: Colors.white,
                                                          width: 3.0,
                                                        ),
                                                      ),
                                                  hintText: "12345678",
                                                  hintStyle: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                  labelText: "password",
                                                  suffixIcon: InkWell(
                                                    onTap: () {},
                                                    child: Icon(
                                                      Icons.visibility_outlined,
                                                      color: Colors.white,
                                                      size: 26,
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              20,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: Colors.white,
                                                          width: 3.0,
                                                        ),
                                                      ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                       HomeScreen(),
                                                ),
                                              );
                                              },
                                              child: Container(
                                                width: 400,
                                                height: 60,
                                                alignment: Alignment.center,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(20),
                                                      ),
                                                ),
                                                child: Text(
                                                  'Login',
                                                  style: GoogleFonts.ubuntu(
                                                    fontSize: 16,
                                                    color: Color(0xFF584A4A),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 20),

                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Already have an account?',
                                                  style: GoogleFonts.ubuntu(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xFF48742C),
                                                  ),
                                                ),
                                                Text(
                                                  'Log in now.',
                                                  style: GoogleFonts.ubuntu(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xFF48742C),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: Container(
                          width: 195,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Text(
                            'Login',
                            style: GoogleFonts.ubuntu(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF02480F),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
