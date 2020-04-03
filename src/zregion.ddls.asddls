@EndUserText.label: 'Root Custom Entity'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_QUERY_REGION'
define root  custom entity ZREGION 
  {
  key RegionID          : abap.int4 ; 
      RegionDescription : abap.char( 50 ) ;
}
