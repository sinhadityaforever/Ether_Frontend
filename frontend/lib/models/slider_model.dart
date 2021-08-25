class SliderModel {
  String imagePath;
  String title;
  String desc;
  String credits;

  SliderModel(
      {required this.imagePath,
      required this.title,
      required this.desc,
      required this.credits});

  String getImageAssetPath() {
    return imagePath;
  }

  String getTitle() {
    return title;
  }

  String getDesc() {
    return desc;
  }

  String getCredits() {
    return credits;
  }
}

List<SliderModel> getSlides() {
  // ignore: deprecated_member_use
  List<SliderModel> slides = [];
  SliderModel sliderModel0 = SliderModel(
    title: "ETHER.",
    desc: "Learn . Network . Grow",
    imagePath: 'images/logo.png',
    credits: '',
  );
  slides.add(sliderModel0);
  SliderModel sliderModel1 = SliderModel(
    title: "Scrolling Made Healthy",
    desc:
        "We have curated some of the best content on the internet for you to scroll and expand your brain",
    imagePath: 'images/69.png',
    credits: 'Designed by Freepik',
  );
  slides.add(sliderModel1);
  SliderModel sliderModel2 = SliderModel(
    title: "Networking Made Automatic",
    desc:
        "A new like-minded person gets automatically added to your Ether contacts every day, making networking automatic",
    imagePath: 'images/2.png',
    credits: 'Designed by Freepik',
  );
  slides.add(sliderModel2);
  SliderModel sliderModel3 = SliderModel(
    title: "Welcome To The Community",
    desc:
        "You get added to Communities of like minded people to brainstorm with.",
    imagePath: 'images/doggy.png',
    credits: 'Designed by Freepik',
  );
  slides.add(sliderModel3);

  return slides;
}
