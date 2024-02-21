<html>
<head>
<style>
    body {
        font-family: sans-serif;
    }
    table {
        border-collapse: collapse;
    }
    table, th, td {
        border: 1px solid black;
        vertical-align: top;
    }
    th { text-align: left;
        padding: 0.2em 0.5em 0.2em 0.5em;
    }
    td {
        padding: 0.2em 0.5em 0.2em 0.5em;
    }
    th {
        background-color: #444;
        color: #FFF;
    }
    td.nowrap {
        white-space: nowrap;
    }
    table.requests {
        width: 100%
    }
    table.requests tr.overview {
        background-color: #F0F0F0;
    }
    table.requests tr.details {
        display: none;
        opacity: 0.7;
    }
    div.details {
        margin: 32px;
    }
    div.body {
        background-color: #F0F0F0;
        margin-top: 1em;
        padding: 1em;
        font-family: monospace;
        overflow-x: auto;
        width: 1024px;
    }
</style>
</head>
<body>
    <table class="requests">
        <tr>
            <th>Date / time</th>
            <th>Status</th>
            <th>Remote addr</th>
            <th>Host</th>
            <th>Method</th>
            <th>Request</th>
            <th>User Agent</th>
            <th>Main err</th>
            <th></th>
        </tr>
        {% for entry in entries%}
            <tr class="overview">
            <td>{{ entry["transaction"]["time_stamp"]|e }}</td>
            <td><tt>{{ entry["transaction"]["response"]["http_code"]|e }}</tt></td>
            <td><tt>{{ entry["transaction"]["client_ip"]|e }}</tt></td>
            <td><tt>{{ entry["transaction"]["request"]["headers"]["host"]|e }}</tt></td>
            <td><tt>{{ entry["transaction"]["request"]["method"]|e }}</tt></td>
            <td><tt>{{ entry["transaction"]["request"]["uri"]|e }}</tt></td>
            <td><tt>{{ entry["transaction"]["request"]["headers"]["user-agent"]|e }}</tt></td>
            <td>
                {% if entry["errors"] %}
                     {{ entry["errors"]|e }}
                {% else %}
                    <i>None</i>
                {% endif %}
            </td>
            <td><a href="#" onClick="return showDetails(this);">Details</a></td>
            </tr>

            <tr class="details">
            <td colspan="6">
                <div class="details">
                    <h2>ModSecurity Transaction ID</h2>
                    <p><tt>{{ entry["transaction"]["unique_id"]|e }}</tt></p>

                    <h2>Errors</h2>
                    {% if not entry["errors"] %}
                        <i>None</i>
                    {% else %}
                        <table class="details">
                            <thead>
                                <tr>
                                    <th>Rule</th>
                                    <th>File</th>
                                    <th>Severity</th>
                                    <th>Message</th>
                                    <th>Severity</th>
                                </tr>
                            </thead>
                            <tbody>
                                {% for message in entry["transaction"]['messages'] %}
                                    <tr>
                                        <td class="nowrap"><tt>{{ message.details.ruleId|e }}</td>
                                        <td class="nowrap"><tt>{{ message.details.file|e }}</td>
                                        <td>{{ message.details.lineNumber|e }}</td>
                                        <td>{{ message.message|e }}</td>
                                        <td>{{ message.details.severity|e }}</td>
                                    </tr>
                                {% endfor %}
                            </tbody>
                        </table>
                    {% endif %}

                    <h2>Request</h2>
                    <table class="details">
                        <tr>
                            <th>Header</th>
                            <th>Value</th>
                        </tr>
                        {% for header_k, header_v in entry["transaction"]["request"]["headers"].items() %}
                            <tr>
                                <td><tt>{{ header_k|e }}</tt></td>
                                <td><tt>{{ header_v|e }}</tt></td>
                            </tr>
                        {% endfor %}
                    </table>

                    {% if entry["transaction"]["request"]["body"] %}
                        <h3>Body</h3>
                        <div class="body">{{ "<br><hr><br>".join(entry["transaction"]["request"]["body"])|e }}</div>
                    {% else %}
                        <p><i>No request body</i></p>
                    {% endif %}

                    <h2>Response</h2>
                    <table class="details">
                        <tr>
                            <th>Header</th>
                            <th>Value</th>
                        </tr>
                        {% for header_k, header_v in entry["transaction"]["response"].get("headers", {}).items() %}
                            <tr>
                                <td><tt>{{ header_k|e }}</tt></td>
                                <td><tt>{{ header_v|e }}</tt></td>
                            </tr>
                        {% endfor %}
                    </table>

                    {% if entry["transaction"]["response"]["body"] %}
                        <h3>Body</h3>
                        <div class="body">{{ entry["transaction"]["response"]["body"]|e }}</div>
                    {% else %}
                        <p><i>No response body</i></p>
                    {% endif %}
                </div>
            </td>
            </tr>
        {% endfor %}
    </table>

    <script>
        function showDetails(el) {
            console.log("triggered");
            detailsTableRow = el.parentElement.parentElement.nextSibling.nextSibling;
            console.log(detailsTableRow.style.display);
            if (detailsTableRow.style.display != "table-row") {
                detailsTableRow.style.display = "table-row";
            } else {
                detailsTableRow.style.display = "none";
            }
            return false;
        }
    </script>
</body>
</html>