#!/usr/bin/env bash
# Erstellt eine Commit-Message mit einer Zusammenfassung der durch
# `nix flake update` geänderten Inputs (für update-flake.yml).
#
# Usage: flake-lock-summary.sh <altes flake.lock> <neues flake.lock>
set -euo pipefail

old="$1"
new="$2"

echo "Update flake.lock by GitHub Actions"
echo

jq -rn \
  --slurpfile old "$old" \
  --slurpfile new "$new" \
  '
  ($old[0].nodes) as $o
  | ($new[0].nodes) as $n
  # Oberste Input-Namen aus flake.nix auf die (ggf. umbenannten) Knoten-IDs
  # im Lockfile mappen, damit z. B. "nixpkgs" statt "nixpkgs_2" erscheint.
  | ($n.root.inputs // {}) as $rootInputs
  | ( [ $rootInputs | to_entries[] | { (.value): .key } ] | add // {} ) as $displayName
  # Nur die in flake.nix direkt angegebenen Inputs betrachten, nicht jeden
  # transitiven Lockfile-Knoten - sonst würde jede Nebenabhängigkeit (z. B.
  # flake-parts, das nur von claude-desktop gebraucht wird) die Commit-Message
  # aufblähen, obwohl sie für Menschen kaum relevant ist.
  | [ $displayName | keys[] | select($o[.] != null) ] as $names
  | [ $names[]
      | select(
          ($o[.].locked.rev // $o[.].locked.narHash // "")
          != ($n[.].locked.rev // $n[.].locked.narHash // "")
        )
    ] as $changed
  | if ($changed | length) == 0 then
      "Nur transitive Abhängigkeiten aktualisiert, keine direkten flake.nix-Inputs."
    else
      $changed
      | map({id: ., name: ($displayName[.] // .)})
      | sort_by(.name)
      | .[]
      | .id as $id
      | .name as $name
      | (if $o[$id].locked.rev then $o[$id].locked.rev[0:7]
         else ($o[$id].locked.lastModified | tostring) end) as $orev
      | (if $n[$id].locked.rev then $n[$id].locked.rev[0:7]
         else ($n[$id].locked.lastModified | tostring) end) as $nrev
      | "- \($name): \($orev) → \($nrev)"
    end
  '
