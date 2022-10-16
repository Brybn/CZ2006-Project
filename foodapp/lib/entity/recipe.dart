class Recipe {
  Recipe({
    this.id = '',
    this.title = '',
    this.image = '',
    this.servings = '',
    this.readyInMinutes = '',
    this.calories = '',
    this.analyzedInstructions,
    this.ingredients = '',
    this.summary = '',
  });

  String id;
  String title;
  String image;
  String servings;
  String readyInMinutes;
  String calories;
  List<String> analyzedInstructions;
  String ingredients;
  String summary;

  static Recipe fromJson(final data) {
    return Recipe(
      id: data['id'].toString(),
      title: data['title'],
      image: data['image'],
      servings: data['servings'].toString(),
      readyInMinutes: data['readyInMinutes'].toString(),
      calories: data['nutrition']['nutrients'][0]['amount'].toString(),
      analyzedInstructions: _formatInstructions(data['analyzedInstructions'][0]['steps']),
      // data['nutrition']['ingredients'],
      summary: _stripHtml(data['summary']),
    );
  }

  static String _stripHtml(String text) =>
      text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '');

  static List<String> _formatInstructions(List steps) {
    List<String> formattedSteps = <String>[];
    for (var element in steps) {
      formattedSteps.add("Step ${element['number']}: ${element['step']}");
    }
    return formattedSteps;
  }
}
