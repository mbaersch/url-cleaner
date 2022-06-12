# url-cleaner
Google Tag Manager Custom Variable Template for URL cleanup with black- or whitelisting for parameters and optional value redaction with regexes 

**Note**: this template does not need any permissions. 

## Usage
- define any URL as input value. Select **"Whitelist"** and define a set of allowed variables. All other parameters and their values will be eliminated from the URL query string. Alternatively a **"Blacklist"** can be defined in the same way. In this case, only blacklisted parameters are removed.  

- The remaining parameter values can optionally be checked and redacted by using one or more **regex expressions**. 

- if you want to **lowercase** the result, check the option in the variable settings (default is "off")

The return value will be a clean URL, path with parameters or parameter string only. 
