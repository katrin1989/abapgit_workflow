CLASS zcl_query_demo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

PUBLIC SECTION.
INTERFACES if_rap_query_provider.
PROTECTED SECTION.
PRIVATE SECTION.
ENDCLASS.



CLASS zcl_query_demo IMPLEMENTATION.
method  if_rap_query_provider~select.
TRY.
    DATA(lo_destination) = cl_http_destination_provider=>create_by_cloud_destination(
               i_name                  = |E89_HTTP|
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
          iv_service_definition_name = 'ZDEMO_ONPREM'
          io_http_client = lo_http_client
          iv_relative_service_root = '/sap/opu/odata/sap/ZTST_I_PARTNER_CDS' ).

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

    DATA(lo_request) = lo_client_proxy->create_resource_for_entity_set('ZTST_I_PARTNER')->create_request_for_read( ).

      DATA lt_owner        TYPE STANDARD TABLE OF  zztst_i_partner.
      DATA lt_owner_fact   TYPE STANDARD TABLE OF  zoiu_prtn.

         DATA(ls_paging) = io_request->get_paging( ).
          IF ls_paging->get_offset( ) >= 0.
            lo_request->set_skip( ls_paging->get_offset( ) ).
          ENDIF.
          IF ls_paging->get_page_size( ) <> if_rap_query_paging=>page_size_unlimited.
            lo_request->set_top( ls_paging->get_page_size( ) ).
          ENDIF.

         DATA(lo_response) = lo_request->execute( ).
         lo_response->get_business_data( IMPORTING et_business_data = lt_owner ).
         DELETE lt_owner WHERE type = '2'.

    MOVE-CORRESPONDING lt_owner TO lt_owner_fact.

    data(lco_destination) = cl_http_destination_provider=>create_by_cloud_destination(
               i_name                  = |NW|
               i_service_instance_name = |ArrangmentYBPaaS|
               i_authn_mode            = if_a4c_cp_service=>service_specific
           ).
    data(lco_http_client) = cl_web_http_client_manager=>create_by_http_destination( lco_destination ) .
    data(lco_client_proxy) = cl_web_odata_client_factory=>create_v2_remote_proxy(
          iv_service_definition_name = 'ZNW_REGIONS'
          io_http_client = lco_http_client
          iv_relative_service_root = '/V3/Northwind/Northwind.svc/' ).


   TRY.
    " Set entity key
    DATA ls_entity_key     TYPE ZREGIONS.
    DATA ls_reg        TYPE     ZREGIONS.

    ls_entity_key = value #(   regionid = '1' ).

    " Navigate to the resource
      data(lo_resource) = lco_client_proxy->create_resource_for_entity_set( 'REGIONS' )->navigate_with_key( ls_entity_key ).
      data(lco_response) = lo_resource->create_request_for_read( )->execute( ).

      lco_response->get_business_data( IMPORTING es_business_data = ls_reg ).
    ENDTRY.

    TRY.
        DATA(lo_rfc_dest) = cl_rfc_destination_provider=>create_by_cloud_destination(
                               i_name = |E89_RFC|
                               i_service_instance_name = |ArrangmentYBPaaS| ).
        DATA(lv_rfc_dest_name) = lo_rfc_dest->get_destination_name( ).
        DATA lv_persnumber TYPE c LENGTH 10.
      "RFC Call
      LOOP AT lt_owner_fact ASSIGNING FIELD-SYMBOL(<fs>).
        CALL   FUNCTION 'ZYB_PRTN_GETDETAIL'
        DESTINATION lv_rfc_dest_name
        EXPORTING iv_partner = <fs>-partner
        IMPORTING ev_persnumber = <fs>-persnumber
         EXCEPTIONS
            system_failure        = 1
            communication_failure = 2
            OTHERS                = 3.
      <fs>-country = ls_reg-RegionDescription.
      ENDLOOP.

        CATCH cx_rfc_dest_provider_error INTO DATA(lx_dest).
      ENDTRY.


         io_response->set_total_number_of_records( lines( lt_owner_fact ) ).
         io_response->set_data( lt_owner_fact ).


        CATCH /iwbep/cx_gateway INTO lx_gateway.
          RAISE EXCEPTION TYPE cx_a4c_rap_query_provider
            EXPORTING
              previous = lx_gateway.
      ENDTRY.

ENDMETHOD.
ENDCLASS.
