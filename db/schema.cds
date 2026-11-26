namespace sap.btp.einvoice;

using { cuid, managed } from '@sap/cds/common';

@title: 'Billing Clearance Log'
@Common.Label: 'Billing Document e-Invoice Clearance Record'
entity BillingClearanceLogs : cuid, managed {
  @title: 'Billing Document'
  @Common.Label: 'S/4HANA Billing Document ID'
  billingDocument     : String(10) not null;

  @title: 'Company Code'
  companyCode         : String(4);

  @title: 'Sold-To Party'
  soldToParty         : String(10);

  @title: 'Customer GSTIN'
  customerGSTIN       : String(15);

  @title: 'Billing Date'
  billingDate         : Date;

  @title: 'Net Amount'
  netAmount           : Decimal(15, 2);

  @title: 'Tax Amount'
  taxAmount           : Decimal(15, 2);

  @title: 'Total Gross Amount'
  grossAmount         : Decimal(15, 2);

  @title: 'Currency'
  currency            : String(3) default 'INR';

  @title: 'Clearance Status'
  @Common.Label: 'e-Invoice Clearance Status (CLEARED, BLOCKED, PENDING, REPROCESSING)'
  clearanceStatus     : String(20) default 'PENDING';

  @title: 'Status Criticality'
  statusCriticality   : Integer default 2;

  @title: 'HTTP Status Code'
  httpStatusCode      : Integer;

  @title: 'Invoice Reference Number (IRN)'
  irn                 : String(64);

  @title: 'Acknowledgement Number'
  ackNo               : String(30);

  @title: 'Acknowledgement Date'
  ackDate             : Timestamp;

  @title: 'Signed QR Payload'
  signedQRCode        : LargeString;

  @title: 'Correlation ID'
  cpiMessageGuid      : String(64);

  @title: 'Validation Errors'
  errors              : Composition of many TaxValidationErrors
                          on errors.parent = $self;
}

@title: 'Tax Validation Error'
@Common.Label: 'Government Tax Portal Validation Error Detail'
entity TaxValidationErrors : cuid, managed {
  parent              : Association to BillingClearanceLogs;

  @title: 'Error Code'
  errorCode           : String(20);

  @title: 'Error Field'
  errorField          : String(50);

  @title: 'Error Message'
  errorMessage        : String(500);

  @title: 'Suggested Fix'
  remediationHint     : String(300);
}
