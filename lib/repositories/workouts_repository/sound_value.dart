class SoundValue {
  final String name;
  // could be url, or local path
  final String path;
  final bool local;

  SoundValue(
    this.name,
    this.path,
    this.local,
  );

  @override
  String toString() {
    return 'Sound($name, $path, $local)';
  }

  Map<String, Object> toJson() {
    return {
      'name': name,
      'path': path,
      'local': local,
    };
  }

  static SoundValue fromJson(Map<String, Object> json) {
    return SoundValue(
      json['name'] as String,
      json['path'] as String,
      json['local'] as bool,
    );
  }
}
