CLASS zcl_test_destination DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
PUBLIC SECTION.
INTERFACES:
  if_oo_adt_classrun.
PROTECTED SECTION.
PRIVATE SECTION.
ENDCLASS.



CLASS zcl_test_destination IMPLEMENTATION.


METHOD if_oo_adt_classrun~main.

 TRY.
          DATA(lo_destination) = cl_http_destination_provider=>create_by_cloud_destination(
               i_name                  = |E89_HTTP|
               i_service_instance_name = |ArrangmentYBPaaS|
               i_authn_mode            = if_a4c_cp_service=>service_specific
           ).
    DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ) .
  ENDTRY.
  TRY.
        DATA(lo_client_proxy) = cl_web_odata_client_factory=>create_v2_remote_proxy(
                            iv_service_definition_name = 'ZPRTN'
                            io_http_client = lo_http_client
                            iv_relative_service_root = '/sap/opu/odata/sap/ZTST_C_PARTNER_CDS' ).

        DATA(lo_request) =
            lo_client_proxy->create_resource_for_entity_set('ZTST_C_PARTNER')->create_request_for_read( ).


        DATA lt_owner   TYPE STANDARD TABLE OF  zztst_c_partner6f56404372.

        DATA(lo_response) = lo_request->execute( ).
        lo_response->get_business_data( IMPORTING et_business_data = lt_owner ).

        TRY.
        DATA(lo_rfc_dest) = cl_rfc_destination_provider=>create_by_cloud_destination(
                               i_name = |E89_RFC|
                               i_service_instance_name = |ArrangmentYBPaaS| ).
          DATA(lv_rfc_dest_name) = lo_rfc_dest->get_destination_name( ).
        CATCH cx_rfc_dest_provider_error INTO DATA(lx_dest).
      ENDTRY.
      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
          RAISE EXCEPTION TYPE cx_a4c_rap_query_provider
            EXPORTING
              previous = lx_gateway.
      ENDTRY.
ENDMETHOD.
ENDCLASS.
