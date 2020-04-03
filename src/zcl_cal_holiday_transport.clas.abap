CLASS zcl_cal_holiday_transport DEFINITION  PUBLIC  FINAL  CREATE PUBLIC .
  PUBLIC SECTION.
    TYPES:
      tt_holiday    TYPE TABLE OF zcal_holiday
                         WITH NON-UNIQUE DEFAULT KEY,
      tt_holidaytxt TYPE TABLE OF zcal_holitxt
                         WITH NON-UNIQUE DEFAULT KEY.

    METHODS:
      constructor .



  PROTECTED SECTION.
    DATA: transport_api TYPE REF TO if_a4c_bc_handler.

ENDCLASS.

CLASS ZCL_CAL_HOLIDAY_TRANSPORT IMPLEMENTATION.


  METHOD constructor.
    me->transport_api = cl_a4c_bc_factory=>get_handler( ).
  ENDMETHOD.


ENDCLASS.
