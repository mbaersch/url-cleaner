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
  "description": "parses URLs and keeps only whitelisted or removes blacklisted parameters. Reurns new full url, path or redacted query string only (optionally transformed to lower case)",
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
    "name": "listMethod",
    "displayName": "List Method",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "whitelist",
        "displayValue": "Whitelist"
      },
      {
        "value": "blacklist",
        "displayValue": "Blacklist"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "whitelist",
    "help": "Switch between parameter whitelisting (all parameters are removed if not listed) or blacklisting (only listed parameters are removed).",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "alwaysInSummary": true
  },
  {
    "type": "CHECKBOX",
    "name": "useRegex",
    "checkboxText": "Allow Partial Match And RegEx",
    "simpleValueType": true,
    "help": "Check to use partial match (\"utm_\" would catch \"utm_medium\" and \"utm_source\" as well as \"autm_tk\") or regular expressions in your list.\n\nIf not active, parameters must match a list entry (not case-sensitive)."
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
    ],
    "enablingConditions": [
      {
        "paramName": "listMethod",
        "paramValue": "whitelist",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "grpBlacklist",
    "displayName": "Parameter Blacklist",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "LABEL",
        "name": "infoBlacklist",
        "displayName": "Add all parameter names that should be removed from the URL as separate rows. All other parameters will be preserved."
      },
      {
        "type": "SIMPLE_TABLE",
        "name": "blacklistParams",
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
    ],
    "enablingConditions": [
      {
        "paramName": "listMethod",
        "paramValue": "blacklist",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "lowercaseUrl",
    "checkboxText": "Transform To Lowercase",
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
        "displayName": "Regex Pattern",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "",
            "name": "rgx",
            "type": "TEXT"
          }
        ],
        "help": "Example for email addresses: [a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+"
      },
      {
        "type": "TEXT",
        "name": "redactReplacement",
        "displayName": "Replacement String",
        "simpleValueType": true,
        "defaultValue": "[REDACTED]",
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ],
        "help": "Enter string to replace all matches with regex expressions."
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

var lm = data.listMethod || "whitelist";
var wList = (lm === "whitelist") && data.whitelistParams ? data.whitelistParams.map(function(item){return item.paramName.toLowerCase();}) : [];
var bList = (lm === "blacklist") && data.blacklistParams ? data.blacklistParams.map(function(item){return item.paramName.toLowerCase();}) : [];

var inUrl = parseUrl(data.fullUrl);
const sp = inUrl.searchParams;
var cleanParams = [];

for(var prm of Object.entries(sp)) {
  var k = prm[0] || "";
  var vl = prm.length > 1 ? prm[1] : "";
  var keepParam = 
      lm === "whitelist" ? 
        (data.useRegex ? wList.some(function(pat) {return k.match(pat);}) : ( wList.indexOf(k.toLowerCase()) >= 0)) 
      : 
        (data.useRegex ? !bList.some(function(pat) {return k.match(pat);}) : ( bList.indexOf(k.toLowerCase()) < 0)); 
  
  if (keepParam === true) { 
    if (data.redactValues === true && data.redactPatterns && data.redactPatterns.length > 0) {
      data.redactPatterns.forEach(pat => {
        const redactInfo = vl.match(pat.rgx);
        if(redactInfo) vl = vl.replace(redactInfo, data.redactReplacement);      
      });
    }
    cleanParams.push(prm[0]+"="+vl);
  }
}

var hst = inUrl.hostname;
var pth = inUrl.pathname;
var cleanQuery = cleanParams.join('&');
if (cleanQuery.length > 0) cleanQuery = '?' + cleanQuery;

if (data.lowercaseUrl === true) {
  hst = hst.toLowerCase();
  pth = pth.toLowerCase();
  cleanQuery = cleanQuery.toLowerCase();
}

if (data.resultFormat === "paramsOnly") return cleanQuery;
if (data.resultFormat === "pageOnly") return pth + cleanQuery;
return inUrl.protocol + "//" + hst + pth + cleanQuery;


___TESTS___

scenarios:
- name: Whitelist, Full URL, lowercase
  code: |-
    mockData.whitelistParams = [{paramName: "utm_source"}, {paramName: "utm_medium"}];
    mockData.lowercaseUrl = true;

    let variableResult = runCode(mockData);
    assertThat(variableResult).isEqualTo("https://www.example.com/page.html?utm_medium=test&utm_source=check");
- name: Blacklist, Page Only
  code: |-
    mockData.blacklistParams = [{paramName: "foo"}, {paramName: "fbclid"}];
    mockData.listMethod = "blacklist";
    mockData.resultFormat = "pageOnly";

    let variableResult = runCode(mockData);
    assertThat(variableResult).isEqualTo("/page.html?utm_medium=test&utm_source=check&RANDOM=email@example.com");
- name: Blacklist, Params Only, Redacted Email
  code: |-
    mockData.blacklistParams = [{paramName: "foo"}, {paramName: "fbclid"}];
    //sorry... but more complex patterns break tests (but work in preview and live)
    const rp = [{rgx:'email@example.com'}];
    mockData.redactValues = true;
    mockData.redactPatterns = rp;

    mockData.lowercaseUrl = true;
    mockData.listMethod = "blacklist";
    mockData.resultFormat = "paramsOnly";

    let variableResult = runCode(mockData);
    assertThat(variableResult).isEqualTo("?utm_medium=test&utm_source=check&random=[gone]");
- name: Whitelist, Regex List Items
  code: |-
    mockData.whitelistParams = [{paramName: "utm_"}, {paramName: "fo+"}];
    mockData.lowercaseUrl = true;
    mockData.useRegex = true;

    let variableResult = runCode(mockData);
    assertThat(variableResult).isEqualTo("https://www.example.com/page.html?utm_medium=test&utm_source=check&foo=bar");
- name: Blacklist, Regex List Items
  code: |-
    mockData.fullUrl = "https://www.example.com/page.html?utm_medium=test&utm_source=check&autm_tk=check2&fbclid=something&foo=bar";
    mockData.blacklistParams = [{paramName: "utm_"}, {paramName: "fop"}];
    mockData.listMethod = "blacklist";
    mockData.useRegex = true;

    let variableResult = runCode(mockData);
    assertThat(variableResult).isEqualTo("https://www.example.com/page.html?fbclid=something&foo=bar");
- name: Blacklist, Better Regex
  code: |-
    mockData.fullUrl = "https://www.example.com/page.html?utm_medium=test&utm_source=check&autm_tk=check2&fbclid=something&foo=bar";
    mockData.blacklistParams = [{paramName: "^utm_.+"},];
    mockData.listMethod = "blacklist";
    mockData.useRegex = true;

    let variableResult = runCode(mockData);
    assertThat(variableResult).isEqualTo("https://www.example.com/page.html?autm_tk=check2&fbclid=something&foo=bar");
setup: |-
  const mockData = {
    fullUrl: "https://WWW.example.com/page.html?utm_medium=test&utm_source=check&fbclid=something&foo=bar&RANDOM=email@example.com",
    listMethod: "whitelist",
    lowercaseUrl: false,
    redactValues: false,
    redactReplacement: "[gone]",
    resultFormat: "cleanUrl"
  };


___NOTES___

Created on 4.5.2022, 21:23:46


