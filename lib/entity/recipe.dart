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

  final String id;
  final String title;
  final String image;
  final String servings;
  final String readyInMinutes;
  final String calories;
  final List<dynamic> analyzedInstructions;
  final String ingredients;
  final String summary;

  static Recipe fromJson(final data) {
    return Recipe(
      id: data['id'].toString(),
      title: data['title'],
      image: data['image'],
      servings: data['servings'].toString(),
      readyInMinutes: data['readyInMinutes'].toString(),
      calories: data['nutrition']['nutrients'][0]['amount'].toString(),
      analyzedInstructions:
          _formatInstructions(data['analyzedInstructions'][0]['steps']),
      // ingredients: data['nutrition']['ingredients'],
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'servings': servings,
      'readyInMinutes': readyInMinutes,
      'calories': calories,
      'analyzedInstructions': analyzedInstructions,
      'ingredients': ingredients,
      'summary': summary,
    };
  }

  static Recipe fromMap(Map data) {
    return Recipe(
      id: data['id'],
      title: data['title'],
      image: data['image'],
      servings: data['servings'],
      readyInMinutes: data['readyInMinutes'],
      calories: data['calories'],
      analyzedInstructions: data['analyzedInstructions'],
      ingredients: data['ingredients'],
      summary: data['summary'],
    );
  }
}
