package org.openmrs.module.ehrinventoryapp.fragment.controller;

import org.openmrs.Role;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.model.InventoryStore;
import org.openmrs.module.hospitalcore.model.InventoryStoreDrugTransactionDetail;
import org.openmrs.module.hospitalcore.model.InventoryStoreRoleRelation;
import org.openmrs.module.ehrinventory.InventoryService;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.List;

public class ViewCurrentStockBalanceDetailFragmentController {
    public void controller() {

    }

    public List<SimpleObject> viewCurrentStockBalanceDetail(
            @RequestParam(value = "drugId", required = false) Integer drugId,
            @RequestParam(value = "formulationId", required = false) Integer formulationId,
            @RequestParam(value = "expiry", required = false) Integer expiry,
            UiUtils uiUtils) {
        InventoryService inventoryService = (InventoryService) Context
                .getService(InventoryService.class);
        //	InventoryStore store = inventoryService.getStoreByCollectionRole(new ArrayList<Role>(Context	.getAuthenticatedUser().getAllRoles()));
        List<Role> role=new ArrayList<Role>(Context.getAuthenticatedUser().getAllRoles());

        InventoryStoreRoleRelation storeRoleRelation=null;
        Role rolePerson = null;
        for(Role roleUser: role){
            if(inventoryService.getStoreRoleByName(roleUser.toString())!=null){
                storeRoleRelation = inventoryService.getStoreRoleByName(roleUser.toString());
                rolePerson=roleUser;
            }
        }
        InventoryStore store =null;
        if(storeRoleRelation!=null){
            store = inventoryService.getStoreById(storeRoleRelation.getStoreid());

        }
        List<InventoryStoreDrugTransactionDetail> listViewStockBalance = inventoryService
                .listStoreDrugTransactionDetail(store.getId(), drugId,
                        formulationId, expiry);

        return SimpleObject.fromCollection(listViewStockBalance,uiUtils,"drug.name","drug.category.name","formulation.dozage","transaction.typeTransactionName","openingBalance","quantity","issueQuantity","closingBalance","dateExpiry","receiptDate");
    }
}
