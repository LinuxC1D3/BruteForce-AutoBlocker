#!/bin/bash

# Banner anzeigen
clear
echo "                                   Created by"
echo "  _       _________ _                            _______  __    ______   ______  "
echo " ( \      \__   __/( (    /||\     /||\     /|  (  ____ \/  \  (  __  \ / ___  \ "
echo " | (         ) (   |  \  ( || )   ( |( \   / )  | (    \/\/) ) | (  \  )\/   \  \ "
echo " | |         | |   |   \ | || |   | | \ (_) /   | |        | | | |   ) |   ___) /  "
echo " | |         | |   | (\ \) || |   | |  ) _ (    | |        | | | |   | |  (___ (   "
echo " | |         | |   | | \   || |   | | / ( ) \   | |        | | | |   ) |      ) \  "
echo " | (____/\___) (___| )  \  || (___) |( /   \ )  | (____/\__) (_| (__/  )/\___/  /  "
echo " (_______/\_______/|/    )_)(_______)|/     \|  (_______/\____/(______/ \______/  "
echo ""

# Die Log-Datei überwachen
LOG_FILE="/var/log/auth.log"
BLOCKED_IPS_FILE="/var/log/blocked_ips.txt"

# Funktionsdefinition zum Extrahieren und Blockieren von IPs
block_failed_ips() {
    # Extrahiert alle IP-Adressen, die mit "Failed password" verbunden sind
    grep "Failed password" "$LOG_FILE" | awk '{print $(NF-3)}' | sort -u | while read IP; do
        # Überprüft, ob die IP bereits blockiert wurde oder ob es die erlaubte IP ist
        if ! grep -q "$IP" "$BLOCKED_IPS_FILE" && [ "$IP" != "YourIP" ]; then
            # Die IP zu der Datei der blockierten IPs hinzufügen
            echo "$IP" >> "$BLOCKED_IPS_FILE"
            
            # Blockiere die IP mit iptables
            iptables -A INPUT -s "$IP" -j DROP
            iptables -A FORWARD -s "$IP" -j DROP
            echo "IP $IP wurde blockiert."
        fi
    done
}

# Überwacht die Log-Datei in 5-Sekunden-Intervallen
while true; do
    # Überprüft, ob es neue fehlgeschlagene Login-Versuche gibt
    if tail -n 30 "$LOG_FILE" | grep -q "Failed password"; then
        block_failed_ips
    fi
    # Warte 5 Sekunden
    sleep 5
done
