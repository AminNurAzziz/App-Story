import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Atur durasi animasi
    )..repeat(reverse: true); // Membuat animasi berulang dengan berbalik arah
  }

  @override
  void dispose() {
    _controller.dispose(); // Hapus controller saat widget di dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 241, 249, 255),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(10 * _controller.value, 0),
                    child: Image.asset('assets/5340752.jpg'),
                  );
                },
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat datang di Azziz Story',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Mau berbagi cerita tentang pengalamanmu kamu dibidang IT? Di Azz Story aja!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonBar(
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: Text('Masuk'),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF1A1A1A),
                                onPrimary: Colors.white,
                                fixedSize: Size(120, 0),
                              ),
                            ),
                            SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () {},
                              child: Text('Daftar'),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF1A1A1A),
                                onPrimary: Colors.white,
                                fixedSize: Size(120, 0),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
