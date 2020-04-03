@AbapCatalog.sqlViewName: 'Z_TABLE_C'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consumption CDS test'


define view Z_TABLE_TEST_C as select from Z_TABLE_TEST {
        key dn_no,
        dn_de
}
