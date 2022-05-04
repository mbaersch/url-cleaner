___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "URL Cleaner",
  "categories": [
    "UTILITY"
  ],
  "description": "parses URLs and keeps only whitelisted parameters. Reurns new full url, path or redacted query string only.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "fullUrl",
    "displayName": "Full URL",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "alwaysInSummary": true
  },
  {
    "type": "SELECT",
    "name": "resultFormat",
    "displayName": "Result Format",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "paramsOnly",
        "displayValue": "Clean Parameter String"
      },
      {
        "value": "pageOnly",
        "displayValue": "Clean Page Path With Parameters"
      },
      {
        "value": "cleanUrl",
        "displayValue": "Clean URL"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "cleanUrl",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "alwaysInSummary": true
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "whitelistParams",
    "displayName": "Parameter Whitelist Table",
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "Parameter Name",
        "name": "paramName",
        "type": "TEXT"
      }
    ],
    "help": "add rows for every parameter name that should be preserved (case insensitive). All other parameters will be deleted."
  },
  {
    "type": "CHECKBOX",
    "name": "redactValues",
    "checkboxText": "Redact Values",
    "simpleValueType": true,
    "alwaysInSummary": true,
    "help": "Optional redaction of remaining parameter values with regex patterns."
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "redactPatterns",
    "displayName": "Redaction Regex Pattern Table",
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "Regex",
        "name": "rgx",
        "type": "TEXT"
      }
    ],
    "help": "matching strings in values will be replaced with [REDACTED]. Example for email addresses: [a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+",
    "enablingConditions": [
      {
        "paramName": "redactValues",
        "paramValue": true,
        "type": "EQUALS"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

var Object = require("Object");
var parseUrl = require("parseUrl");

var wList = data.whitelistParams ? data.whitelistParams.map(function(item){return item.paramName.toLowerCase();}) : [];

var inUrl = parseUrl(data.fullUrl);
const sp = inUrl.searchParams;
var cleanParams = [];

for(var prm of Object.entries(sp)) {
  var k = prm[0] || "";
  var vl = prm.length > 1 ? prm[1] : "";
  if (wList.indexOf(k.toLowerCase()) >= 0) { 
    if (data.redactValues === true && data.redactPatterns && data.redactPatterns.length > 0) {
      data.redactPatterns.forEach(pat => {
        const redactInfo = vl.match(pat.rgx);
        if(redactInfo) vl = vl.replace(redactInfo,'[REDACTED]');      
      });
    }
    cleanParams.push(prm[0]+"="+vl);
  }
}

var cleanQuery = cleanParams.join('&');
if (cleanQuery.length > 0) cleanQuery = '?' + cleanQuery;

if (data.resultFormat === "paramsOnly") return cleanQuery;
if (data.resultFormat === "pageOnly") return inUrl.pathname + cleanQuery;
return inUrl.protocol + "//" + inUrl.hostname + inUrl.pathname + cleanQuery;


___TESTS___

scenarios: []


___NOTES___

Created on 4.5.2022, 21:23:46


