package org.openmrs.module.inventoryapp.model;

import java.io.Serializable;

public class InventoryStoreItemPatientDetail implements  Serializable {
		 private static final long serialVersionUID = 1L;
		 private Integer id;
		 private InventoryStoreItemPatient storeItemPatient;
		 private Integer quantity;
		 private InventoryStoreItemTransactionDetail transactionDetail;
		public Integer getId() {
			return id;
		}
		public void setId(Integer id) {
			this.id = id;
		}
		
		public Integer getQuantity() {
			return quantity;
		}
		public void setQuantity(Integer quantity) {
			this.quantity = quantity;
		}
		
		public InventoryStoreItemPatient getStoreItemPatient() {
			return storeItemPatient;
		}
		public void setStoreItemPatient(InventoryStoreItemPatient storeItemPatient) {
			this.storeItemPatient = storeItemPatient;
		}
		public InventoryStoreItemTransactionDetail getTransactionDetail() {
			return transactionDetail;
		}
		public void setTransactionDetail(
				InventoryStoreItemTransactionDetail transactionDetail) {
			this.transactionDetail = transactionDetail;
		}
		
		 
		 
}