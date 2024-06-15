#!/usr/bin/env bash
now=$(date "+%Y%m%d%H%M%S")
me=$(basename "$0")
out=/tmp/.${me}.${now}.out

function _tee() {
  if ! [ -t 0 ]
  then
    if ! command -v tee >/dev/null
    then
      local out="${1:-/dev/null}"
      while IFS= read -r line
      do
        echo "${line}"
        echo "${line}" >> "${out}"
      done
    else
      tee -a "$@"
    fi
  else
    echo "no data from stdin" >&2
    return 1
  fi
}

function _microk8s() {
  [[ -z "${distro}" ]] && distro=$(sed -n 's/^ID=//p' /etc/os-release | sed -e 's/"//g' -e "s/'//g")
  if ! microk8s="$(command -v "microk8s")"
  then
    if [[ "${distro}" =~ alma|centos|rocky|rhel|fedora ]]
    then
      # shellcheck source=/dev/null
      . /etc/profile.d/snapd.sh
      # shellcheck disable=SC2154
      microk8s="sudo ${snap_bin_path}/microk8s"
    fi
  fi
  groups | grep -wq "microk8s" || microk8s="sudo ${microk8s}"
}

function restart_ingress() {
  ${microk8s} kubectl rollout restart -n "${ingress}" daemonset.apps/nginx-ingress-microk8s-controller
  while ! ${microk8s} kubectl -n "${ingress}" get all | grep -q "^pod/nginx-ingress-microk8s-controller.*Running"
  do
    sleep 10
  done
}

function deploy_cert_precheck() {
  [[ -z "${fullchain}" ]] && fullchain="$1"
  [[ -z "${privatekey}" ]] && privatekey="$2"
  if [[ -z "${privatekey}" ]]
  then
    err="required arguments missing: /path/to/fullchain.cer /path/to/private.key"
  elif [[ ! -f "${fullchain}" ]]
  then
    err="file not found: '${fullchain}'"
  elif [[ ! -f "${privatekey}" ]]
  then
    err="file not found: '${privatekey}'"
  fi
  [[ -n "${err}" ]] && return 1
}

function deploy_cert() {
  ${microk8s} kubectl create secret tls "${secret_name}" --cert="${fullchain}" --key="${privatekey}" --namespace="${namespace}"
  if [[ "${namespace}" == "${ingress}" ]]
  then
    ${microk8s} kubectl patch daemonset nginx-ingress-microk8s-controller -n "${ingress}" --type="json" -p='[{"op":"add", "path":"/spec/template/spec/containers/0/args/-", "value":"--default-ssl-certificate'="${ingress}"'/'"${secret_name}"'"}]'
  else
    ${microk8s} kubectl patch ingress dev-fabric-ingress -n "${namespace}" --type="json" -p='[{"op":"add", "path":"/spec/tls/0/secretName", "value":"'"${secret_name}"'"}]'
  fi
  [[ "${skip_restart}" -eq 0 ]] && restart_ingress
}

ingress="ingress"
skip_restart=0
arg_value=0
for arg in "$@"
do
  shift
  [[ "${arg_value}" -gt 0 ]] && { ((arg_value--)); continue; }
  [[ "${arg}" =~ ^"-n"$|^"--namespace"$ ]]   && { namespace="$1";   arg_value=1; continue; }
  [[ "${arg}" =~ ^"-i"$|^"--ingress"$ ]]     && { ingress="$1";     arg_value=1; continue; }
  [[ "${arg}" =~ ^"-s"$|^"--secret-name"$ ]] && { secret_name="$1"; arg_value=1; continue; }
  [[ "${arg}" =~ ^"--skip-restart"$ ]]       && { skip_restart="1";              continue; }
  set -- "$@" "${arg}"
done
deploy_cert_precheck "$1" "$2"

if [[ -n "${err}" ]]
then
  echo "${err}"
  echo "Usage:"
  echo "  ${me} /path/to/fullchain.cer /path/to/private.key"
  exit 1
fi

_microk8s 2> /dev/null
if [[ -z "${namespace}" ]]
then
   [[ -z "${namespace}" ]]   && namespace="${ingress}"
   [[ -z "${secret_name}" ]] && secret_name="custom-tls"
else
   [[ -z "${secret_name}" ]] && secret_name="dev-fabric-private-ingress-ssl"
fi

deploy_cert
