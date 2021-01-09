class Exercise {
  String name;
  String clipPath;
  String instructionPath;
  String thumbnailPath;
  int completed = 0;

  Exercise(this.name) {
    clipPath =
        'assets/workouts/loops/${name.toLowerCase().replaceAll(' ', '_')}_repeat.mp4';
    instructionPath =
        'assets/workouts/instructions/${name.toLowerCase().replaceAll(' ', '_')}.mp3';
    thumbnailPath =
        'assets/thumbnails/${name.toLowerCase().replaceAll(' ', '_')}.jpeg';
  }
}
