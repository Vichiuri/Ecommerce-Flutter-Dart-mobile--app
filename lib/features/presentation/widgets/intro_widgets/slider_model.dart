///the slider items now
class Slider {
  final String sliderImageUrl;
  final String sliderHeading;
  final String sliderSubHeading;

  Slider({
    required this.sliderImageUrl,
    required this.sliderHeading,
    required this.sliderSubHeading,
  });
}

final sliderArrayList = [
  Slider(
    sliderImageUrl: 'assets/images/on1.jpg',
    sliderHeading: "Place Orders",
    sliderSubHeading:
        "We help retailers connect with delivery stores around Kenya",
  ),
  Slider(
    sliderImageUrl: 'assets/images/on3.jpg',
    sliderHeading: "Track Ordes",
    sliderSubHeading: "Easily access and Track your orders.",
  ),
  Slider(
    sliderImageUrl: 'assets/images/on2.jpg',
    sliderHeading: "Fast Delivery",
    sliderSubHeading:
        "You can be assured a tight knit supply chain system that ensures a quick and safe delivery",
  ),
];
