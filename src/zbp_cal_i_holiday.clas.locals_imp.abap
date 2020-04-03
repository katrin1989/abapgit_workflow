CLASS lhc_holidaytext DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.


    METHODS set_status_external        FOR MODIFY IMPORTING   keys FOR ACTION HolidayRoot~external_hol            RESULT result.
    METHODS get_features               FOR FEATURES IMPORTING keys REQUEST    requested_features FOR HolidayRoot  RESULT result.

ENDCLASS.

CLASS lhc_holidaytext IMPLEMENTATION.



********************************************************************************
*
* Implements action (in our case: change flag to YES)
*
********************************************************************************
METHOD set_status_external.

" Modify in local mode: BO-related updates that are not relevant for authorization checks
MODIFY ENTITIES OF ZCAL_I_HOLIDAY IN LOCAL MODE
       ENTITY HolidayRoot
          UPDATE FROM VALUE #( for key in keys ( holiday_id = key-holiday_id
                                                 external_hol = 'X' " YES
                                                 %control-external_hol = if_abap_behv=>mk-on ) )
       FAILED   failed
       REPORTED reported.

  " Read changed data for action result
  READ ENTITIES OF ZCAL_I_HOLIDAY IN LOCAL MODE
       ENTITY HolidayRoot
       FROM VALUE #( for key in keys (  holiday_id = key-holiday_id
                                        %control = VALUE #(

                                          month_of_holiday  = if_abap_behv=>mk-on
                                          day_of_holiday    = if_abap_behv=>mk-on
                                          external_hol      = if_abap_behv=>mk-on
                                          changedat         = if_abap_behv=>mk-on
                                      ) ) )
       RESULT DATA(lt_hol).

  result = VALUE #( for HolidayRoot in lt_hol ( holiday_id = HolidayRoot-holiday_id
                                              %param       = HolidayRoot
                                            ) ).

ENDMETHOD.

*******************************************************************************

* Implements the dynamic feature handling for travel instances

*******************************************************************************
METHOD get_features.

READ ENTITY ZCAL_I_HOLIDAY FROM VALUE #( FOR keyval IN keys
                                                  (  %key                    = keyval-%key
                                                     %control-holiday_id     = if_abap_behv=>mk-on
                                                     %control-external_hol   = if_abap_behv=>mk-on ) )
                            RESULT DATA(lt_holiday_result).


 result = VALUE #( FOR ls_hol IN lt_holiday_result
                   ( %key                           = ls_hol-%key
                     %features-%action-external_hol = COND #( WHEN ls_hol-external_hol = 'X'
                                                                THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled   )
                  ) ).

ENDMETHOD.


ENDCLASS.




CLASS lhc_HolidayRoot  DEFINITION INHERITING
  FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS det_create_and_change_texts
      FOR DETERMINATION HolidayRoot~det_create_and_change_texts
      IMPORTING keys FOR HolidayRoot.

    METHODS create_description
      IMPORTING
        i_holiday_id  TYPE zcal_holiday_id
        i_description TYPE zcal_description.

    METHODS update_description
      IMPORTING
        i_holiday_id  TYPE zcal_holiday_id
        i_description TYPE zcal_description.

ENDCLASS.

CLASS lhc_HolidayRoot IMPLEMENTATION.

  METHOD det_create_and_change_texts.

    READ ENTITIES OF zcal_i_holiday
      ENTITY HolidayRoot
      FROM VALUE #( FOR <root_key> IN keys ( %key = <root_key> ) )
      RESULT DATA(public_holidays_table).


    LOOP AT public_holidays_table INTO DATA(public_holiday).
      READ ENTITIES OF zcal_i_holiday
        ENTITY HolidayRoot BY \_HolidayTxt
        FROM VALUE #( ( %key = public_holiday-%key ) )
        RESULT DATA(description_table).
      IF line_exists( description_table[
                        spras      = sy-langu
                        holiday_id = public_holiday-holiday_id ] ).
        update_description(
          i_holiday_id  = public_holiday-holiday_id
          i_description = public_holiday-HolidayDescription ).

      ELSE.
        create_description(
          i_holiday_id  = public_holiday-holiday_id
          i_description = public_holiday-HolidayDescription ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD create_description.
    DATA:
      description_table TYPE TABLE FOR CREATE zcal_i_holiday\_HolidayTxt,
      description       TYPE STRUCTURE FOR CREATE zcal_i_holiday\_HolidayTxt.

    description-%key    = i_holiday_id.
    description-%target =
      VALUE #(
               ( holiday_id       = i_holiday_id
                 spras            = sy-langu
                 fcal_description = i_description
                 %control = VALUE
                            #( holiday_id       = cl_abap_behv=>flag_changed
                               spras            = cl_abap_behv=>flag_changed
                               fcal_description = cl_abap_behv=>flag_changed
                             )
               )
             ).

    APPEND description TO description_table.

    MODIFY ENTITIES OF zcal_i_holiday IN LOCAL MODE
      ENTITY HolidayRoot CREATE BY \_HolidayTxt FROM description_table.
  ENDMETHOD.

  METHOD update_description.
    DATA:
      description_table TYPE TABLE FOR UPDATE zcal_i_holitxt,
      description       TYPE STRUCTURE FOR UPDATE zcal_i_holitxt.

    description-holiday_id       = i_holiday_id.
    description-spras            = sy-langu.
    description-fcal_description = i_description.

    description-%control-fcal_description = cl_abap_behv=>flag_changed.
    APPEND description TO description_table.

    MODIFY ENTITIES OF zcal_i_holiday IN LOCAL MODE
      ENTITY HolidayText UPDATE FROM description_table.
  ENDMETHOD.

ENDCLASS.


CLASS lcl_saver DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS save_modified REDEFINITION.
ENDCLASS.

CLASS lcl_saver IMPLEMENTATION.
 METHOD save_modified.

  DATA(all_root_keys) = create-HolidayRoot.

  APPEND LINES OF update-HolidayRoot TO all_root_keys.
  APPEND LINES OF delete-HolidayRoot TO all_root_keys.

  DATA(all_text_keys) = create-HolidayText.
  APPEND LINES OF update-holidaytext TO all_text_keys.
  APPEND LINES OF delete-holidaytext TO all_text_keys.


ENDMETHOD.
ENDCLASS.
