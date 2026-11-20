enum ActivityCategory {
  physicalActivity('physical_activity', 'Ruch'),
  relaxation('relaxation', 'Relaks'),
  creativity('creativity', 'Kreatywność'),
  socializing('socializing', 'Spotkania'),
  learning('learning', 'Nauka'),
  other('other', 'Inne');

  const ActivityCategory(this.apiId, this.label);

  final String apiId;
  final String label;
}
