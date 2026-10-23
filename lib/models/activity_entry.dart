import '../enums/location_type.dart';
import '../enums/company_type.dart';

class ActivityEntry {
  // ? = optional
  // final - podejscie immutablility, zmiany w danych bardziej kontrolowane i przewidywalne
  // pola nie sa prywatne - podobno we flutetrze tak sie robi - zweryfikowac
  final int? id; //? bo musi obsluzyc tez wpisy nie zapisane w bazie
  final String activityName;
  final DateTime date; //czy datetime czzy moze bez czasu?
  final Set<String> categories;
  final LocationType locationType; //enum
  final CompanyType companyType;  //enum
  final int? moodBefore;
  final int moodAfter;
  final int rating;
  final Set<String> emotions;
  final String? likes;
  final String? dislikes;
  final String? notes;

//konstruktor
  ActivityEntry({
    this.id,
    required this.activityName,
    required this.date,
    required Set<String> categories,
    required this.locationType,
    required this.companyType,
    this.moodBefore,
    required this.moodAfter,
    required this.rating,
    required Set<String> emotions,
    this.likes,
    this.dislikes,
    this.notes,
// zabezpieczenie przed modyfikacja listy kategorii i emocji po utworzeniu obiektu
//Do pola categories przypisz niemodyfikowalną kopię zbioru przekazanego w parametrze categories
  }): categories = Set.unmodifiable(categories),
        emotions = Set.unmodifiable(emotions) {
    // Walidacja
    //czy oceny sa w 1-5
    if (rating < 1 || rating > 5) {
      throw ArgumentError('Rating must be in the range of 1–5');
    }
    if (moodAfter < 1 || moodAfter > 5) {
      throw ArgumentError('Mood after activity must be in the range of 1–5');
    }
    if (moodBefore != null && (moodBefore! < 1 || moodBefore! > 5)) {
      throw ArgumentError('Mood before activity must be between 1 and 5');
    }
    // czy kategorie i emocje nie sa puste
    // warto moze sprawdzic czy nie sa puste stringi w kategoriach i emocjach
    if (categories.isEmpty) {
      throw ArgumentError('Categories cannot be empty');
    }
    if (emotions.isEmpty) {
      throw ArgumentError('Emotions cannot be empty');
    }
    //czy nazwa aktywnosci, likes, dislikes i notes nie są za długie
    // to potem do dostosowania na pozniejszym etapie
    if (activityName.length > 100) {
      throw ArgumentError('Activity name cannot exceed 100 characters');
    }
    if (likes != null && likes!.length > 200) {
      throw ArgumentError('Likes cannot exceed 200 characters');
    }
    if (dislikes != null && dislikes!.length > 200) {
      throw ArgumentError('Dislikes cannot exceed 200 characters');
    }
    if (notes != null && notes!.length > 300) {
      throw ArgumentError('Notes cannot exceed 300 characters');
    }
    //czy nazwa aktywnosci nie jest pusta
    if (activityName.trim().isEmpty) {
      throw ArgumentError('Activity name cannot be empty');
    }
    // czy data nie jest w przyszlosci
    // moze warto dac ograniczenie ile max w przeszłość wybiegamy
    // czy tutaj nie bedzie problemy jak bedzie roznica czasu miedzy serwerem a klientem? - pomyśleć
    final now = DateTime.now();
    if (date.isAfter(now)) {
      throw ArgumentError('Date cannot be in the future');
    }
    //czy ID jest dodatnie jesli jest podane
    if (id != null && id! <= 0) {
      throw ArgumentError('ID must be a positive integer');
    }
    // potem bedzie trzeba sprawzic jeszcze czy kategorie i emocje sa w liscie dozwolonych kategorii i emocji
  }
}