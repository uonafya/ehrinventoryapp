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
    INDENT= {

        detailDrugIndent: function (indentId) {
            if (SESSION.checkSession()) {
                url = "detailDrugIndent.form?indentId=" + indentId + "&keepThis=false&TB_iframe=true&height=500&width=1000";
                tb_show("Detail Indent Drug....", url, false);
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
        <tr align="center">
            <th>category</th>
            <th>name</th>
            <th>formulation</th>
            <th>indentQuantity</th>
            <th>transferQuantity</th>
            <th>batchNo</th>
            <th>companyName</th>
            <th>dateExpiry</th>
            <th>receiptDate</th>
        </tr>
        <% if (listTransactionDetail!=null || listTransactionDetail!="") { %>
        <% listTransactionDetail.each { pTransaction -> %>
        <tr align="center" class=' ' >
            <td>${pTransaction.drug.category.name}</td>
            <td>${pTransaction.drug.name}</td>
            <td>${pTransaction.formulation.name}-${pTransaction.formulation.dozage}</td>
            <td>${listIndentDetail.quantity}</td>
            <td>${listIndentDetail.mainStoreTransfer}
            <td>${pTransaction.batchNo}</td>
            <td>${pTransaction.companyName}</td>
            <td>${pTransaction.dateExpiry}</td>
            <td>${pTransaction.createdOn}</td>



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
