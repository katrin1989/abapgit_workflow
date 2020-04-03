class ZCL_TEST_DESTINATION_RFC definition
  public
  final
  create public .

public section.
interfaces:
  if_oo_adt_classrun.
protected section.
private section.
ENDCLASS.



CLASS ZCL_TEST_DESTINATION_RFC IMPLEMENTATION.

METHOD if_oo_adt_classrun~main.
 TRY.
        DATA(lo_rfc_dest) = cl_rfc_destination_provider=>create_by_cloud_destination(
                               i_name = |E89_RFC|
                               i_service_instance_name = |ArrangmentYBPaaS| ).
        DATA(lv_rfc_dest) = lo_rfc_dest->get_destination_name( ).
        data lv_persnumber type c length 10.
        DATA msg TYPE c LENGTH 255.
        "RFC Call
      "  DATA lv_result TYPE c LENGTH 200.
      call   function 'ZYB_PRTN_GETDETAIL'
        DESTINATION lv_rfc_dest
        exporting IV_PARTNER = '0000000003'
        importing EV_PERSNUMBER = lv_persnumber
         EXCEPTIONS
            system_failure        = 1 MESSAGE msg
            communication_failure = 2 MESSAGE msg
            OTHERS                = 3.

       " CALL FUNCTION 'RFC_SYSTEM_INFO' DESTINATION lv_rfc_dest
     "     IMPORTING
      "      rfcsi_export          = lv_result
      "    EXCEPTIONS
       "     system_failure        = 1 MESSAGE msg
       "     communication_failure = 2 MESSAGE msg
        "    OTHERS                = 3.

        CASE sy-subrc.
          WHEN 0.
            out->write( lv_persnumber ).
          WHEN 1.
            out->write( |EXCEPTION SYSTEM_FAILURE | && msg ).
          WHEN 2.
            out->write( |EXCEPTION COMMUNICATION_FAILURE | && msg ).
          WHEN 3.
            out->write( |EXCEPTION OTHERS| ).
        ENDCASE.

      CATCH cx_root INTO DATA(lx_root).
        out->write( lx_root->get_text( ) ).
    ENDTRY.
endmethod.
ENDCLASS.
