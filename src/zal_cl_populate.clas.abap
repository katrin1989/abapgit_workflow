CLASS zal_cl_populate DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.
PROTECTED SECTION.
PRIVATE SECTION.
ENDCLASS.



CLASS ZAL_CL_POPULATE IMPLEMENTATION.


METHOD if_oo_adt_classrun~main.

DATA: lt_tab TYPE TABLE OF zal_dn_tab.

      lt_tab = VALUE #(

      ( dn_no = '00000000000000000002' dn_de = 'Test Delivery Network with Load Oil' shtxt = 'TEST DELIVERY NETWORK WITH LOAD OIL' cntry_cd = 'US')
      ( dn_no = '00000000000000000005' dn_de = 'PPN Network'                         shtxt = 'PPN NETWORK'                         cntry_cd = 'US')
      ( dn_no = '00000000000000000006' dn_de = 'DN GLG'                              shtxt = 'DN GLG'                              cntry_cd = 'US')
      ( dn_no = '00000000000000000007' dn_de = 'Retrograde Material DN'              shtxt = 'RETROGRADE MATERIAL DN'              cntry_cd = 'US')
      ( dn_no = '00000000000000000008' dn_de = 'RLF Network'                         shtxt = 'RLF NETWORK'                         cntry_cd = 'US')

      ).

INSERT zal_dn_tab FROM TABLE @lt_tab.

ENDMETHOD.
ENDCLASS.
