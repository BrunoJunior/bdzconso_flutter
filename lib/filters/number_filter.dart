class NumberFilter {
  final isNotZero = (num value) => null != value && 0 != value;
  final isZero = (num value) => null == value || 0 == value;
  final isPositive = (num value) => null != value && value > 0;
  final isNegative = (num value) => null != value && value < 0;
}
