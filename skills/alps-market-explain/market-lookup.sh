#!/usr/bin/env bash
set -euo pipefail

readonly REPO="txodds/alps-market-catalogue"
readonly SPORTS=(soccer basketball american-football cricket)

usage() {
  cat <<EOF
Usage: $(basename "$0") <query> [sport]

Looks up Alps markets in $REPO (main) and prints each match as JSON,
with the AHCRobots handler mapping per branch.

  query   market type ID (e.g. MATCH_1X2) or part of a market name or ID (e.g. "corners").
          An exact market type ID match returns only that market.
  sport   one of: ${SPORTS[*]} (default: all)

Requires gh, authenticated with read access to $REPO, and jq.
EOF
}

fetch() {
  gh api -H "Accept: application/vnd.github.raw" "repos/$REPO/contents/$1"
}

handler_map() {
  case "$1" in
    soccer) echo soccerHandlers ;;
    basketball) echo basketballHandlers ;;
    american-football) echo usfootballHandlers ;;
    *) echo "" ;;
  esac
}

main() {
  [[ $# -ge 1 && $1 != -h && $1 != --help ]] || { usage; exit $(( $# >= 1 ? 0 : 1 )); }

  local query=$1
  local sports=("${SPORTS[@]}")
  if [[ $# -ge 2 ]]; then
    [[ " ${SPORTS[*]} " == *" $2 "* ]] || { echo "Unknown sport: $2" >&2; usage >&2; exit 1; }
    sports=("$2")
  fi

  local handlers
  handlers=$(fetch robots/handlers.json)

  local sport
  for sport in "${sports[@]}"; do
    fetch "catalogue/$sport.json" | jq \
      --arg q "$query" \
      --arg map "$(handler_map "$sport")" \
      --argjson handlers "$handlers" '
      ($q | ascii_upcase) as $Q
      | . as $cat
      | [ .markets[] | select(.marketTypeIds | index($Q)) ] as $exact
      | (if ($exact | length) > 0 then $exact
         else [ .markets[] | select((.name | gsub("\\\\"; "") | contains($Q)) or any(.marketTypeIds[]; contains($Q))) ]
         end)[]
      | {
          sport: $cat.sport,
          sourceDoc: "\($cat.sourceRepo)/blob/main/\($cat.sourceFile)",
          robotMapping: (
            if $map == "" then null
            else [ .marketTypeIds[] as $id | {
                     ($id): ($handlers.branches | map_values(any(.[$map][]?; .id == $id)))
                   } ] | add
            end
          ),
          handlersGeneratedAt: $handlers.provenance.generatedAt
        } + .'
  done
}

main "$@"
