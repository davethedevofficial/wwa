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

  static String bandedLateralWalk = 'Banded Lateral Walk';
  static String bicycleCrunches = 'Bicycle Crunches';
  static String birdDog = 'Bird Dog';
  static String bodyweightLegExtension = 'Bodyweight Leg Extension';
  static String bodyweightTricepDips = 'Bodyweight Tricep Dips';
  static String commandoPlank = 'Commando Plank';
  static String crabToeTouch = 'Crab Toe Touch';
  static String curtsyLunge = 'Curtsy Lunge';
  static String donkeyKicks = 'Donkey Kicks';
  static String frogPumps = 'Frog Pumps';
  static String froggers = 'Froggers';
  static String gluteBridges = 'Glute Bridges';
  static String heelTaps = 'Heel Taps';
  static String inAndOutJump = 'In And Out Jump';
  static String jumpSquats = 'Jump Squats';
  static String jumpingLunges = 'Jumping Lunges';
  static String kneelingPushUps = 'Kneeling Push Ups';
  static String lunges = 'Lunges';
  static String mountainClimbers = 'Mountain Climbers';
  static String plank = 'Plank';
  static String plankWithLegRaise = 'Plank With Leg Raise';
  static String russainTwists = 'Russian Twists';
  static String scissorKicks = 'Scissor Kicks';
  static String sideLunge = 'Side Lunge';
  static String sidePlank = 'Side Plank';
  static String singleLegGluteBridge = 'Single Leg Glute Bridge';
  static String squats = 'Squats';
  static String straightLegToeTouches = 'Straight Leg Toe Touches';
  static String superwoman = 'Superwoman';
  static String vSitWithExtension = 'V Sit With Extension';
}
