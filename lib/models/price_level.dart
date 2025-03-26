enum PriceLevel{
  FREE,
  INEXPENSIVE,
  MODERATE,
  EXPENSIVE,
  VERY_EXPENSIVE,
  UNKNOWN
}

PriceLevel convertPriceLevelByName(String? priceLevelName) {
  switch (priceLevelName?.toLowerCase()) {
    case 'free':
      return PriceLevel.FREE;
    case 'inexpensive':
      return PriceLevel.INEXPENSIVE;
    case 'moderate':
      return PriceLevel.MODERATE;
    case 'expensive':
      return PriceLevel.EXPENSIVE;
    case 'veryexpensive':
      return PriceLevel.VERY_EXPENSIVE;
    default:
      return PriceLevel.UNKNOWN;
  }
}