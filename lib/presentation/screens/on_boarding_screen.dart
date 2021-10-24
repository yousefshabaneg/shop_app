import 'package:flutter/material.dart';
import 'package:shop_app/data/cashe_helper.dart';
import 'package:shop_app/presentation/screens/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/constants/my_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  final String Image;
  final String title;
  final String body;

  BoardingModel({required this.Image, required this.title, required this.body});
}

class OnBoardingScreen extends StatefulWidget {
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController _controller = PageController();
  var _currentPage = 0;
  List<BoardingModel> boardingModels = [
    BoardingModel(
      Image: 'assets/images/boarding/1.png',
      title: 'Keep Save',
      body:
          'Accept cryptocurrencies and digital assets, keep thern here, or send to orthers',
    ),
    BoardingModel(
        Image: 'assets/images/boarding/2.png',
        title: 'Buy & Invest',
        body:
            'Buy Bitcoin and cryptocurrencies with VISA and MasterVard right in the App'),
    BoardingModel(
      Image: 'assets/images/boarding/3.png',
      title: 'Sell & Exchange',
      body:
          'Sell your Bitcoin cryptocurrencies or Change with orthres digital assets or flat money',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            child: Text(
              'SKIP',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            onPressed: goToLogin,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: _controller,
                onPageChanged: _onChanged,
                itemBuilder: (context, index) =>
                    buildBoardingItem(boardingModels[index]),
                itemCount: 3,
                physics: BouncingScrollPhysics(),
              ),
            ), //Image
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: boardingModels.length,
                  axisDirection: Axis.horizontal,
                  effect: ExpandingDotsEffect(
                    activeDotColor: MyColors.primary,
                    dotColor: MyColors.dark,
                    dotHeight: 10,
                    dotWidth: 10,
                    expansionFactor: 6,
                    spacing: 5,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () {
                if (isLast()) {
                  goToLogin();
                } else {
                  _controller.nextPage(
                    duration: Duration(microseconds: 800),
                    curve: Curves.easeInOutQuint,
                  );
                }
              },
              child: AnimatedContainer(
                alignment: Alignment.center,
                duration: Duration(milliseconds: 150),
                height: 70,
                width: isLast() ? 180 : 75,
                decoration: BoxDecoration(
                  color: MyColors.primary,
                  borderRadius: BorderRadius.circular(35),
                ),
                child: isLast()
                    ? Text(
                        'Get Started',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      )
                    : Icon(
                        Icons.navigate_next,
                        size: 50,
                        color: Colors.white,
                      ),
              ),
            ), // Indicator
          ],
        ),
      ),
    );
  }

  bool isLast() {
    return _currentPage == (boardingModels.length - 1);
  }

  void goToLogin() {
    CashHelper.saveData(key: 'onBoarding', value: true).then((value) {
      if (value) {
        navigateAndFinish(context, LoginScreen());
      }
    });
  }

  _onChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
        children: [
          Expanded(
            child: Image(
              image: AssetImage(model.Image),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            model.title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              model.body,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
}
