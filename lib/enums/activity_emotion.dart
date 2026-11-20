enum ActivityEmotion {
  joy('joy', 'Radość'),
  calm('calm', 'Spokój'),
  satisfaction('satisfaction', 'Zadowolenie'),
  excitement('excitement', 'Ekscytacja'),
  sadness('sadness', 'Smutek'),
  anger('anger', 'Złość'),
  anxiety('anxiety', 'Lęk'),
  frustration('frustration', 'Frustracja'),
  indifference('indifference', 'Obojętność'),
  focus('focus', 'Skupienie'),
  fatigue('fatigue', 'Zmęczenie');

  const ActivityEmotion(this.apiId, this.label);

  final String apiId;
  final String label;
}
