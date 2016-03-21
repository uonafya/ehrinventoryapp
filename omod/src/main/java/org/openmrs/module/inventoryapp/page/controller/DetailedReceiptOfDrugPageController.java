package org.openmrs.module.inventoryapp.page.controller;


import org.apache.commons.collections.CollectionUtils;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.model.InventoryStoreDrugTransactionDetail;
import org.openmrs.module.inventory.InventoryService;
import org.openmrs.ui.framework.page.PageModel;

import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

/**
 * Created by ngarivictor on 3/21/2016.
 */
public class DetailedReceiptOfDrugPageController {
    public void get(
            @RequestParam(value = "receiptId", required = false) Integer receiptId,
            PageModel model) {
        InventoryService inventoryService = (InventoryService) Context
                .getService(InventoryService.class);
        List<InventoryStoreDrugTransactionDetail> transactionDetails = inventoryService
                .listTransactionDetail(receiptId);
        if (!CollectionUtils.isEmpty(transactionDetails)) {
            model.addAttribute("store", transactionDetails.get(0)
                    .getTransaction().getStore());
            model.addAttribute("date", transactionDetails.get(0)
                    .getTransaction().getCreatedOn());
        }
        model.addAttribute("transactionDetails", transactionDetails);

    }

}
