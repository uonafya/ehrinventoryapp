package org.openmrs.module.ehrinventoryapp.task;

import org.openmrs.Drug;
import org.openmrs.api.context.Context;
import org.openmrs.module.ehrinventory.InventoryService;
import org.openmrs.module.hospitalcore.InventoryCommonService;
import org.openmrs.module.hospitalcore.model.InventoryDrug;
import org.openmrs.module.hospitalcore.model.InventoryDrugFormulation;
import org.openmrs.module.hospitalcore.model.InventoryDrugUnit;
import org.openmrs.scheduler.tasks.AbstractTask;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

public class CopyDrugsFromOpenmrsDrugToInventoryDrug extends AbstractTask {

    private static final Logger log = LoggerFactory.getLogger(CopyDrugsFromOpenmrsDrugToInventoryDrug.class);

    @Override
    public void execute() {
        InventoryCommonService inventoryCommonService = Context.getService(InventoryCommonService.class);
        InventoryService inventoryService = Context.getService(InventoryService.class);
        if (!isExecuting) {
            if (log.isDebugEnabled()) {
                log.debug("Copying new drugs to the inventory drugs");
            }

            startExecuting();
            try {
                //do all the work here by looping through the durgs that are availble and compare against what is supplied
                for (Drug drug : Context.getConceptService().getAllDrugs(false)) {
                    InventoryDrug inventoryDrug = null;
                    //supply a method that will get all the drugs here
                    if(inventoryCommonService.getDrugByName(drug.getName()) == null){

                        if(inventoryService.getDrugUnitById(1) != null && inventoryService.getDrugCategoryById(1) != null && inventoryService.getDrugFormulationById(1) != null) {
                            Set<InventoryDrugFormulation> formulations = new HashSet<InventoryDrugFormulation>();
                            formulations.add(inventoryService.getDrugFormulationById(1));

                            inventoryDrug  = new InventoryDrug();
                            inventoryDrug.setName(drug.getName());
                            inventoryDrug.setUnit(inventoryService.getDrugUnitById(1));
                            inventoryDrug.setCategory(inventoryService.getDrugCategoryById(1));
                            inventoryDrug.setFormulations(formulations);
                            inventoryDrug.setCreatedOn(new Date());
                            inventoryDrug.setCreatedBy(Context.getAuthenticatedUser().getGivenName());
                            inventoryDrug.setDrugCore(drug);
                            inventoryDrug.setAttribute(1);
                            inventoryDrug.setReorderQty(100);
                            inventoryDrug.setConsumption(10);

                            //save the inventry drugs as formulated
                            inventoryService.saveDrug(inventoryDrug);
                        }

                    }

                }
            } catch (Exception e) {
                log.error("Error while copying drugs to tthr invrntory_drug table ", e);
            } finally {
                stopExecuting();
            }
        }

    }
}
