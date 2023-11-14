CLASS lhc_Booking DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculateTotalFlightPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Booking~calculateTotalFlightPrice.

    METHODS calculateTotalSupplPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Booking~calculateTotalSupplPrice.

    METHODS validateStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR Booking~validateStatus.

ENDCLASS.

CLASS lhc_Booking IMPLEMENTATION.

  METHOD calculateTotalFlightPrice.

    IF NOT keys IS INITIAL.
      zcl_aux_travel_det_5712=>calculate_price( it_travel_id = VALUE #( FOR GROUPS <booling> OF booking_key IN keys
                                                                        GROUP BY booking_key-TravelId WITHOUT MEMBERS ( <booling> ) ) ).
    ENDIF.

  ENDMETHOD.

  METHOD calculateTotalSupplPrice.

    IF NOT keys IS INITIAL.
      zcl_aux_travel_det_5712=>calculate_price( it_travel_id = VALUE #( FOR GROUPS <booling_suppl> OF booking_key IN keys
                                                                        GROUP BY booking_key-TravelId WITHOUT MEMBERS ( <booling_suppl> ) ) ).
    ENDIF.

  ENDMETHOD.

  METHOD validateStatus.

    READ ENTITY zr_travel_5712\\Booking
        FIELDS ( BookingStatus )
        WITH VALUE #( FOR <row_key> IN keys ( %key = <row_key>-%key ) )
        RESULT DATA(lt_booking_result).

    LOOP AT lt_booking_result INTO DATA(ls_booking_result).

      CASE ls_booking_result-BookingStatus.
        WHEN 'N'. "New

        WHEN 'X'. "Cancelled

        WHEN 'B'. " Booked

        WHEN OTHERS.

          APPEND VALUE #( %key = ls_booking_result-%key ) TO failed-booking.

          APPEND VALUE #( %key = ls_booking_result-%key
                          %msg = new_message( id       = 'ZMC_TRAVEL_5712'
                                              number   = '007'
                                              v1       = ls_booking_result-BookingId
                                              severity = if_abap_behv_message=>severity-error )
                          %element-bookingStatus = if_abap_behv=>mk-on ) TO reported-booking.

      ENDCASE.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
