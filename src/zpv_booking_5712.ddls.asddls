@EndUserText.label: 'Booking - Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZPV_BOOKING_5712
  as projection on ZR_BOOKING_5712
{
  key TravelId,
  key BookingId,
      BookingDate,
      CustomerId,
      CarrierId,
      ConnectionId,
      FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      CurrencyCode,
      BookingStatus,
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,
      /* Associations */
      _Travel            : redirected to parent ZPV_TRAVEL_5712,
      _BookingSupplement : redirected to composition child ZPV_BOOKSUP_5712,
      _Carrier,
      _Connection,
      _Customer

}
