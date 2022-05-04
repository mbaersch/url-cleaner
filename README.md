# url-cleaner
Google Tag Manager Custom Variable Template for URL cleanup with whitelisting for parameters and optional value redaction with regexes 

**Note**: this template does not need any permissions. 

## Usage
define any URL as input value. the template deletes all parameters from the query string that are not added to the whitelist that is defined in the variable settings. The remaining parameter values can optionally be checked and redacted by using one or more regex expressions. 

The return value will be a clean URL, path with parameters or parameter string only. 
