package org.openmrs.module.ehrinventoryapp.page.controller;

import org.apache.commons.collections.CollectionUtils;
import org.openmrs.api.context.Context;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.module.ehrinventory.InventoryService;
import org.openmrs.module.ehrinventory.model.InventoryStoreDrugAccountDetail;
import org.openmrs.module.ehrinventoryapp.EhrInventoryAppConstants;
import org.openmrs.module.kenyaemr.api.KenyaEmrService;
import org.openmrs.module.kenyaui.annotation.AppPage;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;
import org.openmrs.ui.framework.page.PageRequest;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Date;
import java.util.List;

@AppPage(EhrInventoryAppConstants.APP_EHRINVENTORY_APP)
public class IssueDrugAccountDetailPageController {

    public void get (
            @RequestParam(value = "issueId", required = false) Integer issueId,
            UiSessionContext sessionContext,
            PageRequest pageRequest,
            UiUtils ui,
            PageModel model) {

        InventoryService inventoryService = (InventoryService) Context
                .getService(InventoryService.class);
        List<InventoryStoreDrugAccountDetail> listDrugIssue = inventoryService
                .listStoreDrugAccountDetail(issueId);
        KenyaEmrService kenyaEmrService = Context.getService(KenyaEmrService.class);
        model.addAttribute("listDrugIssue", listDrugIssue);

        Date issueAccountDate = new Date();
        String issueAccountName = "UNKNOWN";
        String pharmacist = "Unknown";


        if (CollectionUtils.isNotEmpty(listDrugIssue)) {
            issueAccountDate = listDrugIssue.get(0).getDrugAccount().getCreatedOn();
            issueAccountName=listDrugIssue.get(0).getDrugAccount().getName();
            pharmacist = listDrugIssue.get(0).getDrugAccount().getCreatedBy();
        }

        model.addAttribute("issueAccountDate", issueAccountDate);
        model.addAttribute("issueAccountName", issueAccountName);
        model.addAttribute("pharmacist", pharmacist);

        model.addAttribute("userLocation", kenyaEmrService.getDefaultLocation().getName());

    }
}