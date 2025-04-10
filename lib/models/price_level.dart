enum PriceLevel{
  FREE,
  INEXPENSIVE,
  MODERATE,
  EXPENSIVE,
  VERY_EXPENSIVE,
  UNKNOWN,
  // nearby place price levels
  PRICE_LEVEL_FREE,
  PRICE_LEVEL_INEXPENSIVE,
  PRICE_LEVEL_MODERATE,
  PRICE_LEVEL_EXPENSIVE,
  PRICE_LEVEL_VERY_EXPENSIVE,
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