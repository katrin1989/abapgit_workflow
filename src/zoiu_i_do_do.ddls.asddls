@AbapCatalog.sqlViewName: 'ZOIUIDO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'DOI  Items'
define root view zoiu_i_do_do as select from zoiu_do_do  
association [0..*] to zoiu_do_bguc    as BG         on     BG.bg_no         = $projection.bg_no
association [0..*] to zoiu_do_dohead  as DOIHead    on     DOIHead.doi_no   = $projection.doi_no
//ssociation [0..1] to zoiu_prtn       as Owner      on     Owner.partner    = $projection.own_no

                             
{
  key vname         ,
  key doi_no        ,
  key own_no        ,
  eff_to_dt         ,     
  do_no             ,
  jib_offs_fl       ,
  nri_pc            ,
  susp_cd           ,
  tax_free_cd       ,
  bg_no             ,
  pyout_cd          ,
  pay_cd            ,
  entl_cd           ,
  ssc_fl            ,
  mms_pop_comp_fl   ,
  dual_acct_fl      ,
  enty_cd           ,
  acct_ent_fl       ,
  int_cat_cd        ,
  min_roy_dt        ,
  do_curr           ,
  min_roy_am        ,
  adv_arrs_cd       ,
  carr_bg_cd        ,
  lse_use_pmt_cd    ,
  jib_partn         ,
  pp_kunnr          ,
  mms_recon_fl      ,
  BG                ,
  DOIHead          
 // Owner
   
}
