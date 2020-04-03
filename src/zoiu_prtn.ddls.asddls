@EndUserText.label: 'Partners'
//@QueryImplementedBy: 'ZCL_QUERY_PRTN'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_QUERY_DEMO'


define root custom entity zoiu_prtn{

@UI.facet     : [
        {
          id        :    'Partner',
          purpose   :     #STANDARD,
          type      :     #IDENTIFICATION_REFERENCE,
          label     :    'Partners',
          position  : 10 }
      ]
@UI           : {
      lineItem      : [{label: 'Partner Number',position: 10, importance: #HIGH}],
      identification: [{label: 'Partner Number',position: 10}],
      selectionField: [{ position: 10}]
      }      
 
 key partner : abap.char( 10 ) ; 
 @UI           : {
      lineItem      : [{label: 'Partner Type',position: 20, importance: #HIGH}],
      identification: [{label: 'Partner Type',position: 20}]
       }
 type : abap.char( 1 ) ; 
 @UI           : {
      lineItem      : [{label: 'First Name', position: 40, importance: #HIGH}],
      identification: [{label: 'First Name', position: 40}] }
 name_first : abap.char( 40 ) ; 
 @UI           : {
      lineItem      : [{label: 'Last Name' , position: 50, importance: #HIGH}],
      identification: [{label: 'Last Name', position: 50}] }
 name_last : abap.char( 40 ) ; 
 @UI           : {
      lineItem      : [{label: 'PersNumber' , position: 60, importance: #HIGH}],
      identification: [{label: 'PersNumber', position: 60}] }
 persnumber: abap.char( 10 );
   @UI           : {
      lineItem      : [{label: 'Country' , position: 70, importance: #HIGH}],
      identification: [{label: 'Country',  position: 70}] }
 country: abap.char( 20 );
 
 
}
//@ObjectModel.query.implementedBy: 'ABAP:ZCL_QUERY_PRTN'
