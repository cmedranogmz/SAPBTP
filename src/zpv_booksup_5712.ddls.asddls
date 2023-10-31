@EndUserText.label: 'Booking Supplements - Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZPV_BOOKSUP_5712
  as projection on ZR_BOOKSUP_5712
{
  key TravelId,
  key BookingId,
  key BookingSupplementId,
      SupplementId,
      _SupplementText.Description as SupplementDescription : localized,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Price,
      CurrencyCode,
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,
      /* Associations */
      _Travel  : redirected to ZPV_TRAVEL_5712,
      _Booking : redirected to parent ZPV_BOOKING_5712,
      _Product,
      _SupplementText

}
