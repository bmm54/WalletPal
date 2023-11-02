import 'package:bstable/services/currency.dart';
import 'package:bstable/services/language_service.dart';
import 'package:bstable/services/theme_service.dart';
import 'package:bstable/sql/sql_helper.dart';
import 'package:bstable/ui/styles/colors.dart';
import 'package:bstable/ui/styles/decoration.dart';
import 'package:bstable/wrapper.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage>
    with TickerProviderStateMixin {
  final introKey = GlobalKey<IntroductionScreenState>();

  Color _accountColor = MyColors.purpule;
  final _accountName = TextEditingController();
  final _accountBalance = TextEditingController();
  String selectedCurrency = CurrencyController().getSelectedCurrency;
  String _selectedLanguage = LanguageService().getLanguage();
  final List currencies = CurrencyController.currency_symbol.keys.toList();
  Map<String, String> languages = {
    "English": "en",
    "العربية": "ar",
    "语言": "zh"
  };
  Future<void> _gettingStarted() async {
    if (_accountName.text.isEmpty || _accountBalance.text.isEmpty) {
      Get.snackbar("Warning", "You have to fill the account fields",
          colorText: Theme.of(context).textTheme.displaySmall!.color,
          icon: Icon(Icons.error));
    }
    await SQLHelper.createAccount(_accountName.text,
        double.parse(_accountBalance.text), _accountColor.value.toString());
    CurrencyController().changeCurrency(selectedCurrency);
  }

  void _onIntroEnd(context) async {
    await _gettingStarted();
    Get.to(() => Wrapper(), transition: Transition.circularReveal);
  }

  Widget _buildGettingStartedPage() {
    final _tabController = TabController(
        length: 4,
        vsync: this,
        );
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SafeArea(
          child: ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Getting started",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.almarai().fontFamily,
                            color: MyColors.iconColor),
                      ),
                      InkWell(
                        onTap: () {
                          ThemeService().changeThemeMode();
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              border: Border.all(
                                  width: 3,
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
                              borderRadius: BorderRadius.circular(15)),
                          child: Icon(
                            Get.isDarkMode
                                ? Icons.wb_sunny
                                : Icons.brightness_2_rounded,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Create your first account",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: GoogleFonts.almarai().fontFamily,
                        color: MyColors.iconColor),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _accountName,
                    decoration: CustomDeco.inputDecoration.copyWith(
                      hintText: 'Account name'.tr,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _accountBalance,
                    keyboardType: TextInputType.number,
                    decoration: CustomDeco.inputDecoration.copyWith(
                      hintText: 'Initial balance'.tr,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ColorPicker(
                        spacing: 10,
                        pickersEnabled: {
                          ColorPickerType.primary: false,
                          ColorPickerType.custom: true,
                          ColorPickerType.accent: false,
                        },
                        customColorSwatchesAndNames: {
                          ColorTools.createPrimarySwatch(MyColors.purpule):
                              "purple",
                          ColorTools.createPrimarySwatch(MyColors.lightBlue):
                              "blue",
                          ColorTools.createPrimarySwatch(MyColors.orange):
                              "orange",
                          ColorTools.createPrimarySwatch(MyColors.green):
                              "green",
                        },
                        enableOpacity: false,
                        color: _accountColor,
                        onColorChanged: (Color color) {
                          _accountColor = color;
                        },
                        enableShadesSelection: false,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Select your preffered currency",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: GoogleFonts.almarai().fontFamily,
                        color: MyColors.iconColor),
                  ),
                  SizedBox(height: 10),
                  TabBar(
                    splashBorderRadius: BorderRadius.circular(10),
                    onTap: (index) {
                      selectedCurrency = currencies[index];
                    },
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        border: Border.all(color: MyColors.purpule, width: 2)),
                    labelColor: MyColors.purpule,
                    unselectedLabelColor: Theme.of(context).textTheme.displayMedium!.color,
                    labelStyle: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                    controller: _tabController,
                    tabs: [
                      Tab(child: Text("\$")),
                      Tab(child: Text("MRO")),
                      Tab(child: Text("€")),
                      Tab(child: Text("TND")),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Select your preffered Language",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: GoogleFonts.almarai().fontFamily,
                        color: MyColors.iconColor),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: Get.width * 0.9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor),
                    child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: languages.length,
                      itemBuilder: (context, index) {
                        var values = languages.values.toList();
                        var names = languages.keys.toList();
                        return RadioListTile(
                          activeColor: MyColors.blue,
                          selected: _selectedLanguage == values[index],
                          value: values[index],
                          groupValue: _selectedLanguage,
                          onChanged: (value) {
                            var locale = Locale(value!);
                            Get.updateLocale(locale);
                            LanguageService().saveLanguage(value);
                            setState(() {
                              _selectedLanguage = value!;
                            });
                            
                          },
                          title: Text(names[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(
      String title, String description, Color mainColor, String imagePath) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.almarai().fontFamily,
                      color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  description,
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: GoogleFonts.almarai().fontFamily,
                      color: Colors.white),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Align(
                alignment: Alignment.center,
                child:
                    Image.asset(fit: BoxFit.fill, width: Get.width, imagePath),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    PageDecoration pageDecoration(Color color) {
      return PageDecoration(
        titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
        bodyTextStyle: bodyStyle,
        bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        pageColor: color,
        imagePadding: EdgeInsets.zero,
      );
    }

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: false,
      infiniteAutoScroll: false,
      //globalHeader: Align(
      //  alignment: Alignment.topRight,
      //  child: Padding(
      //    padding: const EdgeInsets.only(top: 16, right: 16),
      //    child: _buildImage('flutter.png', 100),
      //  ),
      //),
      rawPages: [
        _buildPage(
            "Record all your expenses and incomes",
            "Record your daily incomes and outcomes.",
            Color(0xffF0CF69),
            "lib/assets/images/page1.png"),
        _buildPage(
            "Track them with beautiful detailed charts",
            "You can filter them by days ,weeks and months.",
            Color(0xffB7ABFD),
            "lib/assets/images/page2.png"),
        _buildPage(
            "Managing your transaction have never been easier",
            "Track your transaction virtually with others in an easy organized way",
            Color(0xffEFB491),
            "lib/assets/images/page3.png"),
        _buildPage(
            "There is no limit to your financial goals and dreams",
            "Create goals and track your progress towards them.",
            Color(0xff95B6FF),
            "lib/assets/images/page4.png"),
        _buildGettingStartedPage(),
      ],
      onDone: () async {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('showHome', true);
        _onIntroEnd(context);
      },
      skipOrBackFlex: 0,
      nextFlex: 0,
      dotsFlex: 1,
      //showSkipButton: true,
      //skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: const Text(
          "Next",
          style:
              TextStyle(color: MyColors.iconColor, fontWeight: FontWeight.bold),
        ),
      ),
      done: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        decoration: BoxDecoration(
            color: MyColors.purpule, borderRadius: BorderRadius.circular(10)),
        child: const Text(
          "Done",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.white30,
        activeColor: Colors.white,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
