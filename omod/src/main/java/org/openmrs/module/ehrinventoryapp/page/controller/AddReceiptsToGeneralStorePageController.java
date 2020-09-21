package org.openmrs.module.ehrinventoryapp.page.controller;

import org.openmrs.api.context.Context;
import org.openmrs.module.ehrinventoryapp.EhrInventoryAppConstants;
import org.openmrs.module.hospitalcore.model.InventoryDrugCategory;
import org.openmrs.module.ehrinventory.InventoryService;
import org.openmrs.module.kenyaui.annotation.AppPage;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;

import java.util.List;

@AppPage(EhrInventoryAppConstants.APP_EHRINVENTORY_APP)
public class AddReceiptsToGeneralStorePageController {
    public void get(PageModel pageModel, UiUtils uiUtils) {
        InventoryService inventoryService = (InventoryService) Context.getService(InventoryService.class);
        List<InventoryDrugCategory> listCategory = inventoryService.findDrugCategory("");
        pageModel.addAttribute("listCategory", listCategory);
    }

}
