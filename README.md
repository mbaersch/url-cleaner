# URL Cleaner 

**Custom Variable Template for Google Tag Manager**

URL cleanup with black- or whitelisting for parameters and optional value redaction with regexes 

[![Template Status](https://img.shields.io/badge/Community%20Template%20Gallery%20Status-published-green)](https://tagmanager.google.com/gallery/#/owners/mbaersch/templates/url-cleaner) ![Repo Size](https://img.shields.io/github/repo-size/mbaersch/url-cleaner) ![License](https://img.shields.io/github/license/mbaersch/url-cleaner)

---

**Note**: this template does not need any permissions. 

## Usage
- define any URL as input value. Select **"Whitelist"** and define a set of allowed variables. All other parameters and their values will be eliminated from the URL query string. Alternatively a **"Blacklist"** can be defined in the same way. In this case, only blacklisted parameters are removed.  

- The remaining parameter values can optionally be checked and redacted by using one or more **regex expressions**. 

- if you want to **lowercase** the result, check the option in the variable settings (default is "off")

The return value will be a clean URL, path with parameters or parameter string only. 

## "Partial Match And RegEx" Option
when comparing parameter keys with white- or blacklist entries, you can optionally enter only a common part of a set of parameters (like `utm_`) or use  regular expressions. 

When active, the template uses a JavaScript "match" (https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/match) to determine if a parameter is to be white- or blacklisted. If not, a parameter must be equal to an entry on the list to be handled by the code. 

using a blacklist on `https://www.domain.com/?foo=1&bar=0&find=PII+here&find2=keep` with `find` on the list results in 

`https://www.domain.com/?foo=1&bar=0`

if you use `^find$` instead, the result will only delete the first parameter and keeps `find2`

`https://www.test.com/?foo=1&bar=0&find2=keep`    

### Special Functions
#### Radacting Parameters Without Removing
If you want to redact parameters without removing them (for controlling purposes or other reasons), you can use the "Redact Parameters" option and define a parameter name instead of a regex. In this case, the template does not match the list entry as RegEx against the values but compares any list entry with parameter names, when a special format is used. 

In order to use this, add parameter names in the following format to the list: 

`%%parametername%%`

By surrounding a parameter name with double "%" signs, any matching `parametername` in the URL will be kept in the result, but the value gets replaced with the defined text just as if a normal RegEx had matched the parameter value. Note: this option works case insensitive, so `%%something%%` would catch "Something" as well as "something", "someThing" or any other format. There must be a complete match (no RegEx or partial match here).  

#### Using Comma-separated List Items
You can define multiple comma-separated values like `param1, param2, param3` in one list entry instead of creating three separate list items for black- and whitelists. This allows dynamic definition of blacklists in a separate variable that uses different sets of list items for different consent conditions. 
