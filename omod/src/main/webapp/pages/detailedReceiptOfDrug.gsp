<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Drug Receipt Details"])

	ui.includeJavascript("ehrcashier", "jq.print.js")
	ui.includeJavascript("ehrconfigs", "jquery-1.12.4.min.js")
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
    jq(document).ready(function () {
		var simple = ${transactionDetails};
		var simpleObjects = simple.simpleObjects;
		
		updateQueueTable(simpleObjects);

        jq("#printButton").on("click", function(e){
			var emrLink = ui.pageLink('ehrinventoryapp','main');
				emrLink = emrLink.substring(0, emrLink.length-1)+'#receipts'
			
            jq("#print-section").print({
				globalStyles: 	false,
				mediaPrint: 	false,
				stylesheet: 	'${ui.resourceLink("ehrinventoryapp", "styles/print-out.css")}',
				iframe: 		false,
				width: 			1020,
				height:			700,
				redirectTo:		emrLink
			});
        });		
    });
	
	function updateQueueTable(dataRows) {
        jq('#print-table > tbody > tr').remove();
        var tbody = jq('#print-table > tbody');
		var arrln = ${arrayLength};

        for (index in dataRows) {
            var row = '<tr>';
            var item = dataRows[index];
			
			if (parseInt(arrln) !== 1){
				row += '<td>' + item.drug.name + '</td>';
				row += '<td>' + item.formulation.name+' '+item.formulation.dozage + '</td>';
			}
			
			row += '<td>' + String(item.quantity).formatToAccounting(0) + '</td>';
			row += '<td>' + String(item.unitPrice).formatToAccounting() + '</td>';
			row += '<td>' + String(item.VAT).formatToAccounting() + '%</td>';
			row += '<td>' + String(item.costToPatient).formatToAccounting() + '</td>';
			
			row += '<td>' + item.batchNo + '</td>';
			row += '<td>' + item.companyName + '</td>';
			row += '<td>' + item.dateManufacture.substring(0, 11).replaceAt(2, ",").replaceAt(6, " ") + '</td>';
			row += '<td>' + item.dateExpiry.substring(0, 11).replaceAt(2, ",").replaceAt(6, " ") + '</td>';
			
			row += '<td>' + item.createdOn.substring(0, 11).replaceAt(2, ",").replaceAt(6, " ") + '</td>';
			row += '<td>' + item.receiptFrom + '</td>';

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
	.exampler span span,
	.exampler div span{
		color: #555;
		float: left;
		font-size: 0.9em;
		text-transform: uppercase;
		width: 120px;
	}
	<% if (arrayLength == 1) {%>
		table{
			font-size: 14px;
		}
		td:first-child{
			width:30px;
		}
		td:nth-child(2),
		td:nth-child(3),
		td:nth-child(4){
			width:45px;
		}
		td:nth-child(7),
		td:nth-child(8),
		td:nth-child(9){
			width:80px;
		}
	<% } else { %>
		table{
			font-size: 11px;
		}
	<% } %>
	
	#footer{
		height: 50px;
		margin-top: 5px;
	}
	
	#footer img{
		float: left;
		height: 20px;
		margin-right: 5px;
		margin-top: 6px;
	}
	
	#footer span{
		color: #777;
		float: left;
		font-size: 12px;
		margin-top: 8px;
	}
	#footer button{
		float: right;
	}
	.print-only{
		display: none;
	}
	
	
</style>

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
                Drug Receipt Details
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
			<% if (arrayLength == 1) {%>
				<div style="display: inline-block;">
					<span>Drug Name:</span><b>${drug.name}</b><br/>
					<span>Category:</span>${drug.category.name}<br/>
					<span>Formulation:</span>${formulation.name}-${formulation.dozage}<br/>
				</div>
				
				<span style="display: inline-block; margin-left: 50px;">
					<span>Date Created:</span><em>${ui.formatDatePretty(createdOn)}</em><br/>
					<span>Receipt:</span><b>000${receiptId}</b><br/>
					<span>Description:</span><b>${description}</b><br/>
				</span>
			<% } else { %>
				<div>
					<span>Date Created:</span><em>${ui.formatDatePretty(createdOn)}</em><br/>
					<span>Receipt:</span><em>000${receiptId}</em><br/>
					<span>Description:</span><b>${description}</b><br/>
				</div>
			<% } %>
		</div>
	</div>
</div>

<div id="print-section" style="display: block; margin-top:3px;">
	<div class="print-only">
		<center>
			<img width="100" height="100" align="center" title="Afya EHRS" alt="Afya EHRS" src="${ui.resourceLink('billingui', 'images/kenya_logo.bmp')}">				
			<h2>${userLocation}<br/>RECEIPT TRANSACTION DETAILS</h2>
		</center>
		
		<div>
			<% if (arrayLength == 1) {%>
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
				
				<span class="right">${createdOn}</span>
				<label class="right">
					Date Created:
				</label>
				<br/>
			<% } else { %>
				<label>
					Date Created:
				</label>
				<span>${createdOn}</span>
				<br/>
				
				<label>
					Receipt:
				</label>
				<span>0000${receiptId}</span>
				<br/>
				
				<label>
					Description:
				</label>
				<span>${description}</span>
				<br/>
			<% } %>
			
		</div>
	</div>
	
	<% if (arrayLength == 1) {%>
		<table id="print-table" aria-describedby="expiry-detail-results-table_info">
			<thead>
				<tr align="center">
					<th title="Quantity"			>QTY</th>
					<th title="Unit Price"			>PRICE</th>
					<th title="Institutional Cost"	>I.COST</th>
					<th title="Cost To The Patient"	>COST</th>
					<th title="Batch Number"		>BATCH#</th>
					<th title="Company"				>COMPANY</th>
					<th title="Date of Manufacture"	>MANUF</th>
					<th title="Date of Manufacture"	>EXPIRY</th>
					<th title="Receipt Date"		>DATE</th>
					<th title="Receipt From"		>FROM</th>
				</tr>
			</thead>
			
			<tbody>
				<tr align="center">
					<td colspan="10">No Drugs found</td>
				</tr>
			</tbody>
		</table>	
	<% } else { %>
		<table id="print-table" aria-describedby="expiry-detail-results-table_info">
			<thead>
				<tr align="center">
					<th title="Name"				>NAME</th>
					<th title="Formulation"			>FORMULATION</th>
					<th title="Quantity"			>QTY</th>
					<th title="Unit Price"			>PRICE</th>
					<th title="Institutional Cost"	>I.COST</th>
					<th title="Cost To The Patient"	>COST</th>
					<th title="Batch Number"		>BATCH#</th>
					<th title="Company"				>COMPANY</th>
					<th title="Date of Manufacture"	>MANUF</th>
					<th title="Date of Manufacture"	>EXPIRY</th>
					<th title="Receipt Date"		>DATE</th>
					<th title="Receipt From"		>FROM</th>
				</tr>
			</thead>
			
			<tbody>
				<tr align="center">
					<td colspan="10">No Drugs found</td>
				</tr>
			</tbody>
		</table>	
	<% } %>
			
	
	<div class='print-only' style="padding-top: 30px">
        <span>Signature of sub-store/ Stamp</span>
		<span style="float:right;">Signature of inventory clerk/ Stamp</span>
    </div>
</div>

<div id="footer">
	<img src="../ms/uiframework/resource/inventoryapp/images/tooltip.jpg" />
	<span>Place the mouse over the Titles to get the meaning in full</span>
	
	<button class="button task" type="button" id="printButton"><i class="icon-print small"> </i>Print</button>
</div>
