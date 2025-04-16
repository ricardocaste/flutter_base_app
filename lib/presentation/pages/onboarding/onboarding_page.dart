import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushNamed('nav');
  }

  bool isDeviceInEnglish() {
    final deviceLanguage = View.of(context).platformDispatcher.locale.languageCode;
    return deviceLanguage == 'en';
  }

  Map<String, Map<String, Map<String, String>>> _getOnboardingTexts() {
    return {
      'page1': {
        'title': {
          'es': 'title onboarding 1',
          'en': 'title onboarding 1',
        },
        'body': {
          'es': 'body onboarding 1',
          'en': 'body onboarding 1',
        },
      },
      'page2': {
        'title': {
          'es': 'title onboarding 2',
          'en': 'title onboarding 2',
        },
        'body': {
          'es': 'body onboarding 2',
          'en': 'body onboarding 2',
        },
      },
      'page3': {
        'title': {
          'es': 'title onboarding 3',
          'en': 'title onboarding 3',
        },
        'body': {
          'es': 'body onboarding 3',
          'en': 'body onboarding 3',
        },
      },
      'page4': {
        'title': {
          'es': 'title onboarding 4',
          'en': 'title onboarding 4',
        },
        'body': {
          'es': 'body onboarding 4',
          'en': 'body onboarding 4',
        },
      },
    };
  }

  String _getText(String page, String field) {
    final texts = _getOnboardingTexts();
    final language = isDeviceInEnglish() ? 'en' : 'es';
    return texts[page]?[field]?[language] ?? '';
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Image.asset('assets/$assetName', width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      infiniteAutoScroll: false,
      pages: [
        PageViewModel(
          useRowInLandscape: false,
          title: _getText('page1', 'title'),
          body: _getText('page1', 'body'),
          image: _buildImage('images/app.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: _getText('page2', 'title'),
          body: _getText('page2', 'body'),
          image: _buildImage('images/app.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: _getText('page3', 'title'),
          body: _getText('page3', 'body'),
          image: _buildImage('images/app.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: _getText('page4', 'title'),
          body: _getText('page4', 'body'),
          image: _buildImage('images/app.png'),
          decoration: pageDecoration.copyWith(
            bodyFlex: 6,
            imageFlex: 6,
            safeArea: 80,
          ),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), 
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Start', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}