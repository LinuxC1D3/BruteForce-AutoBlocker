# BruteForceBlocker
- Vor kurzem gab es den vorfall das jemand mit massenhaft IPs versuchte meinen Server zu Brute-Forcen.
- Daraufhin schrieb ich ein bash skript das automatisch neue IPs mit Failed Password in der auth log kommen
- direkt in die sperr liste zu iptables. Es scannt alle 5 sekunden die auth log und schaut nach ob neue IPs
- dazu kommen wieder und sperrt sie dann dementsprechend. Um eure IP davon unbetroffen zu machen gebt bitte
- bei YourIP in der Zeile 25 die IP eures PCs ein damit Ihr nicht gesperrt werdet wenn Ihr mal im password
- Failed.
