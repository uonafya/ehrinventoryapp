package org.openmrs.module.inventoryapp.page.controller;

import org.apache.commons.lang.math.NumberUtils;
import org.json.JSONArray;
import org.json.JSONObject;
import org.openmrs.Role;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.model.*;
import org.openmrs.module.hospitalcore.util.ActionValue;
import org.openmrs.module.inventory.InventoryService;
import org.openmrs.module.inventory.model.InventoryStoreDrug;
import org.openmrs.module.inventory.model.InventoryStoreDrugIndentDetail;
import org.openmrs.module.inventory.util.DateUtils;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.util.*;
import java.util.logging.Logger;

/**
 * @author Stanslaus Odhiambo
 *         Created  on 3/21/2016.
 */
public class MainStoreDrugProcessIndentPageController {
    private Logger logger = Logger.getLogger(this.getClass().getName());

    /**
     * default handler for GET and POST requests if none is provided for use
     */
    public void controller() {
        logger.info("In MainStoreDrugProcessIndentPageController");
    }

    /**
     * Handles the GET request on the Main store drug process indent page
     *
     * @param id      the indent id to be loaded
     * @param model   backing bean for storing attributes
     * @param uiUtils UI utils from Openmrs
     * @return - the url  of the page to load
     */
    public String get(@RequestParam(value = "indentId", required = false) Integer id, PageModel model,
                      UiUtils uiUtils) {
        InventoryService inventoryService = Context.getService(InventoryService.class);
        InventoryStoreDrugIndent indent = inventoryService.getStoreDrugIndentById(id);
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
        if (indent != null && indent.getSubStoreStatus() == 2 && indent.getMainStoreStatus() == 1) {
            List<InventoryStoreDrugIndentDetail> listDrugNeedProcess = inventoryService.listStoreDrugIndentDetail(id);
            Collection<Integer> formulationIds = new ArrayList<Integer>();
            Collection<Integer> drugIds = new ArrayList<Integer>();
            for (InventoryStoreDrugIndentDetail t : listDrugNeedProcess) {
                formulationIds.add(t.getFormulation().getId());
                drugIds.add(t.getDrug().getId());
            }

            List<InventoryStoreDrugTransactionDetail> transactionAvailableOfMainStore = inventoryService.listStoreDrugAvaiable(mainStore.getId(), drugIds, formulationIds);
            List<InventoryStoreDrugIndentDetail> listDrugTP = new ArrayList<InventoryStoreDrugIndentDetail>();
            for (InventoryStoreDrugIndentDetail t : listDrugNeedProcess) {
                if (transactionAvailableOfMainStore != null && transactionAvailableOfMainStore.size() > 0) {
                    for (InventoryStoreDrugTransactionDetail trDetail : transactionAvailableOfMainStore) {
                        if (t.getDrug().getId().equals(trDetail.getDrug().getId()) && t.getFormulation().getId().equals(trDetail.getFormulation().getId())) {
                            t.setMainStoreTransfer(trDetail.getCurrentQuantity());
                        }
                    }
                } else {
                    t.setMainStoreTransfer(0);
                }
                listDrugTP.add(t);
            }
            List<SimpleObject> simpleObjects = SimpleObject.fromCollection(listDrugTP, uiUtils, "id", "drug.id", "drug.name",
                    "formulation.id", "formulation.name", "formulation.dozage", "formulation.description", "quantity", "mainStoreTransfer");
            String listDrugTPJson = SimpleObject.create("listDrugNeedProcess", simpleObjects).toJson();
            model.addAttribute("listDrugNeedProcess", listDrugTPJson);
            model.addAttribute("indent", indent);

            return "mainStoreDrugProcessIndent";
        }

        return "redirect:" + uiUtils.pageLink("inventoryapp", "transferDrugFromGeneralStore");

    }


