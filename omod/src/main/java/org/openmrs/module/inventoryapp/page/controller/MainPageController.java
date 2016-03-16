package org.openmrs.module.inventoryapp.page.controller;

import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.model.InventoryDrugCategory;
import org.openmrs.module.inventory.InventoryService;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;

import java.util.List;

/**
 * @author Stanslaus Odhiambo
 * Created on 3/16/2016.
 */
public class MainPageController {
    /**
     * Default handler for get and post requests if none is provided
     */
    public static void controller(){

    }

    public void get(PageModel pageModel,UiUtils uiUtils){
        InventoryService inventoryService = Context.getService(InventoryService.class);
        List<InventoryDrugCategory> listCategory = inventoryService
                .listDrugCategory("", 0, 0);
        pageModel.put("listCategory", listCategory);

    }


}
