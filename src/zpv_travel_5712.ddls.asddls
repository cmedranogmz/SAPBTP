@EndUserText.label: 'Travel - Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZPV_TRAVEL_5712
  provider contract transactional_query
  as projection on zr_travel_5712
{
  key TravelId,
      @ObjectModel.text.element: [ 'AgencyName' ]
      AgencyId,
      _Agency.Name       as AgencyName,
      @ObjectModel.text.element: [ 'CustomerName' ]
      CustomerId,
      _Customer.LastName as CustomerName,
      BeginDate,
      EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalPrice,
      CurrencyCode,
      Description,
      OverallStatus      as TravelStatus,
      @Semantics.user.createdBy: true
      CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      CreatedAt,
      @Semantics.user.lastChangedBy: true
      LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_VIRTUAL_ELEMENT_5712'
      virtual DiscountPrice : /dmo/total_price,
      /* Associations */
      _Agency,
      _Booking : redirected to composition child ZPV_BOOKING_5712,
      _Currency,
      _Customer
}
