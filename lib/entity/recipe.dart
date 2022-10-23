class Recipe {
  Recipe({
    this.id = '',
    this.title = '',
    this.image = '',
    this.servings = '',
    this.readyInMinutes = '',
    this.calories = '',
    this.analyzedInstructions,
    this.ingredients,
    this.summary = '',
  });

  final String id;
  final String title;
  final String image;
  final String servings;
  final String readyInMinutes;
  final String calories;
  final List<dynamic> analyzedInstructions;
  final List<dynamic> ingredients;
  final String summary;

  static Recipe fromJson(final data) {
    return Recipe(
      id: data['id'].toString(),
      title: data['title'],
      image: data['image'],
      servings: data['servings'].toString(),
      readyInMinutes: data['readyInMinutes'].toString(),
      calories: data['nutrition']['nutrients'][0]['amount'].toString(),
      analyzedInstructions: _formatInstructions(data['analyzedInstructions']),
      ingredients:
          data['extendedIngredients'].map((item) => item['original']).toList(),
      summary: _stripHtml(data['summary']),
    );
  }

  static String _stripHtml(String text) =>
      text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '');

  static List<String> _formatInstructions(List instructions) {
    if (instructions.isEmpty) {
      return <String>[];
    }
    List<String> formattedSteps = <String>[];
    List<dynamic> steps = instructions[0]['steps'];
    for (var step in steps) {
      formattedSteps.add(
          "${step['step']}".replaceAll(RegExp(r'[^A-Za-z0-9. -,()$/:]'), ''));
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
