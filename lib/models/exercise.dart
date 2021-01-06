class Exercise {
  String name;
  String clipPath;
  String instructionPath;
  int completed = 0;

  Exercise(this.name) {
    clipPath =
        'assets/workouts/loops/${name.toLowerCase().replaceAll(' ', '_')}_repeat.mp4';
    instructionPath =
        'assets/workouts/instructions/${name.toLowerCase().replaceAll(' ', '_')}.mp3';
  }
}
