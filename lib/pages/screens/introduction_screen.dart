import 'package:flutter/material.dart';
import './login_screen.dart';

class IntroductionScreen extends StatefulWidget {
  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _introData = [
    {
      'image': 'assets/images/intro1.png',
      'title': 'Selamat Datang di Teltix',
      'subtitle':
          'Aplikasi resmi penjualan tiket film karya siswa SMK Telkom Banjarbaru.',
    },
    {
      'image': 'assets/images/intro2.png',
      'title': 'Eksplor Karya Siswa',
      'subtitle':
          'Temukan dan tonton film-film orisinil buatan siswa berprestasi.',
    },
    {
      'image': 'assets/images/intro3.png',
      'title': 'Ayo Dukung Kreasi Mereka!',
      'subtitle':
          'Beli tiket sekarang dan nikmati karya luar biasa dari generasi muda.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _introData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 35),
                          Image.asset(_introData[index]['image']!, height: 300),
                          Text(
                            _introData[index]['title']!,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 3),
                          Text(
                            _introData[index]['subtitle']!,
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[500]),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (_currentPage != _introData.length - 1) {
                          _pageController.animateToPage(
                            _introData.length - 1,
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _pageController.animateToPage(
                            0,
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(_currentPage == _introData.length - 1
                          ? 'Back'
                          : 'Skip'),
                    ),
                    Row(
                      children: List.generate(
                        _introData.length,
                        (index) => GestureDetector(
                          onTap: () {
                            _pageController.animateToPage(
                              index,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            margin: const EdgeInsets.all(4.0),
                            width: _currentPage == index ? 24.0 : 8.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              color: _currentPage == index
                                  ? Colors.indigo
                                  : Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (_currentPage < _introData.length - 1) {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Navigator.push(context, _createRoute());
                        }
                      },
                      child: Text(_currentPage == _introData.length - 1
                          ? 'Sign In'
                          : 'Next'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 600), // Durasi transisi 600ms
    );
  }
}
