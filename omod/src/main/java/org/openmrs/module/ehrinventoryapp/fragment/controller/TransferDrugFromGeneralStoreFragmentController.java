package org.openmrs.module.ehrinventoryapp.fragment.controller;

import org.apache.commons.lang.StringUtils;
import org.openmrs.Role;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.model.InventoryStore;
import org.openmrs.module.hospitalcore.model.InventoryStoreDrugIndent;
import org.openmrs.module.hospitalcore.model.InventoryStoreRoleRelation;
import org.openmrs.module.ehrinventory.InventoryService;
import org.openmrs.module.ehrinventory.util.PagingUtil;
import org.openmrs.module.ehrinventory.util.RequestUtil;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

/**
 *
 */


public class TransferDrugFromGeneralStoreFragmentController {
    private Logger logger = Logger.getLogger(this.getClass().getName());

    /**
     * Place holder method for handling the GET and POST requests on this controller when none is provided
     */
    public void get() {
        logger.info("In TransferDrugFromGeneralStoreFragmentController");
    }

    public List<SimpleObject> getIndentList(
            @RequestParam(value = "indentId", required = false) Integer id,
            @RequestParam(value = "storeId", required = false) Integer storeId,
            @RequestParam(value = "statusId", required = false) Integer statusId,
            @RequestParam(value = "indentName", required = false) String indentName,
            @RequestParam(value = "fromDate", required = false) String fromDate,
            @RequestParam(value = "toDate", required = false) String toDate,
            @RequestParam(value = "pageSize", required = false) Integer pageSize,
            @RequestParam(value = "currentPage", required = false) Integer currentPage,
            @RequestParam(value = "viewIndent", required = false) Integer viewIndent, PageModel model,
            HttpServletRequest request, UiUtils uiUtils) {
        InventoryService inventoryService = Context.getService(InventoryService.class);
        List<Role> role = new ArrayList<Role>(Context.getAuthenticatedUser().getAllRoles());
        InventoryStoreRoleRelation srl = null;
        Role rl = null;
        for (Role r : role) {
            if (inventoryService.getStoreRoleByName(r.toString()) != null) {
                srl = inventoryService.getStoreRoleByName(r.toString());
                rl = r;
            }
        }
        InventoryStore mainStore = null;
        if (srl != null) {
            mainStore = inventoryService.getStoreById(srl.getStoreid());

        }
        int total = inventoryService.countMainStoreIndent(id, mainStore.getId(), storeId, indentName, statusId, fromDate, toDate);
        String temp = "";
        if(!StringUtils.isBlank(indentName)){
            temp = "?indentName="+indentName;
        }

        if(storeId != null){
            if(StringUtils.isBlank(temp)){
                temp = "?storeId="+storeId;
            }else{
                temp +="&storeId="+storeId;
            }
        }
        if(statusId != null){
            if(StringUtils.isBlank(temp)){
                temp = "?statusId="+statusId;
            }else{
                temp +="&statusId="+statusId;
            }
        }
        if(!StringUtils.isBlank(fromDate)){
            if(StringUtils.isBlank(temp)){
                temp = "?fromDate="+fromDate;
            }else{
                temp +="&fromDate="+fromDate;
            }
        }
        if(!StringUtils.isBlank(toDate)){
            if(StringUtils.isBlank(temp)){
                temp = "?toDate="+toDate;
            }else{
                temp +="&toDate="+toDate;
            }
        }
        PagingUtil pagingUtil = new PagingUtil( RequestUtil.getCurrentLink(request)+temp , pageSize, currentPage, total );
        List<InventoryStoreDrugIndent> listIndent = inventoryService.listMainStoreIndent(id ,mainStore.getId(), storeId, indentName, statusId, fromDate, toDate, pagingUtil.getStartPos(), pagingUtil.getPageSize());


        return SimpleObject.fromCollection(listIndent,uiUtils,"store.name","name","createdOn","id","mainStoreStatusName","mainStoreStatus");
    }

}
