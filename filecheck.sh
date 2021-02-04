#!/bin/bash
WORKFLOWS=(test1/test2)
WARNING_MAX=0
WORKFLOW_ROOT="/workingDirectory"
OUTPUT=""
EMAIL_ADDRESS=(mail@mail.nl)
EMAIL_ADDRESS_CC=(testuser@mail.nl)

if [ -f /tmp/output.txt ]; then
    rm -f /tmp/output.txt
fi

warning_chk() {
    SEND=0
    for WF in "${WORKFLOWS[@]}"
    do
         RES="$(find $WORKFLOW_ROOT/$WF/test3 -type f -not -name "*.tmp" -mmin +$WARNING_MAX | wc -l )"
         if [[ "$RES" -gt 0 ]]; then
             SEND=1
         fi
         set RES_$WF="$RES"
         OUTPUT+="$WF: $RES "
    done

    if [[ "$SEND" -gt 0 ]]; then
    cat > /tmp/output.txt <<__EOF
--- WAARSCHUWING --- WAARSCHUWING --- WAARSCHUWING ---

Op dit moment zijn er nieuwe aanwezig bestanden in de folder: /workingDirectory/test1/test2/test3.
Mogelijk gaat er iets mis met de verwerking.

$OUTPUT
__EOF

cat /tmp/output.txt | mail -s "WAARSCHUWING: Er staan bestanden in de folder: /workingDirectory/test1/test2/test3" "${EMAIL_ADDRESS[@]}" -c "${EMAIL_ADDRESS_CC[@]}"
    else
        return 0
    fi
}

warning_chk