    /**
     * Handles POST requests on the main store drug process page
     *
     * @param request - payload from the page
     * @param model
     * @return - backing bean for holding attributes
     */
    public String post(HttpServletRequest request, PageModel model, UiUtils uiUtils) {
        List<String> errors = new ArrayList<String>();
        InventoryService inventoryService = Context.getService(InventoryService.class);
        Integer indentId = NumberUtils.toInt(request.getParameter("indentId"));
        InventoryStoreDrugIndent indent = inventoryService.getStoreDrugIndentById(indentId);
        List<InventoryStoreDrugIndentDetail> listIndentDetail = inventoryService.listStoreDrugIndentDetail(indentId);
        if ("1".equals(request.getParameter("refuse"))) {
            if (indent != null) {
                indent.setMainStoreStatus(ActionValue.INDENT_MAINSTORE[1]);
                indent.setSubStoreStatus(ActionValue.INDENT_SUBSTORE[5]);
                inventoryService.saveStoreDrugIndent(indent);

                for (InventoryStoreDrugIndentDetail t : listIndentDetail) {
                    InventoryStoreDrug storeDrug = inventoryService.getStoreDrug(indent.getStore().getId(), t.getDrug().getId(), t.getFormulation().getId());
                    if (storeDrug != null) {
                        storeDrug.setStatusIndent(0);
                        inventoryService.saveStoreDrug(storeDrug);
                    }

                }
            }
            return "redirect:" + uiUtils.pageLink("inventoryapp", "main");
        }
        //validate here

        Collection<Integer> formulationIds = new ArrayList<Integer>();
        Collection<Integer> drugIds = new ArrayList<Integer>();
        for (InventoryStoreDrugIndentDetail t : listIndentDetail) {
            formulationIds.add(t.getFormulation().getId());
            drugIds.add(t.getDrug().getId());
        }
        //InventoryStore mainStore =  inventoryService.getStoreByCollectionRole(new ArrayList<Role>(Context.getAuthenticatedUser().getAllRoles()));
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
            System.out.println(mainStore.getName());
        }
        List<InventoryStoreDrugTransactionDetail> transactionAvaiableOfMainStore = inventoryService.listStoreDrugAvaiable(mainStore.getId(), drugIds, formulationIds);


        boolean passTransfer = true;
        List<Integer> quantityTransfers = new ArrayList<Integer>();
        //get available quantity mainstore have on hand
        List<InventoryStoreDrugIndentDetail> listDrugTP = new ArrayList<InventoryStoreDrugIndentDetail>();

        String drugIndents = request.getParameter("drugIntents");
        JSONObject obj = new JSONObject(drugIndents);
        JSONArray indentItems = obj.getJSONArray("indentItems");


        for (InventoryStoreDrugIndentDetail t : listIndentDetail) {
            //temp is the current quantity received from the ui
            int temp = 0;
            for (int i = 0; i < indentItems.length(); i++) {
                JSONObject incomingItem = indentItems.getJSONObject(i);
                JSONObject initialItem = incomingItem.getJSONObject("initialItem");
                int id = initialItem.getInt("id");
                if (id == t.getId()) {
                    String transferQuantity = incomingItem.getString("transferQuantity");
                    System.out.println(transferQuantity);
                    temp=Integer.valueOf(transferQuantity);
                    break;
                }
            }
            //get to return view value
            quantityTransfers.add(temp);
            if (transactionAvaiableOfMainStore != null && transactionAvaiableOfMainStore.size() > 0) {
                for (InventoryStoreDrugTransactionDetail trDetail : transactionAvaiableOfMainStore) {
                    //ghanshyam 7-august-2013 code review bug
                    if (t.getDrug().getId().equals(trDetail.getDrug().getId()) && t.getFormulation().getId().equals(trDetail.getFormulation().getId())) {
                        t.setMainStoreTransfer(trDetail.getCurrentQuantity());
                        if (temp > trDetail.getCurrentQuantity() || temp < 0) {
                            errors.add("inventory.indent.error.quantity");
                        }
                    }


                }
            } else {
                errors.add("inventory.indent.error.quantity");
            }
            if (temp > 0) {
                passTransfer = false;
            }
            listDrugTP.add(t);
        }

