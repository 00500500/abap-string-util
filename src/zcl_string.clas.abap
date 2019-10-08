CLASS zcl_string DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! append to sting
    METHODS append
      IMPORTING
        i_value TYPE string.
    "! add single quotes
    METHODS add_single_quotes.
    "! clear
    METHODS clear .
    "! normal constructor
    METHODS constructor
      IMPORTING
        !i_value TYPE clike .
    "! Determines if the string ends with a character sequence
    METHODS ends_with
      IMPORTING
        !i_pattern      TYPE clike
        !i_ignore_case  TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(r_result) TYPE abap_bool .
    "! Returns the string
    METHODS get_value
      RETURNING
        VALUE(r_string) TYPE string .
    "! <p class="shorttext synchronized" lang="en">Create a string instance from a structure</p>
    "!
    "! @parameter ig_structure | <p class="shorttext synchronized" lang="en">Any Structure</p>
    "! @parameter ro_string    | <p class="shorttext synchronized" lang="en">Class to Represent Character Strings</p>
    "! create string from structure
    CLASS-METHODS create_from_structure
      IMPORTING
        VALUE(ig_structure) TYPE any
      RETURNING
        VALUE(ro_string)    TYPE REF TO zcl_string .
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: m_string TYPE string.


ENDCLASS.



CLASS zcl_string IMPLEMENTATION.

  METHOD clear.

    CLEAR m_string.

  ENDMETHOD.

  METHOD constructor.

    m_string = i_value.

  ENDMETHOD.

  METHOD ends_with.

    DATA: lo_regex   TYPE REF TO cl_abap_regex,
          lo_matcher TYPE REF TO cl_abap_matcher.

    IF m_string IS INITIAL.
      r_result = abap_false.
      RETURN.
    ENDIF.

    TRY.

        CREATE OBJECT lo_regex
          EXPORTING
            pattern     = |^.*{ i_pattern }$|
            ignore_case = i_ignore_case.

        lo_matcher = lo_regex->create_matcher( text = m_string ).

        r_result = lo_matcher->match( ).
      CATCH cx_sy_regex.
        r_result = abap_false.
      CATCH cx_sy_matcher.
        r_result = abap_false.
    ENDTRY.


  ENDMETHOD.

  METHOD get_value.

    r_string = m_string.

  ENDMETHOD.

  METHOD create_from_structure.

    FIELD-SYMBOLS: <lg_char> TYPE any.

    cl_abap_container_utilities=>fill_container_c(
      EXPORTING
        im_value               = ig_structure     " Data for Filling Container
      IMPORTING
        ex_container           = DATA(l_csquence)     " Container
      EXCEPTIONS
        illegal_parameter_type = 1
        OTHERS                 = 2
    ).
    IF sy-subrc NE 0.
      CLEAR l_csquence.
    ENDIF.

    ro_string = NEW zcl_string( l_csquence ).

  ENDMETHOD.

  METHOD add_single_quotes.

    m_string = |'{ m_string }'|.

  ENDMETHOD.

  METHOD append.

    m_string = |{ m_string }{ i_value }|.

  ENDMETHOD.

ENDCLASS.
