<script>
	var showNotification = false;
    
	jq(function () {
        loadExpiredDrugs();

        //action when the drug category is selected
        jq("#categoryId").on("change", function () {
            var categoryId = jq("#categoryId").val();
            var drugName = jq("#drugName").val();
            loadExpiredDrugs(1, categoryId, drugName);

        });

        jq("#drugName").on("blur", function () {
            var categoryId = jq("#categoryId").val();
            var drugName = jq("#drugName").val();
//            TODO check fragment action for search functionality
            loadExpiredDrugs(1, categoryId, drugName);
        });


    });//end of doc ready

    function loadExpiredDrugs(currentPage, categoryId, drugName) {
        jq.getJSON('${ui.actionLink("inventoryapp", "StockBalanceExpiry", "viewStockBalanceExpiry")}',
		{
			currentPage: currentPage,
			categoryId: categoryId,
			drugName: drugName
		}).success(function (data) {
			if (data.length === 0 && data != null) {
				if (showNotification){
					jq().toastmessage('showErrorToast', "No records found");
				}
				
				jq('#expirylist > tbody > tr').remove();
				var tbody = jq('#expirylist > tbody');
				var row = '<tr align="center"><td>&nbsp;</td><td colspan="5">No Drugs found</td></tr>';
				tbody.append(row);
			} else {
				updateQueueTable(data);
			}
			showNotification = true;
			
		}).error(function () {
			if (showNotification){
				jq().toastmessage('showErrorToast', "No records found");
			}
			
			showNotification = true;
			
			jq('#expirylist > tbody > tr').remove();
			var tbody = jq('#expirylist > tbody');
			var row = '<tr align="center"><td>&nbsp;</td><td colspan="5">No Drugs found</td></tr>';
			tbody.append(row);
		});
    }
    //update the queue table
    function updateQueueTable(tests) {
        jq('#expirylist > tbody > tr').remove();
        var tbody = jq('#expirylist > tbody');

        for (index in tests) {
            var row = '<tr>';
            var item = tests[index];
			var pageLinkEdit = emr.pageLink("inventoryapp", "viewStockBalanceDetail", {
				drugId: item.drug.id,
				formulationId: item.formulation.id,
				expiry: 1
			});
			
			row += '<td>' + (1+parseInt(index)) + '</td>';
			row += '<td><a href="' + pageLinkEdit + '">' + item.drug.name + '</a></td>';
			row += '<td>' + item.drug.category.name + '</td>';
			row += '<td>' + item.formulation.name+ ': '+ item.formulation.dozage + '</td>';
			row += '<td>' + item.currentQuantity + '</td>';
			row += '<td>' + item.reorderPoint + '</td>';
			
            row += '</tr>';
            tbody.append(row);
        }
    }
</script>

<div class="dashboard clear">
	<div class="info-section">
		<div class="info-header">
			<i class="icon-calendar"></i>
			<h3>EXPIRED DRUGS</h3>
			
			
			<div>
				<i class="icon-filter" style="font-size: 26px!important; color: #5b57a6"></i>
				
				<label for="categoryId">Category:</label>
				<select name="categoryId" id="categoryId" style="width: 200px;">
					<option value="">ALL CATEGORIES</option>
					<% listCategory.each { %>
						<option value="${it.id}" title="${it.name}">${it.name}</option>
					<% } %>
				</select>
				
				<label for="drugName">&nbsp; &nbsp;Name:</label>
				<input type="text" name="drugName" id="drugName" placeholder=" Drug Name"/>
				
				<a class="button task" href="#">
					Search
				</a>
			</div>
			
		</div>
	</div>
</div>


<table id="expirylist">
	<thead>
		<th>#</th>
		<th>DRUG NAME</th>
		<th>CATEGORY</th>
		<th>FORMULATION</th>
		<th>QUANTITY</th>
		<th>RE-ORDER</th>
    </thead>
	
	<tbody role="alert" aria-live="polite" aria-relevant="all">
	<tr align="center">
		<td colspan="6">No Drugs found</td>
	</tr>
	</tbody>
</table>



