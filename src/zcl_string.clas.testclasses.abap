*"* use this source file for your ABAP unit test classes
CLASS lct_string DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    METHODS:
      append FOR TESTING RAISING cx_static_check,
      add_single_quotes FOR TESTING RAISING cx_static_check,
      ends_with FOR TESTING RAISING cx_static_check,
      create_string_from_struc FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS lct_string IMPLEMENTATION.

  METHOD append.

    DATA(lo_cut) = NEW zcl_string( `Test` ).
    lo_cut->append( '%' ).

    cl_abap_unit_assert=>assert_equals( act = lo_cut->get_value(  )
                                        exp = `Test%` ).

  ENDMETHOD.

  METHOD create_string_from_struc.

    DATA(lo_cut) = NEW zcl_string( 'SD_VBAK   X' ).

    cl_abap_unit_assert=>assert_equals( act = zcl_string=>create_from_structure( VALUE zcl_are_cache=>gtys_are_param( archive_object = 'SD_VBAK'
                                                                                                                      test_run = abap_true ) )->get_value( )
                                        exp = lo_cut->get_value( ) ).

  ENDMETHOD.

  METHOD ends_with.

    DATA(lo_cut) = NEW zcl_string( `Test` ).

    cl_abap_unit_assert=>assert_true( act = lo_cut->ends_with( 't' ) ).

  ENDMETHOD.

  METHOD add_single_quotes.

    DATA(lo_cut) = NEW zcl_string( `Test` ).
    lo_cut->add_single_quotes( ).

    cl_abap_unit_assert=>assert_equals( act = lo_cut->get_value( )
                                        exp = |'Test'| ).

  ENDMETHOD.

ENDCLASS.
