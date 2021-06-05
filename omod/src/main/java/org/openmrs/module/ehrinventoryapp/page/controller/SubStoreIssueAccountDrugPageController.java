package org.openmrs.module.ehrinventoryapp.page.controller;

import org.openmrs.api.context.Context;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.module.ehrinventory.InventoryService;
import org.openmrs.module.ehrinventoryapp.EhrInventoryAppConstants;
import org.openmrs.module.hospitalcore.model.InventoryDrug;
import org.openmrs.module.hospitalcore.model.InventoryDrugCategory;
import org.openmrs.module.kenyaemr.api.KenyaEmrService;
import org.openmrs.module.kenyaui.annotation.AppPage;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;
import org.openmrs.ui.framework.page.PageRequest;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Date;
import java.util.List;

@AppPage(EhrInventoryAppConstants.APP_EHRINVENTORY_APP)
public class SubStoreIssueAccountDrugPageController {
    public void get(@RequestParam(value = "categoryId", required = false) Integer categoryId,
                    PageModel model,
                    UiSessionContext sessionContext,
                    PageRequest pageRequest,
                    UiUtils ui) {

        InventoryService inventoryService = Context.getService(InventoryService.class);
        KenyaEmrService kenyaEmrService = Context.getService(KenyaEmrService.class);

        List<InventoryDrugCategory> listCategory = inventoryService.findDrugCategory("");
        model.addAttribute("listCategory", listCategory);

        model.addAttribute("categoryId", categoryId);
        if (categoryId != null && categoryId > 0) {
            List<InventoryDrug> drugs = inventoryService.findDrug(categoryId, null);
            List<SimpleObject> simpleDrugs = SimpleObject.fromCollection(drugs, ui, "id");
            model.addAttribute("drugs", SimpleObject.create("drugs",simpleDrugs).toJson());
        }
        model.addAttribute("date", new Date());
        model.addAttribute("userLocation", kenyaEmrService.getDefaultLocation().getName());
    }
}
