<%
	ui.decorateWith("kenyaemr", "standardPage")
	ui.includeCss("ehrinventoryapp", "views.css")
	ui.includeJavascript("ehrcashier", "jq.print.js")
	ui.includeJavascript("ehrconfigs", "jquery-ui-1.9.2.custom.min.js")
	ui.includeJavascript("ehrconfigs", "underscore-min.js")
	ui.includeJavascript("ehrconfigs", "knockout-3.4.0.js")
	ui.includeJavascript("ehrconfigs", "emr.js")
	ui.includeCss("ehrconfigs", "jquery-ui-1.9.2.custom.min.css")
	// toastmessage plugin: https://github.com/akquinet/jquery-toastmessage-plugin/wiki
	ui.includeJavascript("ehrconfigs", "jquery.toastmessage.js")
	ui.includeCss("ehrconfigs", "jquery.toastmessage.css")
	// simplemodal plugin: http://www.ericmmartin.com/projects/simplemodal/
	ui.includeJavascript("ehrconfigs", "jquery.simplemodal.1.4.4.min.js")
	ui.includeCss("ehrconfigs", "referenceapplication.css")
%>

<script>
    jq(function (){
        jq.getJSON('${ui.actionLink("ehrinventoryapp", "viewStockBalanceDetail", "viewStockBalanceDetail")}', {
			drugId :${drugId},
			formulationId: ${formulationId},
			expiry: ${expiry},
			"currentPage": 1
		}).success(function (data) {
			if (data.length === 0 && data != null) {
				jq('#expiry-detail-results-table > tbody > tr').remove();
				
				var row = '<tr align="center">';
				row += '<td>0</td>';
				row += '<td colspan="7">No Records Found</td>';
				row += '</tr>';
				
				tbody.append(row);
			} else {
				updateQueueTable(data)
			}
		});
    });
	
    //update the queue table
    function updateQueueTable(tests) {
        jq('#expiry-detail-results-table > tbody > tr').remove();
        var tbody = jq('#expiry-detail-results-table > tbody');

        for (index in tests) {
			var row = '<tr>';
            var item = tests[index];
			var attr = 'B';
			
			if (item.drug.attribute == 1){
				attr = 'A';
			}
			
			var dateManufacture = item.dateManufacture;
			
			if (!dateManufacture){
				dateManufacture = 'N/A';
			}
			else{
				dateManufacture.substring(0, 11).replaceAt(2, ",").replaceAt(6, " ").insertAt(3, 0, " ");
			}
            
			row += '<td>' + (1+parseInt(index)) + '</td>';
			row += '<td>' + item.transaction.typeTransactionName + '</td>';
			row += '<td>' + item.openingBalance + '</td>';
			row += '<td>' + item.issueQuantity + '</td>';
			row += '<td>' + item.currentQuantity + '</td>';
			row += '<td>' + item.closingBalance + '</td>';
			
			
			row += '<td>' + dateManufacture + '</td>';
			row += '<td>' + item.dateExpiry.substring(0, 11).replaceAt(2, ",").replaceAt(6, " ").insertAt(3, 0, " ") + '</td>';

            row += '</tr>';
            tbody.append(row);
        }
		
		jq('.cancel').click(function(){
			var receiptsLink =ui.pageLink("ehrinventoryapp", "main");
			window.location = receiptsLink.substring(0, receiptsLink.length - 1)+'#manage';
		});
		
		jq('.task').click(function(){
			jq("#print-section").print({
				globalStyles: 	false,
				mediaPrint: 	false,
				stylesheet: 	'${ui.resourceLink("pharmacyapp", "styles/print-out.css")}',
				iframe: 		false,
				width: 			980,
				height:			700
			});
		});
    }
</script>

<style>
	.button{
		margin-top: 10px;
	}
	.print-only{
		display: none;
	}
</style>

<div class="clear"></div>

<div class="container">
	<div class="example">
        <ul id="breadcrumbs">
            <li>
                <a href="${ui.pageLink('kenyaemr', 'userHome')}">
					<i class="icon-home small"></i>
				</a>
            </li>
			
			<li>
                <a href="${ui.pageLink('ehrinventoryapp', 'main')}">
					<i class="icon-chevron-right link"></i>Inventory
				</a>
            </li>

            <li>
                <i class="icon-chevron-right link"></i>
                Expired Drug Stock
            </li>
        </ul>
    </div>
	
	<div class="patient-header new-patient-header">
		<div class="demographics">
            <h1 class="name" style="border-bottom: 1px solid #ddd;">
                <span>VIEW EXPIRED DRUGS STOCK &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span>
            </h1>
        </div>
		
		<div id="show-icon">
			&nbsp;
		</div>
		
		<div class="exampler">
			
			<div>
				<span>Drug Name:</span><b>${drug.name}</b><br/>
				<span>Category:</span>${drug.category.name}<br/>
				<span>Formulation:</span>${formulation.name}: ${formulation.dozage}<br/>
			</div>
		</div>
	</div>
</div>

<div id="expiry-detail-results" style="display: block; margin-top:3px;">
    <div role="grid" class="dataTables_wrapper" id="expiry-detail-results-table_wrapper">
		<div id="print-section">
			<div class="print-only">
				<center>
					<img width="100" height="100" align="center" title="EHRS" alt="EHRS" src="${ui.resourceLink('ehrcashier', 'images/kenya_logo.bmp')}">
					<h2>${userLocation}</h2>
				</center>
				
				<div>
					<label>
						Drug Name:
					</label>
					<span>${drug.name}</span>
					<br/>
					
					<label>
						Category:
					</label>
					<span>${drug.category.name}</span>
					<br/>
					
					<label>
						Formulation:
					</label>
					<span>${formulation.name} ${formulation.dozage}</span>
					<br/>				
				</div>
			</div>
			
			<table id="expiry-detail-results-table" class="dataTable" aria-describedby="expiry-detail-results-table_info">
				<thead>
					<tr role="row">
						<th>#</th>
						<th>TRANSACTION</th>
						<th>OPENING</th>
						<th>ISSUED</th>
						<th>RECEIVED</th>
						<th>CLOSING</th>
						<th>MANUFACTURED</th>
						<th>EXPIRY DATE</th>
					</tr>
				</thead>

				<tbody role="alert" aria-live="polite" aria-relevant="all">
					<tr align="center">
						<td colspan="6">No Drugs found</td>
					</tr>
				</tbody>
			</table>
			
			<div class='print-only' style="padding-top: 30px">
				<span>Signature of sub-store/ Stamp</span>
				<span style="float:right;">Signature of inventory clerk/ Stamp</span>
			</div>	
		</div>	
		
		<div>
			<span class="button cancel">Cancel</span>
			<span class="button task right">
				<i class="icon-print small"></i>
				Print
			</span>		
		</div>

    </div>
</div>



