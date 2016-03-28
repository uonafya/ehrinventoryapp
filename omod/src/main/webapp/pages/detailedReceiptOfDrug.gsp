<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Inventory Module"])

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
</script>
<script>

    jQuery(document).ready(function () {
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


</script>
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
        <th>costToPatient</th>
        <th>InstitutionalCost</th>
        <th>totalPrice</th>
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
    <td>${pTransaction.costToPatient}</td>
    <td>${pTransaction.costToPatient}</td>
    <td>${pTransaction.unitPrice}</td>
    <td>${pTransaction.totalPrice}</td>
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
