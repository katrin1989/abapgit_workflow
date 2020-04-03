@AbapCatalog.sqlViewName: 'ZCAL_IHOLIDAY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS view for public holiday'
define root view ZCAL_I_HOLIDAY 
    as select from zcal_holiday 
    composition [0..*] of ZCAL_I_HOLITXT as _HolidayTxt
    association [0..1] to ZCAL_I_HOLITXT as _DefaultText
               on  _DefaultText.holiday_id = $projection.holiday_id
               and _DefaultText.spras      = $session.system_language
{
    //ZCAL_HOLIDAY
     @UI.facet: [
         {
           id: 'PublicHoliday',
           label: 'Public Holiday',
           type: #COLLECTION,
           position: 1
         },
         {
           id: 'General',
           parentId: 'PublicHoliday',
           label: 'General Data',
           type: #FIELDGROUP_REFERENCE,
           targetQualifier: 'General',
           position: 1
         },
         {
           id: 'Translation',
           label: 'Translation',
           type: #LINEITEM_REFERENCE,
           position: 3,
           targetElement: '_HolidayTxt'
         }]
         
    @UI.fieldGroup: [ { qualifier: 'General', position: 1 } ]
    @UI.lineItem:   [ { position: 1 } ]     
    //@Semantics.user.createdBy: true
    key holiday_id,
    @UI.fieldGroup: [ { qualifier: 'General', position: 2 } ]
    @UI.lineItem:   [ { position: 2 } ]
    //@Semantics.user.lastChangedBy: true
    month_of_holiday,
    @UI.fieldGroup: [ { qualifier: 'General', position: 3 } ]
    @UI.lineItem:   [ { position: 3 } ]
    //@Semantics.systemDateTime.createdAt: true
    day_of_holiday,
    @UI.fieldGroup: [ { qualifier: 'General',
                    position: 4,
                    label: 'Description' } ]
    @UI.lineItem:   [ { position: 4, label: 'Description' } ]
    _DefaultText.fcal_description as HolidayDescription,
    @UI.lineItem: [ { position: 4, label: 'International holiday'} ,
                    { type: #FOR_ACTION, dataAction: 'external_hol', label: 'International holiday' } ]
  //  @UI.identification: [ { position: 4, label: 'Status [X(Yes)|(No)]' } ]                 
    external_hol,
    @Semantics.systemDateTime.lastChangedAt: true
    changedat,
    _HolidayTxt,
    _DefaultText
}
