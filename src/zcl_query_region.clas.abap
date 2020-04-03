CLASS zcl_query_region DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

PUBLIC SECTION.
INTERFACES if_rap_query_provider.
*INTERFACES IF_A4C_RAP_QUERY_PROVIDER.
PROTECTED SECTION.
PRIVATE SECTION.
ENDCLASS.


CLASS zcl_query_region IMPLEMENTATION.


 METHOD if_rap_query_provider~select.

TRY.
    DATA(lo_destination) = cl_http_destination_provider=>create_by_cloud_destination(
               i_name                  = |NW|
               i_service_instance_name = |ArrangmentYBPaaS|
               i_authn_mode            = if_a4c_cp_service=>service_specific
           ).

    DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ) .
          " Error handling

        CATCH cx_http_dest_provider_error INTO DATA(lx_http_dest_provider_error).
          RAISE EXCEPTION TYPE cx_a4c_rap_query_provider
            EXPORTING
              previous = lx_http_dest_provider_error.
        CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
          RAISE EXCEPTION TYPE cx_a4c_rap_query_provider
            EXPORTING
              previous = lx_web_http_client_error.
 ENDTRY.
 TRY.
       DATA(lo_client_proxy) = cl_web_odata_client_factory=>create_v2_remote_proxy(
          iv_service_definition_name = 'ZNW_REGIONS'
          io_http_client = lo_http_client
          iv_relative_service_root = '/V3/Northwind/Northwind.svc/' ).

        CATCH cx_web_http_client_error INTO lx_web_http_client_error.
          RAISE EXCEPTION TYPE cx_a4c_rap_query_provider
            EXPORTING
              previous = lx_web_http_client_error.

        CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
          RAISE EXCEPTION TYPE cx_a4c_rap_query_provider
            EXPORTING
              previous = lx_gateway.

 ENDTRY.
 TRY.
    " Set entity key
    data     ls_entity_key     TYPE ZREGIONS.
    ls_entity_key = value #(   regionid = '1' ).

    " Navigate to the resource
      DATA(lo_request) = lo_client_proxy->create_resource_for_entity_set('REGIONS(`1`)')->create_request_for_read( ).

         DATA lt_reg        TYPE  STANDARD TABLE OF   ZREGIONS.
         DATA(ls_paging) = io_request->get_paging( ).
         IF ls_paging->get_offset( ) >= 0.
           lo_request->set_skip( ls_paging->get_offset( ) ).
         ENDIF.
         IF ls_paging->get_page_size( ) <> if_rap_query_paging=>page_size_unlimited.
            lo_request->set_top( ls_paging->get_page_size( ) ).
         ENDIF.

        DATA(lo_response) = lo_request->execute( ).
        lo_response->get_business_data( IMPORTING et_business_data = lt_reg ).
         " io_response->set_total_number_of_records( lines( lt_reg ) ).
        "  io_response->set_data( lt_reg ).


        CATCH /iwbep/cx_gateway INTO lx_gateway.
          RAISE EXCEPTION TYPE cx_a4c_rap_query_provider
            EXPORTING
              previous = lx_gateway.
      ENDTRY.
ENDMETHOD.
ENDCLASS.
