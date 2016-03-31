<script>
    var pDataString;
    jq(function(){
        var pData = getStockBalance();
        pDataString = JSON.stringify(pData);
        function StockListView(){
            var self = this;
            // Editable data
            self.stockItems = ko.observableArray([]);
            var mappedStockItems = jQuery.map(pData, function (item) {
                return item;
            });

            self.viewDetails = function(item){
                window.location.replace("viewCurrentStockBalanceDetail.page?drugId="+item.drug.id +"&formulationId="+item.formulation.id);

            }
            self.stockItems(mappedStockItems);
        }

        var list = new StockListView();
        ko.applyBindings(list, jq("#stocklist")[0]);
    });
    function getStockBalance() {
        var toReturn;
        jQuery.ajax({
            type: "GET",
            url: '${ui.actionLink("inventoryapp", "stockBalance", "fetchStockBalance")}',
            dataType: "json",
            global: false,
            async: false,
            success: function (data) {
                toReturn = data;
            }
        });
        return toReturn;
    }
</script>

<div class="dashboard clear">
	<div class="info-section">
		<div class="info-header">
			<i class="icon-calendar"></i>

			<h3>View Drug Stock</h3>
		</div>
	</div>
</div>

<table id="stocklist">
    <thead>
		<th>#</th>
		<th>Drug Name</th>
		<th>Drug Category</th>
		<th>Formulation</th>
		<th>Current Qty</th>
		<th>Reorder Point</th>
    </thead>
    <tbody data-bind="foreach: stockItems">
		<td data-bind="text: \$index() + 1"></td>
		<td>
			<a data-bind="html: drug.name,click:\$parent.viewDetails"></a>
		</td>
		
		<td data-bind="text: drug.category.name"></td>
		<td>
			<span data-bind="text: formulation.name"></span>: <span data-bind="text: formulation.dozage"></span>
		</td>
		
		<td data-bind="text: currentQuantity"></td>
		<td data-bind="text: drug.reorderQty"></td>
    </tbody>
</table>
