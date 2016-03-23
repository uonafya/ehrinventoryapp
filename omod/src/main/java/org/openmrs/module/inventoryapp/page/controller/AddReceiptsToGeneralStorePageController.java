package org.openmrs.module.inventoryapp.page.controller;

import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.model.InventoryDrugCategory;
import org.openmrs.module.inventory.InventoryService;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;

import java.util.List;

/**
 * Created by qqnarf on 3/21/16.
 */
public class AddReceiptsToGeneralStorePageController {
    public void get(PageModel pageModel, UiUtils uiUtils) {
        InventoryService inventoryService = (InventoryService) Context.getService(InventoryService.class);
        List<InventoryDrugCategory> listCategory = inventoryService.findDrugCategory("");
        pageModel.addAttribute("listCategory", listCategory);
    }

}
