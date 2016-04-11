<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Drug Receipt Details"])

    ui.includeCss("billingui", "jquery.dataTables.min.css")
    ui.includeCss("registration", "onepcssgrid.css")

    ui.includeJavascript("billingui", "moment.js")
    ui.includeJavascript("billingui", "jquery.dataTables.min.js")
    ui.includeJavascript("laboratoryapp", "jq.browser.select.js")
    ui.includeJavascript("billingui", "jquery.PrintArea.js")
%>

<script>
    RECEIPT= {

        detailReceiptDrug: function (receiptId) {
            if (SESSION.checkSession()) {
                url = "drugReceiptDetail.form?receiptId=" + receiptId + "&keepThis=false&TB_iframe=true&height=500&width=1000";
                tb_show("Detail Receipt Drug....", url, false);
            }
        }
    }

    jq(document).ready(function () {
		console.log(jq('.exampler').html().replaceStrings());
         
		function print () {
            var printDiv = jQuery("#print").html();
            var printWindow = window.open('', '', 'height=400,width=800');
            printWindow.document.write('<html><head><title>Information</title>');
            printWindow.document.write(printDiv);
            printWindow.document.write('</body></html>');
            printWindow.document.close();
            printWindow.print();
        }

        jQuery("#printButton").on("click", function(e){
            print().show();
        });
    });
	
	String.prototype.replaceStringx = function() {
		var res = this.replace("[", "");
		res=res.replace("]","");
		return res;
	}
	
	String.prototype.replaceStrings = function(search, replacement) {
		var res = this.replace(/\\[/g, '');
			res = this.replace(/]/g, '');
		return res;
	};


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
			<div>
				<span>Drug Name:</span><b>${drug.name}</b><br/>
				<span>Category:</span>${drug.category.name}<br/>
				<span>Formulation:</span>${transactionDetails.formulation.name}: ${transactionDetails.formulation.dozage}<br/>
			</div>
		</div>
	</div>

	
</div>


<div id="print">
<table cellpadding="5" cellspacing="0" width="100%" id="queueList">
    <h>
        Receipt List

    </h>
    <tr align="center">
        <th>category</th>
        <th>name</th>
        <th>formulation</th>
        <th>receiptQuantity</th>
        <th>Unit Price</th>
        <th>Institutional Cost(%)</th>
        <th>Cost To The Patient</th>
         <th>batchNo</th>
        <th>companyName</th>
        <th>dateManufacture</th>
        <th>dateExpiry</th>
        <th>receiptDate</th>
        <th>receiptFrom</th>
    </tr>
    <% if (transactionDetails!=null || transactionDetails!="") { %>
    <% transactionDetails.each { pTransaction -> %>
    <tr align="center" class=' ' >
    <td>${pTransaction.drug.category.name}</td>
    <td>${pTransaction.drug.name}</td>
    <td>${pTransaction.formulation.name}-${pTransaction.formulation.dozage}</td>
    <td>${pTransaction.quantity}</td>
    <td>${pTransaction.unitPrice}</td>
    <td>${pTransaction.costToPatient}</td>
    <td>${pTransaction.costToPatient}</td>
    <td>${pTransaction.batchNo}</td>
    <td>${pTransaction.companyName}</td>
    <td>${pTransaction.dateManufacture}</td>
    <td>${pTransaction.dateExpiry}</td>
    <td>${pTransaction.createdOn}</td>
    <td>${pTransaction.receiptFrom}</td>
    <% } %>
    <% } else { %>
    <tr align="center" >
        <td colspan="9">No drug found</td>
    </tr>
    <% } %>
</table>
</div>
<div>
<button class="button" type="button" id="printButton">Print</button>
</div>
