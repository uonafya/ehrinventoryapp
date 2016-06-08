<%
    ui.decorateWith("appui", "standardEmrPage", [title: "View Drug Stock"])
	ui.includeJavascript("billingui", "moment.js")
	ui.includeJavascript("billingui", "jq.print.js")
	
    def props = [	"transaction.typeTransactionName",
					"openingBalance",
					"quantity",
					"issueQuantity",
					"closingBalance",
					"dateExpiry",
					"receiptDate" ]
%>

<script>
    jq(function (){
        jq.getJSON('${ui.actionLink("inventoryapp", "viewCurrentStockBalanceDetail", "viewCurrentStockBalanceDetail")}', {
			drugId :${drugId},
			formulationId: ${formulationId},
			expiry: ${expiry},
			"currentPage": 1
		}).success(function (data) {
			
			if (data.length === 0 && data != null) {
				jq('#expiry-detail-results-table > tbody > tr').remove();
				var tbody = jq('#expiry-detail-results-table > tbody');
				
				var row = '<tr align="center">';
				row += '<td></td>';
				row += '<td colspan="7">No Records Found</td>';
				row += '</tr>';
				
				tbody.append(row);
			} else {
				updateQueueTable(data)
			}
		});
		
		jq('.cancel').click(function(){
			var receiptsLink = emr.pageLink("inventoryapp", "main");
			window.location = receiptsLink.substring(0, receiptsLink.length - 1);
		});
		
		jq('.task').click(function(){
			jq("#print-section").print({
				globalStyles: 	false,
				mediaPrint: 	false,
				stylesheet: 	'${ui.resourceLink("inventoryapp", "styles/print-out.css")}',
				iframe: 		false,
				width: 			980,
				height:			700
			});
		});
    });

    function updateQueueTable(tests) {
        jq('#expiry-detail-results-table > tbody > tr').remove();
        var tbody = jq('#expiry-detail-results-table > tbody');
        for (index in tests) {
            var row = '<tr>';
            var item = tests[index];
			
			row += '<td>' + (1+parseInt(index)) + '</td>';
			row += '<td>' + item.transaction.typeTransactionName + '</td>';
			row += '<td>' + item.openingBalance + '</td>';
			row += '<td>' + item.quantity + '</td>';
			row += '<td>' + item.issueQuantity + '</td>';
			row += '<td>' + item.closingBalance + '</td>';
			row += '<td>' + item.dateExpiry.substring(0, 11).replaceAt(2, ",").replaceAt(6, " ").insertAt(3, 0, " ") + '</td>';
			row += '<td>' + item.receiptDate.substring(0, 11).replaceAt(2, ",").replaceAt(6, " ").insertAt(3, 0, " ") + '</td>';
            row += '</tr>';
            tbody.append(row);
        }
    }
</script>

<style>
	.new-patient-header .identifiers {
		margin-top: 5px;
	}
	.name {
		color: #f26522;
	}
	#inline-tabs{
		background: #f9f9f9 none repeat scroll 0 0;
	}
	#breadcrumbs a, #breadcrumbs a:link, #breadcrumbs a:visited {
		text-decoration: none;
	}
	#show-icon{
		background: rgba(0, 0, 0, 0) url("../ms/uiframework/resource/inventoryapp/images/inventory-icon.png") no-repeat scroll 0 0 / 100% auto;
		display: inline-block;
		float: right;
		height: 50px;
		margin-bottom: -40px;
		margin-top: 10px;
		width: 60px;
	}
	.exampler {
		background-color: #fff;
		border: 1px solid #ddd;
		border-radius: 2px;
		display: block;
		margin: 65px 0 3px;
		padding: 10px;
		position: relative;
	}
	.exampler::after {
		background: #f9f9f9 none repeat scroll 0 0;
		border: 1px solid #ddd;
		color: #969696;
		content: "Drug Summary";
		font-size: 12px;
		font-weight: bold;
		left: -1px;
		padding: 5px 10px;
		position: absolute;
		top: -29px;
	}
	.exampler div {
		background: rgba(0, 0, 0, 0) url("../ms/uiframework/resource/inventoryapp/images/drugs-icon.jpg") no-repeat scroll 10px 0 / auto 100%;
		padding-left: 90px;
		color: #363463;
	}
	.exampler div span{
		color: #555;
		float: left;
		font-size: 0.9em;
		text-transform: uppercase;
		width: 120px;
	}
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
                <a href="${ui.pageLink('referenceapplication', 'home')}">
					<i class="icon-home small"></i>
				</a>
            </li>
			
			<li>
                <a href="${ui.pageLink('inventoryapp', 'main')}">
					<i class="icon-chevron-right link"></i>Inventory
				</a>
            </li>

            <li>
                <i class="icon-chevron-right link"></i>
                Current Drug Stock
            </li>
        </ul>
    </div>
	
	<div class="patient-header new-patient-header">
		<div class="demographics">
            <h1 class="name" style="border-bottom: 1px solid #ddd;">
                <span>VIEW CURRENT DRUG STOCK &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span>
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
					<img width="100" height="100" align="center" title="Afya EHRS" alt="Afya EHRS" src="${ui.resourceLink('billingui', 'images/kenya_logo.bmp')}">				
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
					<th>#</th>
					<th>TRANSACTION</th>
					<th>OPENING</th>
					<th>RECEIVED</th>
					<th>USED</th>
					<th>CLOSING</th>
					<th>EXPIRY DATE</th>
					<th>RECEIPT DATE</th>
				</thead>

				<tbody role="alert" aria-live="polite" aria-relevant="all">
					<tr align="center">
						<td colspan="8">No Drugs found</td>
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