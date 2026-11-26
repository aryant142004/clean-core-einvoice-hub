using ClearanceService as service from '../../srv/clearance-service';

annotate service.BillingClearanceLogs with @(
  UI.HeaderInfo: {
    TypeName      : 'e-Invoice Clearance Log',
    TypeNamePlural: 'e-Invoice Clearance Logs',
    Title         : { Value: billingDocument },
    Description   : { Value: clearanceStatus }
  },
  UI.SelectionFields: [
    billingDocument,
    clearanceStatus,
    companyCode,
    customerGSTIN
  ],
  UI.LineItem: [
    { $Type: 'UI.DataFieldForAction', Action: 'ClearanceService.reSubmit', Label: 'Re-Submit for Clearance', Determining: false },
    { Value: billingDocument, Label: 'Billing Document' },
    { Value: clearanceStatus, Label: 'Status', Criticality: statusCriticality, CriticalityRepresentation: #WithIcon },
    { Value: httpStatusCode, Label: 'HTTP Code' },
    { Value: customerGSTIN, Label: 'Customer GSTIN' },
    { Value: grossAmount, Label: 'Gross Amount' },
    { Value: currency, Label: 'Currency' },
    { Value: irn, Label: 'IRN' },
    { Value: ackNo, Label: 'Ack No' },
    { Value: modifiedAt, Label: 'Last Updated' }
  ],
  UI.Facets: [
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'ClearanceDetailsFacet',
      Label : 'Tax Clearance & IRN Details',
      Target: '@UI.FieldGroup#ClearanceDetails'
    },
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'ValidationErrorsFacet',
      Label : 'Government Portal Validation Errors',
      Target: 'errors/@UI.LineItem'
    }
  ],
  UI.FieldGroup #ClearanceDetails: {
    Data: [
      { Value: billingDocument, Label: 'S/4HANA Billing Document' },
      { Value: companyCode, Label: 'Company Code' },
      { Value: soldToParty, Label: 'Sold-To Party' },
      { Value: customerGSTIN, Label: 'Customer GSTIN' },
      { Value: billingDate, Label: 'Billing Date' },
      { Value: netAmount, Label: 'Net Amount' },
      { Value: taxAmount, Label: 'Tax Amount' },
      { Value: grossAmount, Label: 'Gross Amount' },
      { Value: clearanceStatus, Label: 'Clearance Status', Criticality: statusCriticality },
      { Value: irn, Label: 'Invoice Reference Number (IRN)' },
      { Value: ackNo, Label: 'Acknowledgement Number' },
      { Value: ackDate, Label: 'Acknowledgement Timestamp' },
      { Value: signedQRCode, Label: 'Signed QR Payload' },
      { Value: cpiMessageGuid, Label: 'Integration Suite Message GUID' }
    ]
  }
);

annotate service.TaxValidationErrors with @(
  UI.LineItem: [
    { Value: errorCode, Label: 'Error Code' },
    { Value: errorField, Label: 'Invalid Field' },
    { Value: errorMessage, Label: 'Portal Error Message' },
    { Value: remediationHint, Label: 'Recommended Action' }
  ]
);
