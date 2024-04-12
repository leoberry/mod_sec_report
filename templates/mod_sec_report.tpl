<html>
<head>
<style>
    body {
        font-family: sans-serif;
    }

    header {
        background-color: #E5EFF7;
        color: black;
        padding: 30px;
        text-align: center;
    }

    #logo {
        width: 100px;
        height: 100px;
        background: url('https://repository-images.githubusercontent.com/363010961/42a98c00-a969-11eb-946f-2762be8c7d73') no-repeat;
        background-size: cover;
        display: inline-block;
        float: left;
    }

    table {
        border-collapse: collapse;
        border-radius: 15px;
        box-sizing: border-box;
    }
    tr {
        border: 1px solid #1A1A1A;
        box-sizing: border-box;
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
        word-break: break-all;
    }
    tt {
        word-break: break-all;
        display: flex;
        align-items: center;
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
    table.requests td.entries {
        text-align: center;
        vertical-align: middle;
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
    .button-27 {
    appearance: none;
    background-color: #000000;
    border: 2px solid #1A1A1A;
    border-radius: 15px;
    box-sizing: border-box;
    color: #FFFFFF;
    cursor: pointer;
    display: inline-block;
    font-family: Roobert,-apple-system,BlinkMacSystemFont,"Segoe UI",Helvetica,Arial,sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol";
    font-size: 16px;
    font-weight: 600;
    line-height: normal;
    margin: 0;
    min-width: 0;
    outline: none;
    padding: 16px 24px;
    text-align: center;
    text-decoration: none;
    transition: all 300ms cubic-bezier(.23, 1, 0.32, 1);
    user-select: none;
    -webkit-user-select: none;
    touch-action: manipulation;
    width: 120;
    will-change: transform;
    }

    .button-27:disabled {
    pointer-events: none;
    }

    .button-27:hover {
    box-shadow: rgba(0, 0, 0, 0.25) 0 8px 15px;
    transform: translateY(-2px);
    }

    .button-27:active {
    box-shadow: none;
    transform: translateY(0);
    }
</style>
</head>
<body>

    <header>
        <div id="logo"></div>
        <h1>OWASP CRS HTML report</h1>
    </header>

    <p></p>

    <table class="requests">
        <tr>
            <th width="200" >Date / time</th>
            <th width="100" >Engine</th>
            <th>Status</th>
            <th width="150">Remote addr</th>
            <th width="400">Host</th>
            <th>Request</th>
            <th>User Agent</th>
            <th>Main err</th>
            <th width="75" ></th>
        </tr>
        {% for entry in entries%}
            <tr class="overview">
            <td class="entries" >{{ entry["transaction"]["time_stamp"]|e }}</td>
            <td class="entries" ><tt>{{ entry["transaction"]["producer"]["secrules_engine"]|e }}</tt></td>
            <td class="entries" ><tt>{{ entry["transaction"]["response"]["http_code"]|e }}</tt></td>
            <td class="entries" ><tt>{{ entry["transaction"]["client_ip"]|e }}</tt></td>
            <td class="entries" ><tt>{{ entry["transaction"]["request"]["headers"]["host"]|e }}</tt></td>
            <td class="entries" ><tt>{{ entry["transaction"]["request"]["method"]|e }} {{ entry["transaction"]["request"]["uri"]|e }}</tt></td>
            <td class="entries" ><tt>{{ entry["transaction"]["request"]["headers"]["user-agent"]|e }}</tt></td>
            <td class="entries" >
                {% if entry["errors"] %}
                     {{ entry["errors"]|e }}
                {% else %}
                    <i>None</i>
                {% endif %}
            </td>
            <td><button type="button" class="button-27" role="button" onClick="return showDetails(this);">Details</button></td>
            </tr>

            <tr class="details">
            <td colspan="9">
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