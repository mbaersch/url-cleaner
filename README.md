# URL Cleaner (url-cleaner)
Google Tag Manager Custom Variable Template for URL cleanup with black- or whitelisting for parameters and optional value redaction with regexes 

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
