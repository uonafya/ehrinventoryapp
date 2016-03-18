package org.openmrs.module.inventoryapp.page.controller;

import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Created by USER on 3/18/2016.
 */
public class ViewCurrentStockBalanceDetailPageController {
    public void get(@RequestParam(value = "drugId", required = false) Integer drugId,
                    @RequestParam(value = "formulationId", required = false) Integer formulationId,
                    @RequestParam(value = "expiry", required = false) Integer expiry,
                    PageModel pageModel){
        pageModel.addAttribute("drugId",drugId);
        pageModel.addAttribute("formulationId",formulationId);
        pageModel.addAttribute("expiry",expiry);

    }

}
