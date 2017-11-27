# set root dir
root="$( cd "$( dirname $0 )" && pwd )"

# include packages
. "$root/packages"


# require $filepath
function require {
  if [ -e $1 ]; then
	  . $1
	else
	  print_error "cannot find $1"
	fi
}

# create temporary config to use mysql in command line
# must run end_mysql after use
function start_mysql {
  sudo rm -rf ~/.my.cnf
  sudo cat > ~/.my.cnf << EOF
[client]
user=root
host=localhost
password=$db_root_pass
EOF
sudo chmod 0600 ~/.my.cnf
}

# delete the temporary config
function end_mysql {
  sudo rm -rf ~/.my.cnf
}


#print header
function print_title {
  tput setaf 2;echo "";echo "";echo ""
  echo "------------------------------------------------"
  echo ">> $1 "
  echo "------------------------------------------------"
  echo "";tput sgr0
  
}

function print_start {
  tput setaf 2
  echo ""
  echo ">> $1"
  tput sgr0
}

function print_end {
  tput setaf 2
  echo ""
  echo ">> $1"
  echo ""
  tput sgr0
}

# print_error $msg
function print_error {
  tput setaf 1
  echo ">> error: $1"
  tput sgr0	  
}