import 'dart:math';
import 'iec.dart';

class IECEI extends IEC {
  double A = 80;
  double k1 = 0;
  double B = 0;
  double k2 = 0;
  double P = 2;
  double Q = 1;

  @override
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

    t = ((A * td + k1) / (pow(m, P) - Q)) + B * td + k2;

    return t;
  }
}
