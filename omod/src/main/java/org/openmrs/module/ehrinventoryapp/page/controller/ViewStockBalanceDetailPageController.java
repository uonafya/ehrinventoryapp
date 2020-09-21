package org.openmrs.module.ehrinventoryapp.page.controller;

import org.openmrs.module.ehrinventoryapp.EhrInventoryAppConstants;
import org.openmrs.module.hospitalcore.model.InventoryDrugFormulation;
import org.openmrs.module.hospitalcore.model.InventoryDrug;
import org.openmrs.api.context.Context;
import java.util.Set;

import org.openmrs.module.kenyaui.annotation.AppPage;
import org.openmrs.ui.framework.page.PageModel;
import org.openmrs.module.ehrinventory.InventoryService;
import org.springframework.web.bind.annotation.RequestParam;


@AppPage(EhrInventoryAppConstants.APP_EHRINVENTORY_APP)
public class ViewStockBalanceDetailPageController {
    public void get( @RequestParam(value = "drugId", required = false) Integer drugId,
                     @RequestParam(value = "formulationId", required = false) Integer formulationId,
                     @RequestParam(value = "expiry", required = false) Integer expiry,
                     PageModel pageModel){

        InventoryService inventoryService = (InventoryService) Context
                .getService(InventoryService.class);

        pageModel.addAttribute("drugId",drugId );
        pageModel.addAttribute("formulationId",formulationId );
        pageModel.addAttribute("expiry",expiry );

        InventoryDrug drug = inventoryService.getDrugById(drugId);
        Set<InventoryDrugFormulation> formulations = drug.getFormulations();

        InventoryDrugFormulation formulation = inventoryService.getDrugFormulationById(formulationId);
        pageModel.addAttribute("formulation",formulation);
        pageModel.addAttribute("drug",drug);
        pageModel.addAttribute("userLocation", Context.getAdministrationService().getGlobalProperty("hospital.location_user"));
    }

}
