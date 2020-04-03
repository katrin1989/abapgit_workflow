@AbapCatalog.sqlViewName: 'Z_TABLE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Test_CDS'
define view Z_TABLE_TEST as select from zal_dn_tab {
    key dn_no,
        dn_de
}
