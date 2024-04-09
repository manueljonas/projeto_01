class IEC {
  double m = 0.0;
  double td = 0.0;
  double t = 0.0;

  double timeToOperate(
    double elementPickUp,
    double elementFault,
    double elementTimeDial,
  ) {
    m = elementFault / elementPickUp;

    if (elementTimeDial >= 0.0) {
      td = elementTimeDial;
    } else {
      td = 0.0;
    }

    if (m >= 1) {
      t = td;
    } else {
      t = double.infinity;
    }

    return t;
  }
}
