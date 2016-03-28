<%
    ui.decorateWith("appui", "standardEmrPage", [title: "View Drug Stock"])
    def props = ["drug.name","drug.category.name","formulation.dozage","transaction.typeTransactionName","openingBalance","quantity","issueQuantity","closingBalance","dateExpiry","receiptDate"
    ]

%>

<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.11.0/moment.js"></script>
<script>
    jq(function (){

        jq.getJSON('${ui.actionLink("inventoryapp", "viewCurrentStockBalanceDetail", "viewCurrentStockBalanceDetail")}',
                {
                    drugId :${drugId},
                    formulationId: ${formulationId},
                    expiry: ${expiry},
                    "currentPage": 1
                } ).success(function (data) {
                    if (data.length === 0 && data != null) {
                        jq().toastmessage('showNoticeToast', "No drug found!");
                    } else {
                        updateQueueTable(data)
                    }
                });

    })

</script>
<script>
    //update the queue table
    function updateQueueTable(tests) {
        console.info(tests);
        var jq = jQuery;
        jq('#expiry-detail-results-table > tbody > tr').remove();
        var tbody = jq('#expiry-detail-results-table > tbody');

        for (index in tests) {
            var row = '<tr>';
            var item = tests[index];
            <% props.each { %>

            row += '<td>' + item.${ it } + '</td>';
            <%  } %>

            row += '</tr>';
            tbody.append(row);
        }
    }
</script>

<div id="expiry-detail-results" style="display: block; margin-top:3px;">

    <div role="grid" class="dataTables_wrapper" id="expiry-detail-results-table_wrapper">
        <table id="expiry-detail-results-table" class="dataTable" aria-describedby="expiry-detail-results-table_info">
            <thead>
            <tr role="row">
                <th class="ui-state-default" role="columnheader">
                    <div class="DataTables_sort_wrapper">drug<span class="DataTables_sort_icon"></span>
                    </div>
                </th>

                <th class="ui-state-default" role="columnheader">
                <div class="DataTables_sort_wrapper">category<span class="DataTables_sort_icon"></span></div>
            </th>

                <th class="ui-state-default" role="columnheader">

                    <div class="DataTables_sort_wrapper">formulation<span class="DataTables_sort_icon"></span></div>
                </th>

                <th class="ui-state-default" role="columnheader">

                    <div class="DataTables_sort_wrapper">transaction<span class="DataTables_sort_icon"></span></div>
                </th>

                <th class="ui-state-default" role="columnheader" >
                    <div class="DataTables_sort_wrapper">openingBalance<span class="DataTables_sort_icon"></span></div>
                </th>

                <th class="ui-state-default" role="columnheader" >
                    <div class="DataTables_sort_wrapper">receiptQuantity<span class="DataTables_sort_icon"></span></div>
                </th>

                <th class="ui-state-default" role="columnheader" >
                    <div class="DataTables_sort_wrapper">stockIssued<span class="DataTables_sort_icon"></span></div>
                </th>

                <th class="ui-state-default" role="columnheader" >
                    <div class="DataTables_sort_wrapper">closingBalance<span class="DataTables_sort_icon"></span></div>
                </th>

                <th class="ui-state-default" role="columnheader">
                    <div class="DataTables_sort_wrapper">dateExpiry<span class="DataTables_sort_icon"></span></div>
                </th>

                <th class="ui-state-default" role="columnheader">
                    <div class="DataTables_sort_wrapper">receiptDate<span class="DataTables_sort_icon"></span></div>
                </th>

            </tr>
            </thead>

            <tbody role="alert" aria-live="polite" aria-relevant="all">
            <tr align="center">
                <td colspan="6">No Drugs found</td>
            </tr>
            </tbody>
        </table>

    </div>
</div>


