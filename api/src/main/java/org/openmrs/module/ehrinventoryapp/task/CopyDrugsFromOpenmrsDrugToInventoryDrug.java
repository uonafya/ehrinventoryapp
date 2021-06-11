package org.openmrs.module.ehrinventoryapp.task;

import org.apache.commons.lang3.StringUtils;
import org.openmrs.Drug;
import org.openmrs.api.context.Context;
import org.openmrs.module.ehrinventory.InventoryService;
import org.openmrs.module.hospitalcore.InventoryCommonService;
import org.openmrs.module.hospitalcore.model.InventoryDrug;
import org.openmrs.module.hospitalcore.model.InventoryDrugCategory;
import org.openmrs.module.hospitalcore.model.InventoryDrugFormulation;
import org.openmrs.module.hospitalcore.model.InventoryDrugUnit;
import org.openmrs.scheduler.tasks.AbstractTask;
import org.openmrs.util.OpenmrsClassLoader;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

public class CopyDrugsFromOpenmrsDrugToInventoryDrug extends AbstractTask {

    private static final Logger log = LoggerFactory.getLogger(CopyDrugsFromOpenmrsDrugToInventoryDrug.class);

    @Override
    public void execute() {
        InventoryCommonService inventoryCommonService = Context.getService(InventoryCommonService.class);
        InventoryService inventoryService = Context.getService(InventoryService.class);
        InputStream categoryPath = OpenmrsClassLoader.getInstance().getResourceAsStream("metadata/inventory_drug_category.csv");
        InputStream formulationPath = OpenmrsClassLoader.getInstance().getResourceAsStream("metadata/invetory_drug_formulation.csv");

        if (!isExecuting) {
            if (log.isDebugEnabled()) {
                log.debug("Copying new drugs to the inventory drugs");
            }

            startExecuting();
            try {
                //load drug categories
                setUnit(inventoryService);
                updateDrugCategories(inventoryService, categoryPath);
                updateDrugFormulation(inventoryService, formulationPath);
                //do all the work here by looping through the drugs that are availble and compare against what is supplied
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
                log.error("Error while copying drugs to the invrntory resources ", e);
            } finally {
                stopExecuting();
            }
        }

    }
    private void updateDrugCategories(InventoryService inventoryService, InputStream csvFile) {
        String line = "";
        String cvsSplitBy = ",";
        String headLine = "";
        String name = "";
        String description = "";
        try {
            BufferedReader br = new BufferedReader(new InputStreamReader(csvFile, "UTF-8"));
            headLine = br.readLine();
            while ((line = br.readLine()) != null) {
                String[] records = line.split(cvsSplitBy);
                name = records[0];
                description = records[1];
                if (StringUtils.isNotEmpty(name) && inventoryService.getDrugCategoryByName(name) == null) {
                    InventoryDrugCategory inventoryDrugCategory = new InventoryDrugCategory();
                    inventoryDrugCategory.setName(name);
                    inventoryDrugCategory.setDescription(description);
                    inventoryDrugCategory.setCreatedOn(new Date());
                    inventoryDrugCategory.setCreatedBy(Context.getAuthenticatedUser().getGivenName());

                    //save the object
                    inventoryService.saveDrugCategory(inventoryDrugCategory);
                }
            }
        }
        catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void updateDrugFormulation(InventoryService inventoryService, InputStream csvFile) {
        String line = "";
        String cvsSplitBy = ",";
        String headLine = "";
        String name = "";
        String dosage = "";
        try {
            BufferedReader br = new BufferedReader(new InputStreamReader(csvFile, "UTF-8"));
            headLine = br.readLine();
            while ((line = br.readLine()) != null) {
                String[] records = line.split(cvsSplitBy);
                name = records[0];
                dosage = records[1];
                if (StringUtils.isNotEmpty(name) && inventoryService.getDrugFormulationByName(name) == null) {
                    InventoryDrugFormulation inventoryDrugFormulation = new InventoryDrugFormulation();
                    inventoryDrugFormulation.setName(name);
                    inventoryDrugFormulation.setDozage(dosage);
                    inventoryDrugFormulation.setCreatedOn(new Date());
                    inventoryDrugFormulation.setCreatedBy(Context.getAuthenticatedUser().getGivenName());


                    //save the object
                    inventoryService.saveDrugFormulation(inventoryDrugFormulation);
                }
            }
        }
        catch (IOException e) {
            e.printStackTrace();
        }
    }
    private void setUnit(InventoryService inventoryService){
        if (inventoryService.getDrugUnitByName("EACH") == null) {
            InventoryDrugUnit inventoryDrugUnit = new InventoryDrugUnit();
            inventoryDrugUnit.setName("EACH");
            inventoryDrugUnit.setCreatedBy(Context.getAuthenticatedUser().getGivenName());
            inventoryDrugUnit.setCreatedOn(new Date());
            inventoryDrugUnit.setDescription("Measuere unit for a given drug");

            inventoryService.saveDrugUnit(inventoryDrugUnit);
        }
    }
}
