CLASS zcl_ext_update_entity_5712 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ext_update_entity_5712 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

   out->write( 'Commit Entity is running...' ).

    MODIFY ENTITIES OF zr_travel_5712
        ENTITY Travel
        UPDATE FIELDS ( AgencyId Description )
        WITH VALUE #( ( TravelId = '00000001'
                        AgencyId = '070041'
                        Description = 'New external update: ' + cl_abap_context_info=>get_system_date( ) ) )
        FAILED DATA(failed)
        REPORTED DATA(reported).

    READ ENTITIES OF zr_travel_5712
        ENTITY Travel
        FIELDS ( AgencyId Description )
        WITH VALUE #( ( TravelId = '00000001' ) )
        RESULT DATA(lt_travel_data)
        FAILED failed
        REPORTED reported.

    COMMIT ENTITIES.

    IF failed IS INITIAL.
      out->write( 'Commit entity successfull' ).
    ELSE.
      out->write( 'Commit entity failed' ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
