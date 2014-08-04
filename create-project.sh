#!/bin/bash

die()
{
  echo "$@"
  exit 1
}

check_program()
{
  which "$@" >/dev/null
  return $?
}

check_environment()
{
  check_program vagrant || die "Vagrant must be installed! Check http://vagrantup.com/ for futher information"
  check_program VBoxManage || die "VirtualBox must be installed! Check http://www.virtualbox.org/ for further information"
}

vagrant_status()
{
  vagrant status 2>/dev/null | grep ^default | awk '{print $2}'
}

start_vagrant()
{
  if [ "$(vagrant_status)" != "running" ]; then
    echo "Starting up vagrant box..."
    vagrant up 2>/dev/null
  fi
}

docker_cmd()
{
  vagrant ssh --command "sudo docker run -i -t -v /home/vagrant:/root $(echo $@)" 2>/dev/null
}

get_template_roots()
{
  find $SCRIPT_ROOT/templates -mindepth 1 -maxdepth 1 -type d
}

read_line()
{
  MESSAGE="$1"
  DEFAULT="$2"

  echo -n "$MESSAGE [$DEFAULT]: " >&2
  read value

  if [ x"$value" != x ]; then
    echo "$value"
  else
    echo "$DEFAULT"
  fi
}

choose_template()
{
  NUM=1

  for dir in $(get_template_roots); do
    echo $NUM. $(basename $dir)
    NUM=$(($NUM+1))
  done

  template_num=$(read_line "Choose a number" "1")
  TEMPLATE=$(get_template_roots | head -n "$template_num" | tail -n 1)
}

SCRIPT_ROOT=$(dirname $0)
TARGET_DIR="$1"

cd $(dirname $0)
check_environment
start_vagrant

choose_template
mkdir -p "$TARGET_DIR"
cp $TEMPLATE/*   $TARGET_DIR
