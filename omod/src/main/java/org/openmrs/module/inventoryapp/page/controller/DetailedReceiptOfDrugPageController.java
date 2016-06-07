package org.openmrs.module.inventoryapp.page.controller;


import org.apache.commons.collections.CollectionUtils;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.model.InventoryStoreDrugTransaction;
import org.openmrs.module.hospitalcore.model.InventoryStoreDrugTransactionDetail;
import org.openmrs.module.inventory.InventoryService;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;

import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

/**
 * Created by ngarivictor on 3/21/2016.
 */
public class DetailedReceiptOfDrugPageController {
    public void get(
            @RequestParam(value = "receiptId", required = false) Integer receiptId,
            PageModel model, UiUtils uiUtils) {
        InventoryService inventoryService = (InventoryService) Context
                .getService(InventoryService.class);
        List<InventoryStoreDrugTransactionDetail> transactionDetails = inventoryService
                .listTransactionDetail(receiptId);

        InventoryStoreDrugTransaction transaction = inventoryService.getStoreDrugTransactionById(receiptId);
        model.addAttribute("description", transaction.getDescription());
        model.addAttribute("createdOn", transaction.getCreatedOn());
        model.addAttribute("receiptId", receiptId);

        int arrayLength = 0;
        if (!CollectionUtils.isEmpty(transactionDetails)) {
            arrayLength = transactionDetails.size();
            model.addAttribute("store", transactionDetails.get(0)
                    .getTransaction().getStore());
            model.addAttribute("date", transactionDetails.get(0)
                    .getTransaction().getCreatedOn());
            model.addAttribute("drug", transactionDetails.get(0)
                    .getDrug());
            model.addAttribute("formulation", transactionDetails.get(0).getFormulation());
        }

        List<SimpleObject> simpleObjects = SimpleObject.fromCollection(transactionDetails, uiUtils, "drug.name", "formulation.name", "formulation.dozage", "quantity", "unitPrice", "costToPatient", "VAT", "batchNo", "companyName", "dateManufacture", "dateExpiry", "createdOn", "receiptFrom");

        model.addAttribute("transactionDetails", SimpleObject.create("simpleObjects",simpleObjects).toJson());
        model.addAttribute("userLocation", Context.getAdministrationService().getGlobalProperty("hospital.location_user"));
        model.addAttribute("arrayLength", arrayLength);
    }

}
