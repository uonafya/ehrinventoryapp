<%
    ui.decorateWith("kenyaemr", "standardPage")
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
    var delayTransfer = false;
    jq(function () {
        var storeIndent = ${listDrugNeedProcess};
        var pStoreIndent = storeIndent.listDrugNeedProcess;

        function IndentListViewModel() {
            var self = this;
            self.indentItems = ko.observableArray([]);
            var mappedStockItems = jQuery.map(pStoreIndent, function (item) {
                return new IndentItem(item);
            });

            self.viewDetails = function (item) {
                var value = item.initialItem().quantity;
                var mainStoreValue = item.initialItem().mainStoreTransfer;
                var x = item.transferQuantity();

                if (x != null && x != '') {
                    if (parseInt(x) > parseInt(value)) {
                        jq().toastmessage('showNoticeToast', "Transfer quantity more than order quantity!");
                        item.transferQuantity(value.toString());
                        delayTransfer = true;

                    } else if (parseInt(x) > parseInt(mainStoreValue)) {
                        jq().toastmessage('showNoticeToast', "Transfer quantity more than quantity at hand!");
                        item.transferQuantity(mainStoreValue.toString());
                        delayTransfer = true;
                    } else {
                        delayTransfer = false;
                    }
                }
            }

            self.transferIndent = function () {
                if (jq("#transferIndent").hasClass("disabled")) {
                    jq().toastmessage('showNoticeToast', "Transfer Not Allowed due to Insufficient Quantities!");
                } else if (delayTransfer) {
                    jq().toastmessage('showNoticeToast', "Transfer values were reset to Order quantities- cross-check before proceeding!");
                    delayTransfer=false;
                } else {
                    jq("#indentsForm").submit();
                }
            }

            self.refuseIndent = function () {
                if (confirm("Are you sure about this?")) {
                    jQuery('#tableIndent').remove();
                    jQuery("#refuse").val("1");
                    jQuery('#indentsForm').submit()
                } else {
                    return false;
                }

            }
            self.indentItems(mappedStockItems);
        }

        function IndentItem(initialItem) {
            var self = this;
            self.initialItem = ko.observable(initialItem);
            self.transferQuantity = ko.observable(String(Math.min(initialItem.mainStoreTransfer, initialItem.quantity)));

            self.compFormulation = ko.computed(function () {
                return initialItem.formulation.name + "-" + initialItem.formulation.dozage;
            });

            self.isDisabled = ko.computed(function () {
                return (self.initialItem().mainStoreTransfer <= 0);
            });
        }

        var list = new IndentListViewModel();
        ko.applyBindings(list, jq("#indentlist")[0]);
    });//end of doc ready

</script>

<style>
.new-patient-header .identifiers {
    margin-top: 5px;
}

.name {
    color: #f26522;
}

#inline-tabs {
    background: #f9f9f9 none repeat scroll 0 0;
}

#breadcrumbs a, #breadcrumbs a:link, #breadcrumbs a:visited {
    text-decoration: none;
}

#show-icon {
    background: rgba(0, 0, 0, 0) url("../ms/uiframework/resource/ehrinventoryapp/images/inventory-icon.png") no-repeat scroll 0 0 / 100% auto;
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
    content: "Order Summary";
    font-size: 12px;
    font-weight: bold;
    left: -1px;
    padding: 5px 10px;
    position: absolute;
    top: -29px;
}

.exampler div {
    background: rgba(0, 0, 0, 0) url("../ms/uiframework/resource/ehrinventoryapp/images/indent-icon.jpg") no-repeat scroll 10px 0 / auto 100%;
    padding-left: 90px;
    color: #363463;
}

.exampler div span {
    color: #555;
    float: left;
    font-size: 0.9em;
    text-transform: uppercase;
    width: 120px;
}

table {
    font-size: 14px;
}

th:first-child {
    width: 5px;
}

th:nth-child(4) {
    width: 80px;
}

th:nth-child(5) {
    width: 80px;
}

th:last-child {
    width: 160px;
}

#footer {
    height: 50px;
    margin-top: 5px;
}

#footer img {
    float: left;
    height: 20px;
    margin-right: 5px;
    margin-top: 6px;
}

#footer span {
    color: #777;
    float: left;
    font-size: 12px;
    margin-top: 8px;
}

#footer button {
    float: right;
}

.retired {
    text-decoration: line-through;
    color: darkgrey;
}
</style>


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
                Drug Receipt Details
            </li>
        </ul>
    </div>

    <div class="patient-header new-patient-header">
        <div class="demographics">
            <h1 class="name" style="border-bottom: 1px solid #ddd;">
                <span>PROCESS DRUG ORDER &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span>
            </h1>
        </div>

        <div id="show-icon">
            &nbsp;
        </div>

        <div class="exampler">
            <div>
                <span>Order Name:</span><b>${indent.name}</b><br/>
                <span>Created On:</span>${indent.createdOn}<br/>
                <span>Source Store:</span>${indent.store.name}<br/>
            </div>
        </div>
    </div>
</div>

<div id="indentlist" style="display: block; margin-top:3px;">
    <div method="post" class="box" id="formMainStoreProcessIndent">
        <table id="tableIndent">
            <thead>
            <th>#</th>
            <th>DRUG</th>
            <th>FORMULATION</th>
            <th>QUANTITY</th>
            <th>AVAILABLE</th>
            <th>TRANSFER</th>
            </thead>

            <tbody data-bind="foreach: indentItems ">
            <td data-bind="text: (\$index() + 1),css:{'retired': isDisabled()}"></td>
            <td data-bind="text: initialItem().drug.name,css:{'retired': isDisabled()}"></td>
            <td data-bind="text: compFormulation(),css:{'retired': isDisabled()}"></td>
            <td data-bind="text: initialItem().quantity,css:{'retired': isDisabled()}"></td>
            <td data-bind="text: initialItem().mainStoreTransfer,css:{'retired': isDisabled()}"></td>
            <td><input data-bind="value: transferQuantity, event:{blur:\$root.viewDetails},disable: isDisabled()"/></td>
            </tbody>

        </table>

        <form method="post" id="indentsForm" style="padding-top: 10px">
            <input type="hidden" name="indentId" id="indentId" value="${indent.id}">
            <input type="hidden" id="refuse" name="refuse" value="">
            <textarea name="drugIntents" data-bind="value: ko.toJSON(\$root)" style="display:none;"></textarea>

            <button id="transferIndent" data-bind="click:transferIndent, css: {'disabled':indentItems()[0].isDisabled} "
                    class="confirm"
                    style="float: right; margin-right: 2px;">Transfer</button>
            <button id="refuseIndent" data-bind="click: refuseIndent" class="cancel"
                    style="margin-left: 2px">Refuse Order</button>
        </form>

    </div>
</div>