        if (passTransfer) {
            errors.add("inventory.indent.error.transfer");
        }

        if (errors != null && errors.size() > 0) {
            model.addAttribute("listDrugNeedProcess", listDrugTP);
            model.addAttribute("indent", indent);
            model.addAttribute("errors", errors);
            model.addAttribute("quantityTransfers", quantityTransfers);
            return "mainStoreDrugProcessIndent";
        }

        //create transaction
        InventoryStoreDrugTransaction transaction = new InventoryStoreDrugTransaction();
        transaction.setDescription("TRANSFER SYSTEM AUTO " + DateUtils.getDDMMYYYY());
        transaction.setStore(mainStore);
        transaction.setTypeTransaction(ActionValue.TRANSACTION[1]);
        transaction.setCreatedOn(new Date());
        transaction.setCreatedBy(Context.getAuthenticatedUser().getGivenName());
        transaction = inventoryService.saveStoreDrugTransaction(transaction);


        for (InventoryStoreDrugIndentDetail t : listIndentDetail) {
//            int temp = NumberUtils.toInt(request.getParameter(t.getId() + ""), 0);
            int temp = 0;
            for (int i = 0; i < indentItems.length(); i++) {
                JSONObject incomingItem = indentItems.getJSONObject(i);
                JSONObject initialItem = incomingItem.getJSONObject("initialItem");
                int id = initialItem.getInt("id");
                if (id == t.getId()) {
                    String transferQuantity = incomingItem.getString("transferQuantity");
                    System.out.println(transferQuantity);
                    temp=Integer.valueOf(transferQuantity);
                    System.out.println("Temp is: "+temp);
                    break;
                }
            }

            t.setMainStoreTransfer(temp);
            if (temp > 0) {
                //sum currentQuantity of drugId, formulationId of store
                Integer totalQuantity = inventoryService.sumCurrentQuantityDrugOfStore(mainStore.getId(), t.getDrug().getId(), t.getFormulation().getId());
                //list all transaction detail with condition dateExpiry > now() , drugId = ? , formulationId = ? of mainstore
                List<InventoryStoreDrugTransactionDetail> listTransactionAvailableMS = inventoryService.listStoreDrugTransactionDetail(mainStore.getId(), t.getDrug().getId(), t.getFormulation().getId(), true);
                InventoryStoreDrugTransactionDetail transDetail = new InventoryStoreDrugTransactionDetail();
                transDetail.setTransaction(transaction);
                InventoryStoreDrug storeDrug = inventoryService.getStoreDrug(mainStore.getId(), t.getDrug().getId(), t.getFormulation().getId());
                for (InventoryStoreDrugTransactionDetail trDetail : listTransactionAvailableMS) {
                    Integer x = trDetail.getCurrentQuantity() - temp;
                    if (x >= 0) {
                        Date date = new Date();
                        //update current quantity of mainstore in transactionDetail
                        trDetail.setCurrentQuantity(x);
                        inventoryService.saveStoreDrugTransactionDetail(trDetail);

                        transDetail.setDrug(trDetail.getDrug());
                        transDetail.setReorderPoint(trDetail.getDrug().getReorderQty());
                        transDetail.setAttribute(trDetail.getDrug().getAttributeName());
                        transDetail.setDateExpiry(trDetail.getDateExpiry());
                        transDetail.setBatchNo(trDetail.getBatchNo());
                        transDetail.setCompanyName(trDetail.getCompanyName());
                        transDetail.setCreatedOn(date);
                        transDetail.setDateManufacture(trDetail.getDateManufacture());
                        transDetail.setFormulation(trDetail.getFormulation());
                        transDetail.setUnitPrice(trDetail.getUnitPrice());
                        transDetail.setVAT(trDetail.getVAT());
                        transDetail.setCostToPatient(trDetail.getCostToPatient());
                        transDetail.setParent(trDetail);
                        transDetail.setReceiptDate(date);
                        BigDecimal moneyUnitPrice = trDetail.getCostToPatient().multiply(new BigDecimal(temp));
                        //moneyUnitPrice = moneyUnitPrice.add(moneyUnitPrice.multiply(trDetail.getVAT().divide(new BigDecimal(100))));
                        transDetail.setTotalPrice(moneyUnitPrice);

                        transDetail.setQuantity(0);
                        transDetail.setCurrentQuantity(0);
                        transDetail.setIssueQuantity(temp);
                        transDetail.setOpeningBalance(totalQuantity);
                        transDetail.setClosingBalance(totalQuantity - temp);
                        inventoryService.saveStoreDrugTransactionDetail(transDetail);

                        //save last to StoreDrug
                        storeDrug.setOpeningBalance(totalQuantity);
                        storeDrug.setClosingBalance(totalQuantity - temp);
                        storeDrug.setIssueQuantity(storeDrug.getIssueQuantity() + temp);
                        storeDrug.setCurrentQuantity(totalQuantity - temp);
                        inventoryService.saveStoreDrug(storeDrug);

                        //create transactionDetail for transfer
                        try {
                            Thread.sleep(2000);
                        } catch (InterruptedException e) {
                            // TODO Auto-generated catch block
                            e.printStackTrace();
                        }
                        break;
                    } else {
                        Date date = new Date();
                        transDetail.setIssueQuantity(trDetail.getCurrentQuantity());
                        trDetail.setCurrentQuantity(0);
                        trDetail.setQuantity(0);

                        inventoryService.saveStoreDrugTransactionDetail(trDetail);
                        BigDecimal moneyUnitPrice = trDetail.getUnitPrice().multiply(new BigDecimal(transDetail.getIssueQuantity()));
                        moneyUnitPrice = moneyUnitPrice.add(moneyUnitPrice.multiply(trDetail.getVAT().divide(new BigDecimal(100))));
                        transDetail.setTotalPrice(moneyUnitPrice);
                        transDetail.setCurrentQuantity(0);
                        transDetail.setOpeningBalance(totalQuantity);
                        transDetail.setDrug(trDetail.getDrug());
                        transDetail.setReorderPoint(trDetail.getDrug().getReorderQty());
                        transDetail.setAttribute(trDetail.getDrug().getAttributeName());
                        transDetail.setDateExpiry(trDetail.getDateExpiry());
                        transDetail.setBatchNo(trDetail.getBatchNo());
                        transDetail.setCompanyName(trDetail.getCompanyName());
                        transDetail.setCreatedOn(date);
                        transDetail.setDateManufacture(trDetail.getDateManufacture());
                        transDetail.setFormulation(trDetail.getFormulation());
                        transDetail.setUnitPrice(trDetail.getUnitPrice());
                        transDetail.setVAT(trDetail.getVAT());
                        transDetail.setCostToPatient(trDetail.getCostToPatient());
                        transDetail.setParent(trDetail);
                        transDetail.setReceiptDate(date);
                        transDetail.setClosingBalance(totalQuantity - transDetail.getIssueQuantity());
                        inventoryService.saveStoreDrugTransactionDetail(transDetail);
                        totalQuantity -= transDetail.getIssueQuantity();
                        temp -= transDetail.getIssueQuantity();
                        //create transactionDetail for transfer
                        try {
                            Thread.sleep(2000);
                        } catch (InterruptedException e) {
                            // TODO Auto-generated catch block
                            e.printStackTrace();
                        }
                    }

                }

            }
            inventoryService.saveStoreDrugIndentDetail(t);
        }
        //add issue transaction from general store
        indent.setMainStoreStatus(ActionValue.INDENT_MAINSTORE[2]);
        indent.setSubStoreStatus(ActionValue.INDENT_SUBSTORE[2]);
        indent.setTransaction(transaction);
        inventoryService.saveStoreDrugIndent(indent);
        Map<String, Object> redirectParams = new HashMap<String, Object>();
        redirectParams.put("viewIndent", indentId);
        return "redirect:" + uiUtils.pageLink("inventoryapp", "main", redirectParams);

    }
}
