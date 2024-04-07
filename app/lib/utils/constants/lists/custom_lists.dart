import '../../../features/models/category_card_model.dart';
import '../image_strings.dart';

class CustomLists {
  static List<String> profileDetailsLabels = [
    'Full Name',
    'Email',
    'Mobile Number',
    'Address',
  ];
  static List<String> profileDetailsFields = [
    'fullName',
    'email',
    'mobileNumber',
    'address',
  ];
   static List<CategoryCard> categories = [
    CategoryCard(
        title: 'Fertilizers',
        imageUrl: MyImages.fertilizer,
        collectionName: 'fertilizers'),
    CategoryCard(
        title: 'Vegitable\nPlants',
        imageUrl: MyImages.vegiplants,
        collectionName: 'vegitable plants'),
    CategoryCard(
        title: 'Fruit\nPlants',
        imageUrl: MyImages.fruitplants,
        collectionName: 'fruits plants'),
    CategoryCard(
        title: 'Indoor\nPlants',
        imageUrl: MyImages.indorPlants,
        collectionName: 'indoor plants'),
    CategoryCard(
        title: 'Bedding\nPlants',
        imageUrl: MyImages.bedplants,
        collectionName: 'bedding plants'),
  ];
  static List<String> titles = [
    'Fertilizers', // Initial title
    'Vegitable Plants', // Add all titles here
    'Fruit Plants',
    'Indoor Plants',
    'Bedding Plants'
  ];
}
