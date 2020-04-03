@AbapCatalog.sqlViewName: 'ZI_HOLITXT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS View for Public Holidays Text Table'
define view ZCAL_I_HOLITXT
  as select from zcal_holitxt
  association to parent ZCAL_I_HOLIDAY as _PublicHoliday on $projection.holiday_id = _PublicHoliday.holiday_id
{
@UI.facet: [
   {
     id: 'HolidayText',
     label: 'Translation',
     targetQualifier: 'Translation',
     type: #FIELDGROUP_REFERENCE,
     position: 1
   }
 ]
     
  @UI.lineItem: [{ position: 1 }]
  @UI.fieldGroup: [{ position: 1,
                        qualifier: 'Translation',
                        label: 'Language Key'}]
  @Consumption.valueHelpDefinition: [ {entity: {name: 'I_Language', element: 'Language' }} ]                      
  key spras,
  key holiday_id,
  @UI.lineItem: [{ position: 2, label: 'Translation' }]
  @UI.fieldGroup: [{ position: 2,
                        qualifier: 'Translation',
                        label: 'Translated Text' }]
      fcal_description,
      _PublicHoliday
}
