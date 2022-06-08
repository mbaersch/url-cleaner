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
  "description": "parses URLs and keeps only whitelisted parameters. Reurns new full url, path or redacted query string only (optionalyl transformed to lower case)",
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
    "type": "GROUP",
    "name": "grpWhitelist",
    "displayName": "Parameter Whitelist",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "LABEL",
        "name": "infoWhitelist",
        "displayName": "Add all desired parameter names as separate rows. All other parameters will be removed."
      },
      {
        "type": "SIMPLE_TABLE",
        "name": "whitelistParams",
        "displayName": "Parameter Whitelist Table",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "",
            "name": "paramName",
            "type": "TEXT"
          }
        ],
        "help": ""
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "lowercaseUrl",
    "checkboxText": "Change To Lowercase",
    "simpleValueType": true,
    "help": "Check this option to change the result to lowercase characters. Note: modification happens after whitelisting and application of RegEx filters. This means that both functions will be case-sensitive."
  },
  {
    "type": "CHECKBOX",
    "name": "redactValues",
    "checkboxText": "Redact Values",
    "simpleValueType": true,
    "alwaysInSummary": false,
    "help": "Optional redaction of remaining parameter values with regex patterns."
  },
  {
    "type": "GROUP",
    "name": "grpRegex",
    "displayName": "Regex List",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "LABEL",
        "name": "infoRegex",
        "displayName": "Add one or multiple rows with regex expressions to apply to all remaining parameter values. Matching strings will be replaced with [REDACTED]."
      },
      {
        "type": "SIMPLE_TABLE",
        "name": "redactPatterns",
        "displayName": "",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Regex Pattern",
            "name": "rgx",
            "type": "TEXT"
          }
        ],
        "help": "Example for email addresses: [a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+"
      }
    ],
    "enablingConditions": [
      {
        "paramName": "redactValues",
        "paramValue": true,
        "type": "EQUALS"
      }
    ]
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

var hst = inUrl.hostname;
var pth = inUrl.pathname;
var cleanQuery = cleanParams.join('&');
if (cleanQuery.length > 0) cleanQuery = '?' + cleanQuery;

if (data.lowercaseUrl) {
  hst = hst.toLowerCase();
  pth = pth.toLowerCase();
  cleanQuery = cleanQuery.toLowerCase();
}

if (data.resultFormat === "paramsOnly") return cleanQuery;
if (data.resultFormat === "pageOnly") return pth + cleanQuery;
return inUrl.protocol + "//" + hst + pth + cleanQuery;


___TESTS___

scenarios: []


___NOTES___

Created on 4.5.2022, 21:23:46


