using { sap.btp.einvoice as db } from '../db/schema';

@path: '/odata/v4/clearance'
service ClearanceService {

  @odata.draft.enabled: false
  @title: 'Billing Clearance Logs'
  entity BillingClearanceLogs as projection on db.BillingClearanceLogs
    actions {
      @title: 'Re-Submit for Clearance'
      @Common.SideEffects: { TargetEntities: ['_it', '_it/errors'] }
      action reSubmit() returns BillingClearanceLogs;
    };

  @title: 'Tax Validation Errors'
  entity TaxValidationErrors as projection on db.TaxValidationErrors;
}
