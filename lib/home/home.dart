import 'dart:math';

import 'package:flutter/material.dart';
import 'package:photogpt/chatgpt/utils.dart';
import 'package:photogpt/widgets/spacing.dart';
import 'package:photogpt/constants/app_constants.dart';
import 'package:photogpt/constants/app_language.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photogpt/home/widgets/page_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String song = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  double _mainContentOpacity = 1;

  //add a listener to scroll controller in intstate
  @override
  void initState() {
    _scrollController.addListener(() {
      setState(() {
        if (_scrollController.offset < 50) {
          setState(() {
            _mainContentOpacity = 1;
          });
        }
        if (_scrollController.offset > 50) {
          _mainContentOpacity = max(0, 1 - (_scrollController.offset / 300));
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: 0.4,
          child: Image.network(
            AppConstants.homePageBgImageUrl,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            title: _appBarTitle,
            leading: _hamburger,
            actions: [
              _settingsIcon,
            ],
          ),
          drawer: _drawer,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              controller: _scrollController,
              child: Column(
                children: [
                  _mainContainer(context),
                  _description,
                  height(50),
                  _footer,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget get _settingsIcon {
    return Transform.rotate(
      angle: _mainContentOpacity * 2 * pi,
      child: IconButton(
        icon: const Icon(
          Icons.settings,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () {},
      ),
    );
  }

  Widget get _appBarTitle {
    return Opacity(
      opacity: 1 - _mainContentOpacity,
      child: Row(
        children: [
          Image.network(AppConstants.appLogoWhite, height: 40),
          width(10),
          _title(25),
        ],
      ),
    );
  }

  Widget get _drawer {
    return Drawer(
      child: Container(
        color: const Color.fromARGB(255, 238, 204, 101),
      ),
    );
  }

  Widget get _hamburger {
    return IconButton(
      icon: const Icon(
        Icons.menu,
        color: Colors.white,
        size: 35,
      ),
      onPressed: () {
        _scaffoldKey.currentState!.openDrawer();
      },
    );
  }

  Widget _mainContainer(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent, width: 5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Opacity(
            opacity: _mainContentOpacity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                children: [
                  height(70),
                  _gptIcon,
                  height(30),
                  _title(60),
                  _subtitle,
                ],
              ),
            ),
          ),
          height(45),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text('Pick an Image:',
                style: GoogleFonts.titilliumWeb(
                    fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          height(20),
          const SizedBox(
            height: 130,
            child: HomePageView(),
          ),
          height(55),
          _seeMore,
        ],
      ),
    );
  }

  Widget get _subtitle {
    return Row(
      children: [
        Text(
          AppLanguage.promptGPTWithImages,
          style: GoogleFonts.titilliumWeb(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget get _seeMore {
    return Opacity(
      opacity: _mainContentOpacity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.keyboard_arrow_down_outlined, color: Colors.white),
        ],
      ),
    );
  }

  Widget get _description {
    return Opacity(
      opacity: 1 - _mainContentOpacity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How Does it work?',
              style: GoogleFonts.titilliumWeb(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            height(30),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
              style: GoogleFonts.titilliumWeb(fontSize: 20, color: Colors.white),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  Widget _title(double fontSize) {
    return Row(
      children: [
        Text(
          AppLanguage.photo.toLowerCase(),
          style: GoogleFonts.titilliumWeb(
            fontSize: fontSize,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          AppLanguage.gpt,
          style: GoogleFonts.titilliumWeb(
            fontSize: fontSize * (7 / 6),
            fontWeight: FontWeight.w200,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget get _footer {
    return Container(
      color: const Color.fromARGB(255, 15, 16, 30),
      height: 100,
    );
  }

  Widget get _gptIcon {
    return Image.network(
      AppConstants.appIcon,
      height: 100,
    );
  }

  void _onTap() async {
    setState(() {
      song = 'Loading...';
    });

    final response =
        await GPTUtils.getGPTResponse(prompt: 'Write thirty words about a good pirate');

    setState(() {
      song = response;
    });
  }
}
