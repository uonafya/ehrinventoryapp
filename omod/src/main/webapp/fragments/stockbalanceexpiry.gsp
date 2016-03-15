<%
    def props = ["drug.name","drug.category.name", "formulation.dozage", "currentQuantity", "reorderPoint","action"]
%>

<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.11.0/moment.js"></script>
<script>
    jq(function (){
            jq.getJSON('${ui.actionLink("inventoryapp", "StockBalanceExpiry", "viewStockBalanceExpiry")}',
                    {
                        "currentPage": 1
                    } ).success(function (data) {
                        console.info(data);
                        if (data.length === 0 && data != null) {
                            jq().toastmessage('showNoticeToast', "No drug found!");
                        } else {
                            updateQueueTable(data)
                        }
            });
    });
</script>
<script>
    //update the queue table
    function updateQueueTable(tests) {
        var jq = jQuery;
        jq('#expiry-search-results-table > tbody > tr').remove();
        var tbody = jq('#expiry-search-results-table > tbody');
        var row = '<tr>';
        for (index in tests) {
            var item = tests[index];

            <% props.each {
              if(it == props.last()){
                  def pageLinkEdit = ui.pageLink("", "");
                      %>
            row += '<td> <a title="" href="?patientId=' +
                    item.patientIdentifier + '&revisit=true"><i class="icon-arrow-right small" ></i></a>';

            <% } else {%>

            row += '<td>' + item.${ it } + '</td>';
            <% }
              } %>
            row += '</tr>';
            tbody.append(row);
        }
    }
</script>

<div id="expiry-search-results" style="display: block; margin-top:3px;">
    <div role="grid" class="dataTables_wrapper" id="expiry-search-results-table_wrapper">
        <table id="expiry-search-results-table" class="dataTable" aria-describedby="expiry-search-results-table_info">
            <thead>
            <tr role="row">
                <th class="ui-state-default" role="columnheader">
                    <div class="DataTables_sort_wrapper">drug<span class="DataTables_sort_icon"></span>
                    </div>
                </th>

                <th class="ui-state-default" role="columnheader" style="width:60px;">
                    <div class="DataTables_sort_wrapper">category<span class="DataTables_sort_icon"></span></div>
                </th>

                <th class="ui-state-default" role="columnheader" style="width:60px;">
                    <div class="DataTables_sort_wrapper">formulation<span class="DataTables_sort_icon"></span></div>
                </th>

                <th class="ui-state-default" role="columnheader" style="width: 60px;">
                    <div class="DataTables_sort_wrapper">currentQuantity<span class="DataTables_sort_icon"></span></div>
                </th>

                <th class="ui-state-default" role="columnheader" style="width:120px;">
                    <div class="DataTables_sort_wrapper">reorderPoint<span class="DataTables_sort_icon"></span></div>
                </th>

                <th class="ui-state-default" role="columnheader" style="width:120px;">
                    <div class="DataTables_sort_wrapper">action<span class="DataTables_sort_icon"></span></div>
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

