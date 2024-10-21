#!/usr/bin/env bash
self_path=$(cd -- "$(dirname "${BASH_SOURCE[0]:-$0}")" >/dev/null 2>&1 && pwd)

usage="Usage: $(basename "$0") COMMAND

Commands:
  list                        List all Spaces
  create [OPTIONS] SPACENAME  Launch a Space "SPACENAME". When creating the first Space, Traefik, a reverse proxy will also be deployed
  destroy SPACENAME           Delete the Space "SPACENAME". (Related persistent files are kept and will have to be manually deleted)

Options:
  --profile=PROFILENAME  Select the desired Space Profile
  --compose=FILENAME     Allows user to use a custom Docker compose.yaml file
"

function startTraefik() {
  local state=$(docker ps --all --filter label=k2v-ingress --format "{{.State}}")
  if ! [[ "$state" == "running" ]]; then
    echo "Starting Traefik"
    docker compose -f k2vingress-compose.yaml up -d
  fi
}

function startSpace() {
  local arg
  for arg in "$@"; do
    shift
    [[ "$arg" =~ ^"--compose=" ]] && { compose="${arg#*=}"; continue; }
    [[ "$arg" =~ ^"--heap=" ]] && { MAX_HEAP="${arg#*=}"; continue; }
    [[ "$arg" =~ ^"--profile=" ]] && { PROFILE="${arg#*=}"; continue; }
    [[ "$arg" =~ ^"--fabric-version=" ]] && { FABRIC_VERSION="${arg#*=}"; continue; }
    set -- "$@" "$arg"
  done

  local name="$1"
  [[ -z "$compose" ]] && compose="$self_path/compose.yaml"
  [[ ! -f "$compose" ]] && { echo "compose file not found"; exit 1; }

  [[ -n "$MAX_HEAP" ]] && export MAX_HEAP

  if [[ -n "$PROFILE" ]]; then
    [[ ! -f "$self_path/$PROFILE.config" ]] && { echo "profile not found"; exit 1; }
    export PROFILE
    local profile="--profile $PROFILE"
  fi

  [[ -n "$FABRIC_VERSION" ]] && export FABRIC_VERSION

  docker compose -p "$name" -f "$compose" $profile up -d
  startTraefik
}

command="$1"
shift
case "$command" in
  create | start | up)
    startSpace "$@"
    ;;
  destroy | rm | down)
    docker compose -p "$1" down
    ;;
  list)
    [[ -z "$HOSTNAME" ]] && HOSTNAME="localhost"
    if command -v column >/dev/null; then
      (echo -e "SPACE\tPROFILE\tSTATE\tURL\tPORTS" && docker ps --all --filter label=k2viewspace --format "{{.Label \"com.docker.compose.project\"}}\t{{.Label \"space-profile\"}}\t{{.State}}\thttp://$HOSTNAME/{{.Label \"com.docker.compose.project\"}}/\t{{.Ports}}") | column -t -s $'\t'
    else
      docker ps --all --filter label=k2viewspace --format "table {{.Label \"com.docker.compose.project\"}}\t{{.Label \"space-profile\"}}\t{{.State}}\thttp://$HOSTNAME/{{.Label \"com.docker.compose.project\"}}/\t{{.Ports}}"
    fi
    ;;
  *)
    echo "$usage"
    ;;
esac
