package org.openmrs.module.ehrinventoryapp.fragment.controller;

import org.apache.commons.lang.StringUtils;
import org.openmrs.Role;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.model.InventoryStore;
import org.openmrs.module.hospitalcore.model.InventoryStoreDrugTransaction;
import org.openmrs.module.hospitalcore.model.InventoryStoreRoleRelation;
import org.openmrs.module.hospitalcore.util.ActionValue;
import org.openmrs.module.ehrinventory.InventoryService;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

/**
 *
 */
public class ReceiptsToGeneralStoreFragmentController {
    public void controller() {

    }
    public List<SimpleObject> fetchReceiptsToGeneralStore(
            @RequestParam(value="pageSize",required=false)  Integer pageSize,
            @RequestParam(value="currentPage",required=false)  Integer currentPage,
            @RequestParam(value="receiptName",required=false)  String receiptName,
            @RequestParam(value="fromDate",required=false)  String fromDate,
            @RequestParam(value="toDate",required=false)  String toDate,
            HttpServletRequest request,
            UiUtils uiUtils
    )
    {
        List<SimpleObject> receiptsToGeneralStore = null;

        InventoryService inventoryService = (InventoryService) Context.getService(InventoryService.class);
        //InventoryStore store = inventoryService.getStoreByCollectionRole(new ArrayList<Role>(Context.getAuthenticatedUser().getAllRoles()));
        List <Role>role=new ArrayList<Role>(Context.getAuthenticatedUser().getAllRoles());

        InventoryStoreRoleRelation inventoryStoreRoleRelation=null;
        Role rolePerson = null;
        for(Role roleUser: role){
            if(inventoryService.getStoreRoleByName(roleUser.toString())!=null){
                inventoryStoreRoleRelation = inventoryService.getStoreRoleByName(roleUser.toString());
                rolePerson=roleUser;
            }
        }
        InventoryStore store =null;
        if(inventoryStoreRoleRelation!=null){
            store = inventoryService.getStoreById(inventoryStoreRoleRelation.getStoreid());

        }
        int total = inventoryService.countStoreDrugTransaction(ActionValue.TRANSACTION[0], store.getId(), receiptName, fromDate, toDate);
        String temp = "";
        if(receiptName != null){
            if(StringUtils.isBlank(temp)){
                temp = "?receiptName="+receiptName;
            }else{
                temp +="&receiptName="+receiptName;
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

        List<InventoryStoreDrugTransaction> transactions = inventoryService.listStoreDrugTransaction(ActionValue.TRANSACTION[0], store.getId(), receiptName, fromDate, toDate,0, 0);

        receiptsToGeneralStore = SimpleObject.fromCollection(transactions, uiUtils,"id","description","createdOn", "store.name");

        return receiptsToGeneralStore;
    }
}
