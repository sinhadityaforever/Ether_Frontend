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
    desc: "Simple . Reliable . Secure",
    imagePath: 'images/logo.png',
    credits: '',
  );
  slides.add(sliderModel0);
  SliderModel sliderModel1 = SliderModel(
    title: "Connections",
    desc:
        "Connecting people from around the world, having similar things to talk about.",
    imagePath: 'images/1.png',
    credits: 'Designed by Freepik',
  );
  slides.add(sliderModel1);
  SliderModel sliderModel2 = SliderModel(
    title: "New Friend",
    desc:
        "A new friend gets automatically added to your Ether contacts every third day.",
    imagePath: 'images/2.png',
    credits: 'Designed by Freepik',
  );
  slides.add(sliderModel2);
  SliderModel sliderModel3 = SliderModel(
    title: "Get Comfy",
    desc:
        "Get comfortable on chat, and organize meets if you find worth it. Your next best connection is just a link away ",
    imagePath: 'images/3.png',
    credits: 'Designed by Freepik',
  );
  slides.add(sliderModel3);
  SliderModel sliderModel4 = SliderModel(
    title: "Secure",
    desc:
        "You are securely connected over our app. The contacts don't have any access to your personal details. And messages are end to end encrypted",
    imagePath: 'images/4.png',
    credits: 'Designed by Freepik',
  );
  slides.add(sliderModel4);
  return slides;
}
