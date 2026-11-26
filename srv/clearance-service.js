const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {
  const { BillingClearanceLogs } = this.entities;

  this.before(['CREATE', 'UPDATE'], BillingClearanceLogs, (req) => {
    const status = req.data.clearanceStatus;
    if (status === 'CLEARED') {
      req.data.statusCriticality = 3;
    } else if (status === 'BLOCKED') {
      req.data.statusCriticality = 1;
    } else if (status === 'PENDING' || status === 'REPROCESSING') {
      req.data.statusCriticality = 2;
    }
  });

  this.on('reSubmit', BillingClearanceLogs, async (req) => {
    const param = req.params[0];
    const ID = typeof param === 'object' ? param.ID : param;
    const record = await SELECT.one.from(BillingClearanceLogs).where({ ID });

    if (!record) return req.reject(404, `Clearance log ${ID} not found.`);
    if (record.clearanceStatus === 'CLEARED') {
      return req.reject(400, `Billing Document ${record.billingDocument} is already cleared (IRN: ${record.irn}).`);
    }

    await UPDATE(BillingClearanceLogs)
      .set({
        clearanceStatus: 'REPROCESSING',
        statusCriticality: 2,
        httpStatusCode: 202
      })
      .where({ ID });

    req.info(`Billing Document ${record.billingDocument} queued for e-Invoice re-submission.`);
    return SELECT.one.from(BillingClearanceLogs).where({ ID });
  });
});