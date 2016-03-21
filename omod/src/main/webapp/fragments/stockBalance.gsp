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

<table id="stocklist">
    <thead>
    <th>Drug Name</th>
    <th>Drug Category</th>
    <th>Formulation</th>
    <th>Current Qty</th>
    <th>Reorder Point</th>
    </thead>
    <tbody data-bind="foreach: stockItems">
    <td><a data-bind="html: drug.name,click:\$parent.viewDetails"></a></td>
    <td data-bind="text: drug.category.name"></td>
    <td data-bind="text: formulation.name"></td>
    <td data-bind="text: currentQuantity"></td>
    <td data-bind="text: drug.reorderQty"></td>
    </tbody>
</table>
