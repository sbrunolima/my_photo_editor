const List<double> NOFILTER = [
  1, 0, 0, 0, 0, //
  0, 1, 0, 0, 0, //
  0, 0, 1, 0, 0, //
  0, 0, 0, 1, 0, //
];

const List<double> GRAYSCALE = [
  0.3, 0.59, 0.11, 0, 0, //
  0.3, 0.59, 0.11, 0, 0, //
  0.3, 0.59, 0.11, 0, 0, //
  0, 0, 0, 1, 0, //
];

const List<double> HALFTONE = [
  0.8, 0.2, 0, 0, // Red
  0.3, 0.7, 0, 0, // Green
  0, 0.4, 0.6, 0, // Blue
  0, 0, 0, 1, // Alpha
  0.5, 0, 0.5, 0, // Additional color
];

const List<double> BRIGHTNESS = [
  1.5, 0, 0, 0, 0, // Red
  0, 1.5, 0, 0, 0, // Green
  0, 0, 1.5, 0, 0, // Blue
  0, 0, 0, 1, 0, // Alpha
];

const List<double> BLACKWHITE = [
  0, 1, 0, 0, 0, //
  0, 1, 0, 0, 0, //
  0, 1, 0, 0, 0, //
  0, 1, 0, 1, 0, //
];

const List<double> HIGHLIGHTSHADOW = [
  1.2, 0, 0, 0, 0, // Red (Increase intensity for highlights)
  0, 1.2, 0, 0, 0, // Green (Increase intensity for highlights)
  0, 0, 1.2, 0, 0, // Blue (Increase intensity for highlights)
  0, 0, 0.8, 1, 0, // Alpha (Reduce intensity for shadows)
];

const List<double> FALSECOLOR = [
  0, 0, 1, 0, 0, // Red (Mapped to Blue)
  1, 0, 0, 0, 0, // Green (Unchanged)
  0, 1, 0, 0, 0, // Blue (Mapped to Red)
  0, 0, 0, 1, 0, // Alpha
];
