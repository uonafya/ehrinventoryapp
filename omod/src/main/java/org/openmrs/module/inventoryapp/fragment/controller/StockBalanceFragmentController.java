package org.openmrs.module.inventoryapp.fragment.controller;

import org.openmrs.Role;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.model.InventoryStore;
import org.openmrs.module.hospitalcore.model.InventoryStoreDrugTransactionDetail;
import org.openmrs.module.hospitalcore.model.InventoryStoreRoleRelation;
import org.openmrs.module.inventory.InventoryService;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;


public class StockBalanceFragmentController {
    public void controller() {

    }

    public List<SimpleObject> fetchStockBalance(UiUtils uiUtils) {
        List<SimpleObject> stockBalanceList = null;
        InventoryService inventoryService = (InventoryService) Context.getService(InventoryService.class);
        List <Role>role=new ArrayList<Role>(Context.getAuthenticatedUser().getAllRoles());

        InventoryStoreRoleRelation inventoryStoreRoleRelation=null;
        Role rolePerson = null;
        for(Role roleUser : role){
            if(inventoryService.getStoreRoleByName(roleUser.toString())!=null){
                inventoryStoreRoleRelation = inventoryService.getStoreRoleByName(roleUser.toString());
                rolePerson= roleUser;
            }
        }
        InventoryStore store =null;
        if(inventoryStoreRoleRelation!=null){
            store = inventoryService.getStoreById(inventoryStoreRoleRelation.getStoreid());

        }
        List<InventoryStoreDrugTransactionDetail> stockBalances = inventoryService.listViewStockBalance(store.getId(), null, "","","","",false,0,0);

        if (stockBalances!=null) {
            Collections.sort(stockBalances);
            stockBalanceList = SimpleObject.fromCollection(stockBalances, uiUtils, "drug.name","drug.category.name","formulation.name","formulation.dozage","quantity","issueQuantity","currentQuantity","drug.reorderQty");

        }
        return stockBalanceList;
    }
}




