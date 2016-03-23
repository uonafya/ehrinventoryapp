package org.openmrs.module.inventoryapp.model;

/**
 * Created by qqnarf on 3/22/16.
 */
public class DrugInformation {

    public int getDrugId() {
        return drugId;
    }

    public void setDrugId(int drugId) {
        this.drugId = drugId;
    }

    public int getDrugCategoryId() {
        return drugCategoryId;
    }

    public void setDrugCategoryId(int drugCategoryId) {
        this.drugCategoryId = drugCategoryId;
    }



    public int getDrugFormulationId() {
        return drugFormulationId;
    }

    public void setDrugFormulationId(int drugFormulationId) {
        this.drugFormulationId = drugFormulationId;
    }


    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(String unitPrice) {
        this.unitPrice = unitPrice;
    }

    public String getInstitutionalCost() {
        return institutionalCost;
    }

    public void setInstitutionalCost(String institutionalCost) {
        this.institutionalCost = institutionalCost;
    }

    public String getBatchNo() {
        return batchNo;
    }

    public void setBatchNo(String batchNo) {
        this.batchNo = batchNo;
    }

    public String getCostToThePatient() {
        return costToThePatient;
    }

    public void setCostToThePatient(String costToThePatient) {
        this.costToThePatient = costToThePatient;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getReceiptFrom() {
        return receiptFrom;
    }

    public void setReceiptFrom(String receiptFrom) {
        this.receiptFrom = receiptFrom;
    }

    public String getDateOfManufacture() {
        return dateOfManufacture;
    }

    public void setDateOfManufacture(String dateOfManufacture) {
        this.dateOfManufacture = dateOfManufacture;
    }

    public String getDateOfExpiry() {
        return dateOfExpiry;
    }

    public void setDateOfExpiry(String dateOfExpiry) {
        this.dateOfExpiry = dateOfExpiry;
    }

    public String getReceiptDate() {
        return receiptDate;
    }

    public void setReceiptDate(String receiptDate) {
        this.receiptDate = receiptDate;
    }

    private int drugCategoryId;
    private int drugId;
    private int drugFormulationId;
    private int quantity;
    private String unitPrice;
    private String institutionalCost;
    private String costToThePatient;
    private String batchNo;
    private String companyName;
    private String receiptFrom;
    private String dateOfManufacture;
    private String dateOfExpiry;
    private String receiptDate;
}
