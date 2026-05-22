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

class MenuCategory {
  const MenuCategory({
    required this.title,
    required this.description,
    required this.items,
  });

  final String title;
  final String description;
  final List<MenuItem> items;
}

class MenuItem {
  const MenuItem({
    required this.title,
    required this.description,
    required this.price,
    required this.image,
  });

  final String title;
  final String description;
  final String price;
  final String image;
}

class WhyStep {
  const WhyStep({required this.title, required this.description});

  final String title;
  final String description;
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

  final List<MenuCategory> menuCategories = const [
    MenuCategory(
      title: 'All',
      description:
          'A curated taste of Karachi biryani, paratha rolls, and family-style comfort plates.',
      items: [
        MenuItem(
          title: 'Chicken Daighi Biryani',
          price: '13.99',
          image: AppImages.biryaniImage1,
          description:
              'Succulent chicken and seasoned potatoes layered with onions, tomatoes, cilantro, mint, yogurt, bold spices, and top-quality basmati rice.',
        ),
        MenuItem(
          title: 'Shahi Veal Biryani',
          price: '16.99',
          image: AppImages.biryaniImage2,
          description:
              'Delicately spiced veal layered with mint, cilantro, yogurt, tomatoes, onions, and long-grain basmati rice.',
        ),
        MenuItem(
          title: 'Garlic Mayo Roll',
          price: '12.99',
          image: AppImages.biryaniImage3,
          description:
              'Tender chicken tossed in creamy mayo and garlic sauce, wrapped in a crispy paratha for a rich Karachi-style bite.',
        ),
        MenuItem(
          title: 'Beef Bihari Roll',
          price: '14.99',
          image: AppImages.biryaniImage4,
          description:
              'Marinated beef wrapped in flaky paratha with onions, cilantro, and tangy mint-plum chutney.',
        ),
        MenuItem(
          title: 'Family Biryani Tray',
          price: '34.99',
          image: AppImages.biryaniImage5,
          description:
              'A generous tray of signature biryani layered for sharing with family-style warmth.',
        ),
      ],
    ),
    MenuCategory(
      title: 'Traditional Daighi Biryanis',
      description:
          'Authentic Karachi street-style raseeli daighi/degi biryani that melts in the mouth. Fresh, juicy and mouthwatering.',
      items: [
        MenuItem(
          title: 'Chicken Daighi Biryani',
          price: '13.99',
          image: AppImages.biryaniImage1,
          description:
              'Succulent chicken and seasoned potatoes layered with onions, tomatoes, cilantro, mint, yogurt, bold spices, and top-quality basmati rice.',
        ),
        MenuItem(
          title: 'Shahi Veal Biryani',
          price: '16.99',
          image: AppImages.biryaniImage2,
          description:
              'Delicately spiced veal layered with mint, cilantro, yogurt, tomatoes, onions, and long-grain basmati rice.',
        ),
      ],
    ),
    MenuCategory(
      title: 'BBQ Platters & Paratha Rolls',
      description:
          'Authentic Karachi street-style paratha rolls packed with fresh, juicy fillings wrapped in flaky golden paratha. Saucy, flavorful, and irresistibly mouthwatering.',
      items: [
        MenuItem(
          title: 'Garlic Mayo Roll',
          price: '12.99',
          image: AppImages.biryaniImage3,
          description:
              'Tender chicken tossed in creamy mayo and garlic sauce, wrapped in a crispy paratha for a rich Karachi-style bite.',
        ),
        MenuItem(
          title: 'Beef Bihari Roll',
          price: '14.99',
          image: AppImages.biryaniImage4,
          description:
              'Marinated beef wrapped in flaky paratha with onions, cilantro, and tangy mint-plum chutney.',
        ),
      ],
    ),
    MenuCategory(
      title: 'Family Favorites',
      description:
          'Big-flavor Karachi plates for gatherings, cravings, and comfort-food moments.',
      items: [
        MenuItem(
          title: 'Family Biryani Tray',
          price: '34.99',
          image: AppImages.biryaniImage5,
          description:
              'A generous tray of signature biryani layered for sharing with family-style warmth.',
        ),
      ],
    ),
  ];

  final List<WhyStep> whySteps = const [
    WhyStep(
      title: 'Fresh Cooked',
      description: 'Every batch is made hot, aromatic, and ready to serve.',
    ),
    WhyStep(
      title: 'Bold Spices',
      description: 'Real desi masala, layered flavor, and the right kick.',
    ),
    WhyStep(
      title: 'Big Portions',
      description: 'Generous plates made for hungry people and happy families.',
    ),
    WhyStep(
      title: 'Family Dinner Ready',
      description: 'Easy pickup for weeknight dinners and weekend cravings.',
    ),
    WhyStep(
      title: 'Pickup Available',
      description: 'Fast pickup flow for Houston and Sugar Land customers.',
    ),
    WhyStep(
      title: 'Catering Friendly',
      description:
          'Trays and packages for birthdays, office lunches, and events.',
    ),
  ];

  int _selectedFoodIndex = visibleFoodCount - 1;
  int _visibleStartIndex = 0;
  int _selectedMenuCategoryIndex = 0;
  bool _heroIntroCompleted = false;

  int get selectedFoodIndex => _selectedFoodIndex;
  int get selectedMenuCategoryIndex => _selectedMenuCategoryIndex;
  bool get heroIntroCompleted => _heroIntroCompleted;
  HeroFoodItem get selectedDish => foodItems[_selectedFoodIndex];
  MenuCategory get selectedMenuCategory =>
      menuCategories[_selectedMenuCategoryIndex];

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

  void selectMenuCategory(int index) {
    if (index == _selectedMenuCategoryIndex ||
        index < 0 ||
        index >= menuCategories.length) {
      return;
    }

    _selectedMenuCategoryIndex = index;
    notifyListeners();
  }
}
