CLASS zcl_fm_call DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.
PROTECTED SECTION.
PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FM_CALL IMPLEMENTATION.


METHOD if_oo_adt_classrun~main.

DATA: lt_partners TYPE zoiu_partner_t.
      "lt_but      TYPE STANDARD TABLE OF but000.
      "lt_adrc     TYPE STANDARD TABLE OF adrc.

DATA(lo_destination) = cl_rfc_destination_provider=>create_by_cloud_destination(
                       i_service_instance_name = 'SAP_PRA_OWNER_TEST'
                       i_name                  = 'E89_KU_RFC'
                       ).

DATA(lv_destination) = lo_destination->get_destination_name( ).

CALL FUNCTION 'ZPRA_FM_OWNER_GET'
DESTINATION lv_destination
   EXPORTING
    it_partners            = lt_partners.

ENDMETHOD.
ENDCLASS.
