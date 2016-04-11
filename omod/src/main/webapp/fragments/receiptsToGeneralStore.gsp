<%
	ui.includeJavascript("billingui", "moment.js")
%>

<script>
    var receiptsDataString;
	
    jq(function () {
        var receiptsData = getReceitsToGeneralStore();
        receiptsDataString = JSON.stringify(receiptsData);
        function ReceiptsDataListView() {
            var self = this;
            // Editable data
            self.receiptsDataItems = ko.observableArray([]);
            ;
            var mappedReceiptsDataItems = jQuery.map(receiptsData, function (item) {
                return item;
            });

            self.viewDetails = function (item) {
                window.location.replace("detailedReceiptOfDrug.page?receiptId=" + item.id);

            }
            self.receiptsDataItems(mappedReceiptsDataItems);

        }

        var list = new ReceiptsDataListView();
        ko.applyBindings(list, jq("#receiptslist")[0]);
    });
	
    function getReceitsToGeneralStore(receiptName, fromDate, toDate) {
        var toReturn;
        jQuery.ajax({
            type: "GET",
            url: '${ui.actionLink("inventoryapp", "receiptsToGeneralStore", "fetchReceiptsToGeneralStore")}',
            dataType: "json",
            global: false,
            async: false,
            data: {
                receiptName: receiptName,
                fromDate: fromDate,
                toDate: toDate
            },
            success: function (data) {
                toReturn = data;
            }
        });
        return toReturn;
    }
</script>

<style>
	
</style>

<div class="dashboard clear">
	<div class="info-section">
		<div class="info-header">
			<i class="icon-list-ul"></i>
            <h3>RECEIPT DRUGS</h3>
			
			<div>
				<i class="icon-filter" style="font-size: 26px!important; color: #5b57a6"></i>
				
				<label for="receiptName">Description</label>
				<input type="text" id="receiptName" name="receiptName" placeholder="Receipt Name" class="searchFieldBlur" title="Receipt Name"/>
				${ui.includeFragment("uicommons", "field/datetimepicker", [formFieldName: 'lastDayOfVisit', id: 'rcptFrom', label: '', useTime: false, defaultToday: false, class: ['newdtp']])}
			</div>
			
			
		</div>
	</div>
</div>

<div>
	
	<label for="rFromDate">From</label>
	<input type="text" id="rFromDate" class="date-pick searchFieldChange searchFieldBlur" readonly="readonly"
		   name="rFromDate"
		   title="Double Click to Clear" ondblclick="this.value = '';"/>
	<label for="toDate">To</label>
	<input type="text" id="toDate" class="date-pick searchFieldChange searchFieldBlur" readonly="readonly" name="toDate"
		   title="Double Click to Clear" ondblclick="this.value = '';"/>
</div>

<table id="receiptslist">
    <thead>
		<th>#</th>
		<th>DATE CREATED</th>
		<th>DESCRIPTION</th>
		<th>STORE</th>
		<th>Notes</th>
    </thead>
    <tbody data-bind="foreach: receiptsDataItems">
		<td data-bind="text: \$index() + 1"></td>
		<td data-bind="text: (createdOn).substring(0, 11).replaceAt(2, ',').replaceAt(6, ' ').insertAt(3, 0, ' ') "></td>
		<td><a data-bind="html:description ,click:\$parent.viewDetails"></a></td>
		<td data-bind="text:store.name"></td>
		<td>N/A</td>
    </tbody>
</table>

<a href="addReceiptsToGeneralStore.page">Add Receipts</a>
