import 'package:flutter/foundation.dart';

import '../../../core/constants/app_images.dart';

class HeroFoodItem {
  const HeroFoodItem({
    required this.title,
    required this.shortDescription,
    required this.iconImage,
    required this.dishImage,
  });

  final String title;
  final String shortDescription;
  final String iconImage;
  final String dishImage;
}

class HomeViewModel extends ChangeNotifier {
  static const int visibleFoodCount = 3;

  final List<HeroFoodItem> foodItems = const [
    HeroFoodItem(
      title: 'Karachi Chicken Biryani',
      shortDescription: 'Spicy chicken, basmati rice, and Karachi masala.',
      iconImage: AppImages.biryaniImage1,
      dishImage: AppImages.biryaniImage1,
    ),
    HeroFoodItem(
      title: 'Daighi Biryani',
      shortDescription: 'Traditional daighi flavor with slow-cooked aroma.',
      iconImage: AppImages.biryaniImage2,
      dishImage: AppImages.biryaniImage2,
    ),
    HeroFoodItem(
      title: 'Beef Biryani',
      shortDescription: 'Tender beef layered with bold street-style spice.',
      iconImage: AppImages.biryaniImage3,
      dishImage: AppImages.biryaniImage3,
    ),
    HeroFoodItem(
      title: 'Mutton Biryani',
      shortDescription: 'Premium mutton, saffron warmth, and deep masala.',
      iconImage: AppImages.biryaniImage4,
      dishImage: AppImages.biryaniImage4,
    ),
    HeroFoodItem(
      title: 'Family Biryani Tray',
      shortDescription: 'A shareable tray made for gatherings and cravings.',
      iconImage: AppImages.biryaniImage5,
      dishImage: AppImages.biryaniImage5,
    ),
  ];

  int _selectedFoodIndex = visibleFoodCount - 1;
  int _visibleStartIndex = 0;
  bool _heroIntroCompleted = false;

  int get selectedFoodIndex => _selectedFoodIndex;
  bool get heroIntroCompleted => _heroIntroCompleted;
  HeroFoodItem get selectedDish => foodItems[_selectedFoodIndex];

  List<int> get visibleFoodIndices {
    return List.generate(
      visibleFoodCount,
      (slot) => (_visibleStartIndex + slot) % foodItems.length,
    );
  }

  void selectFood(int index) {
    if (index == _selectedFoodIndex) return;

    _selectedFoodIndex = index;
    _visibleStartIndex =
        (index - (visibleFoodCount - 1) + foodItems.length) % foodItems.length;
    notifyListeners();
  }

  void markHeroIntroCompleted() {
    if (_heroIntroCompleted) return;
    _heroIntroCompleted = true;
    notifyListeners();
  }
}
