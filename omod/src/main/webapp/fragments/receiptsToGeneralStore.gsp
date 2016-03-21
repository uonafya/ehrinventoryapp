<script>
    var receiptsDataString;
    jq(function(){
        var receiptsData = getReceitsToGeneralStore();
        receiptsDataString = JSON.stringify(receiptsData);
        function ReceiptsDataListView(){
            var self = this;
            // Editable data
            self.receiptsDataItems = ko.observableArray([]);;
            var mappedReceiptsDataItems = jQuery.map(receiptsData, function (item) {
                return item;
            });

            self.viewDetails = function(item){
                window.location.replace("detailedReceiptOfDrug.page?receiptId="+item.id);

            }
            self.receiptsDataItems(mappedReceiptsDataItems);

        }

        var list = new ReceiptsDataListView();
        ko.applyBindings(list, jq("#receiptslist")[0]);
    });
    function getReceitsToGeneralStore() {
        var toReturn;
        jQuery.ajax({
            type: "GET",
            url: '${ui.actionLink("inventoryapp", "receiptsToGeneralStore", "fetchReceiptsToGeneralStore")}',
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

<table id="receiptslist">
    <thead>
        <th>S.No</th>
        <th>Description</th>
        <th>Created On</th>
    </thead>
    <tbody data-bind="foreach: receiptsDataItems">
        <td data-bind="text: \$index() + 1"></td>
        <td><a data-bind="html:description ,click:\$parent.viewDetails"></a></td>
        <td data-bind="text: createdOn"></td>
    </tbody>
</table>
