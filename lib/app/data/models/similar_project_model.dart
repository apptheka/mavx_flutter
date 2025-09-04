class SimilarProject {
  final String title;
  final String company;
  final String location;
  final String salary; // e.g., '25K - 35K'
  final String tag;    // e.g., '92% Match'

  SimilarProject({
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.tag,
  });

  factory SimilarProject.fromMap(Map<String, String> map) => SimilarProject(
        title: map['title'] ?? '',
        company: map['company'] ?? '',
        location: map['location'] ?? '',
        salary: map['salary'] ?? '',
        tag: map['tag'] ?? '',
      );

  Map<String, String> toMap() => {
        'title': title,
        'company': company,
        'location': location,
        'salary': salary,
        'tag': tag,
      };
}
