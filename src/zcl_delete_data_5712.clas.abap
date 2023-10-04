CLASS zcl_delete_data_5712 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_delete_data_5712 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    out->write( 'Starting data loading...' ).

    DATA: lt_acc_cat   TYPE TABLE OF ztb_acc_cat_5712,
          lt_catego    TYPE TABLE OF ztb_catego_5712,
          lt_clientes  TYPE TABLE OF ztb_cliente_5712,
          lt_clnts_lib TYPE TABLE OF ztb_cln_lib_5712,
          lt_libros    TYPE TABLE OF ztb_libros_5712.

    DELETE FROM ztb_catego_5712.
    IF sy-subrc EQ 0.
      out->write( | Datos de la tabla Categorias eliminados| ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
