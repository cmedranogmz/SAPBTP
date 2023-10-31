CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Travel RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.

**********************************************************************
* Actions
**********************************************************************

    METHODS acceptTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~acceptTravel RESULT result.

    METHODS rejectTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~rejectTravel RESULT result.

    METHODS createTravelByTemplate FOR MODIFY
      IMPORTING keys FOR ACTION Travel~createTravelByTemplate RESULT result.

**********************************************************************
* Validations
**********************************************************************

    METHODS validateCustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateCustomer.

    METHODS validateDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateDates.

    METHODS validateStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateStatus.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zr_travel_5712
    ENTITY Travel
    FIELDS ( TravelId OverallStatus )
    WITH VALUE #( FOR key_row IN keys ( %key = key_row-%key ) )
    RESULT DATA(lt_travel_result).

    result = VALUE #( FOR ls_travel IN lt_travel_result (
                        %key                 = ls_travel-%key
                        %field-TravelId      = if_abap_behv=>fc-f-read_only
                        %field-OverallStatus = if_abap_behv=>fc-f-read_only
                        %action-acceptTravel = COND #( WHEN ls_travel-OverallStatus = 'A' " A = Accept status
                                                       THEN if_abap_behv=>fc-o-disabled
                                                       ELSE if_abap_behv=>fc-o-enabled )
                        %action-rejectTravel = COND #( WHEN ls_travel-OverallStatus = 'X' " X = Rejected Status
                                                       THEN if_abap_behv=>fc-o-disabled
                                                       ELSE if_abap_behv=>fc-o-enabled  ) ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD acceptTravel.

    MODIFY ENTITIES OF zr_travel_5712 IN LOCAL MODE
    ENTITY Travel
    UPDATE FIELDS ( OverallStatus )
    WITH VALUE #( FOR key_row IN keys ( TravelId      = key_row-TravelId
                                        OverallStatus = 'A' ) ) " A = Accepted status
    FAILED failed
    REPORTED reported.

    READ ENTITIES OF zr_travel_5712
    ENTITY Travel
    FIELDS ( AgencyId
             CustomerId
             BeginDate
             EndDate
             BookingFee
             TotalPrice
             CurrencyCode
             OverallStatus
             Description
             CreatedBy
             CreatedAt
             LastChangedBy
             LastChangedAt )

    WITH VALUE #( FOR key_row_read IN keys ( TravelId = key_row_read-TravelId ) )
    RESULT DATA(lt_travel).

    result = VALUE #( FOR ls_travel IN lt_travel ( TravelId = ls_travel-TravelId
                                                   %param   = ls_travel ) ).

  ENDMETHOD.

  METHOD rejectTravel.

    MODIFY ENTITIES OF zr_travel_5712 IN LOCAL MODE
    ENTITY Travel
    UPDATE FIELDS ( OverallStatus )
    WITH VALUE #( FOR key_row IN keys ( TravelId      = key_row-TravelId
                                        OverallStatus = 'X' ) ) " X = Rejected status
    FAILED failed
    REPORTED reported.

    READ ENTITIES OF zr_travel_5712
    ENTITY Travel
    FIELDS ( AgencyId
             CustomerId
             BeginDate
             EndDate
             BookingFee
             TotalPrice
             CurrencyCode
             OverallStatus
             Description
             CreatedBy
             CreatedAt
             LastChangedBy
             LastChangedAt )

    WITH VALUE #( FOR key_row_read IN keys ( TravelId = key_row_read-TravelId ) )
    RESULT DATA(lt_travel).

    result = VALUE #( FOR ls_travel IN lt_travel ( TravelId = ls_travel-TravelId
                                                   %param   = ls_travel ) ).

  ENDMETHOD.

  METHOD createTravelByTemplate.

*    keys[ 1 ]-%key "Leer clave para la entidad
*    result[ 1 ]-   "Objeto que retorna la salida del metodo
*    mapped         "Estrucutra para mapear los valores a las entidades
*    failed         "Estrucutra para mapear fallos
*    reported       "Estrucutra para reportar fallos atraves de mensajes en capa del consumidor

* Lectura de datos de la entidad Travel - Opcion 1 (Recomendada)
    READ ENTITIES OF zr_travel_5712
    ENTITY Travel
    FIELDS ( TravelId AgencyId CustomerId BookingFee TotalPrice CurrencyCode )
    WITH VALUE #( FOR row_key IN keys ( %key = row_key-%key ) )
    RESULT DATA(lt_entity_travel)
    FAILED failed
    REPORTED reported.

* Lectura de datos de la entidad Travel - Opcion 2
*    READ ENTITY zr_travel_5712
*    FIELDS ( TravelId AgencyId CustomerId BookingFee TotalPrice CurrencyCode )
*    WITH VALUE #( FOR row_key IN keys ( %key = row_key-%key ) )
*    RESULT DATA(lt_entity_travel)
*    FAILED failed
*    REPORTED reported.

    DATA lt_create_travel TYPE TABLE FOR CREATE zr_travel_5712\\Travel.

    DATA(lv_today) = cl_abap_context_info=>get_system_date(  ).

    SELECT MAX( travel_id ) FROM ztb_travel_5712
    INTO @DATA(lv_travel_id).

    lt_create_travel = VALUE #( FOR create_row IN lt_entity_travel INDEX INTO idx
                                    ( TravelId      = lv_travel_id + idx
                                      AgencyId      = create_row-AgencyId
                                      CustomerId    = create_row-CustomerId
                                      BeginDate     = lv_today
                                      EndDate     = lv_today + 30
                                      BookingFee    = create_row-BookingFee
                                      TotalPrice    = create_row-TotalPrice
                                      CurrencyCode  = create_row-CurrencyCode
                                      Description   = 'Add coments...'
                                      OverallStatus = 'O' ) ). "O - Open status

    MODIFY ENTITIES OF zr_travel_5712
    IN LOCAL MODE ENTITY Travel
    CREATE FIELDS ( TravelID
                    AgencyId
                    CustomerId
                    BeginDate
                    EndDate
                    BookingFee
                    TotalPrice
                    CurrencyCode
                    Description
                    OverallStatus )
   WITH lt_create_travel
   MAPPED mapped
   FAILED failed
   REPORTED reported.

    result = VALUE #( FOR result_row IN lt_create_travel INDEX INTO idx
                         ( %cid_ref = keys[ idx ]-%cid_ref
                           %key     = keys[ idx ]-%key
                           %param   = CORRESPONDING #( result_row ) ) ).

  ENDMETHOD.

  METHOD validateCustomer.

    READ ENTITIES OF zr_travel_5712 IN LOCAL MODE
    ENTITY Travel
    FIELDS ( CustomerId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

    DATA lt_customer TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.

*    lt_customer = CORRESPONDING #( lt_travel )

  ENDMETHOD.

  METHOD validateDates.
  ENDMETHOD.

  METHOD validateStatus.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZR_TRAVEL_5712 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZR_TRAVEL_5712 IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
