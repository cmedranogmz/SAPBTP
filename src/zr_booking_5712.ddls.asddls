@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking - View'
define view entity ZR_BOOKING_5712
  as select from ztb_booking_5712 as Booking
  composition [0..*] of ZR_BOOKSUP_5712   as _BookingSupplement
  association        to parent zr_travel_5712    as _Travel on $projection.TravelId = _Travel.TravelId
  association [1..1] to /DMO/I_Customer   as _Customer      on $projection.CustomerId = _Customer.CustomerID
  association [1..1] to /DMO/I_Carrier    as _Carrier       on $projection.CarrierId = _Carrier.AirlineID
  association [1..*] to /DMO/I_Connection as _Connection    on $projection.ConnectionId = _Connection.ConnectionID
{
  key travel_id       as TravelId,
  key booking_id      as BookingId,
      booking_date    as BookingDate,
      customer_id     as CustomerId,
      @ObjectModel.text.element: [ 'CarrierName' ]
      carrier_id      as CarrierId,
      _Carrier.Name   as CarrierName,
      connection_id   as ConnectionId,
      flight_date     as FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      flight_price    as FlightPrice,
      currency_code   as CurrencyCode,
      booking_status  as BookingStatus,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,
      _Travel,
      _BookingSupplement,
      _Customer,
      _Carrier,
      _Connection
}
