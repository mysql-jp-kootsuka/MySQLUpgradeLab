. ./common/comm.sh

echo $CURRENT_DIR
echo $MYSQL_DIR

#
# Script to download from my.oracle.com
# MySQL Server 5.7, 8.0, 8.4, 9.0
# MySQL Shell  8.0, 8.4, 9.0
#
# Start of user configurable variables
#
LANG=C
export LANG

# Trap to cleanup cookie file in case of unexpected exits.
trap 'rm -f $COOKIE_FILE; exit 1' 1 2 3 6

if [ ! -d $MYSQL_DIR ]; then
  mkdir -p $MYSQL_DIR
else
  # 存在して空でない場合は警告を出して終了
  if [ -n "$(ls -A $MYSQL_DIR)" ]; then
    echo "File existed in '$MYSQL_DIR' please check and remove them first."
#    exit 1
  fi
fi

#####################################################
# CONFIGURABLE VARIABLES
#####################################################
# Set these variables with the link available on https://downloads.mysql.com/
# MySQL Server 5.7
# MySQL Database 5.7.44 TAR for Generic Linux (glibc2.12) x86 (64bit) (Patchset)
# https://downloads.mysql.com/archives/get/p/23/file/mysql-5.7.44-linux-glibc2.12-x86_64.tar
export MOS_LINK_SRV57_TAR='https://downloads.mysql.com/archives/get/p/23/file/mysql-5.7.44-linux-glibc2.12-x86_64.tar'

# MySQL Server 8.0
# MySQL Commercial Server 8.0.39 Minimal TAR for Generic Linux (glibc2.17) x86 (64bit) (Patchset)
# https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.39-linux-glibc2.17-x86_64.tar
export MOS_LINK_SRV80_TAR='https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.39-linux-glibc2.17-x86_64.tar'

# MySQL Server 8.4
# MySQL Commercial Server 8.4.2 Minimal TAR for Generic Linux (glibc2.17) x86 (64bit) (Patchset)
# https://dev.mysql.com/get/Downloads/MySQL-8.4/mysql-8.4.2-linux-glibc2.17-x86_64.tar
export MOS_LINK_SRV84_TAR='https://dev.mysql.com/get/Downloads/MySQL-8.4/mysql-8.4.2-linux-glibc2.17-x86_64.tar'

# MySQL Server 9.0
# MySQL Commercial Server 9.0.1 Minimal TAR for Generic Linux (glibc2.17) x86 (64bit) (Patchset)
# https://dev.mysql.com/get/Downloads/MySQL-9.0/mysql-9.0.1-linux-glibc2.17-x86_64.tar
export MOS_LINK_SRV90_TAR='https://dev.mysql.com/get/Downloads/MySQL-9.0/mysql-9.0.1-linux-glibc2.17-x86_64.tar'

# MySQL Shell 8.0
# MySQL Shell 8.0.38 TAR for Generic Linux (glibc2.17) x86 (64bit) (Patchset)
# https://dev.mysql.com/get/Downloads/MySQL-Shell/mysql-shell-8.0.38-linux-glibc2.17-x86-64bit.tar.gz
export MOS_LINK_SHE80_TAR='https://dev.mysql.com/get/Downloads/MySQL-Shell/mysql-shell-8.0.38-linux-glibc2.17-x86-64bit.tar.gz'

# MySQL Shell 8.4
# MySQL Shell 8.4.1 TAR for Generic Linux (glibc2.17) x86 (64bit) (Patchset)
# https://dev.mysql.com/get/Downloads/MySQL-Shell/mysql-shell-8.4.1-linux-glibc2.17-x86-64bit.tar.gz
export MOS_LINK_SHE84_TAR='https://dev.mysql.com/get/Downloads/MySQL-Shell/mysql-shell-8.4.1-linux-glibc2.17-x86-64bit.tar.gz'

# MySQL Shell 9.0
# MySQL Shell 9.0.1 TAR for Generic Linux (glibc2.17) x86 (64bit) (Patchset)
# https://dev.mysql.com/get/Downloads/MySQL-Shell/mysql-shell-9.0.1-linux-glibc2.17-x86-64bit.tar.gz
export MOS_LINK_SHE90_TAR='https://dev.mysql.com/get/Downloads/MySQL-Shell/mysql-shell-9.0.1-linux-glibc2.17-x86-64bit.tar.gz'

# Databases
export WORLD_DB='https://downloads.mysql.com/docs/world-db.zip'

# Path to wget command
WGET=/usr/bin/wget

# Log directory and file
LOGFILE=$PROJECT_DIR/wgetlog-$(date +%m-%d-%y-%H:%M).log
echo $LOGFILE

# Print wget version info
echo "Wget version info:
------------------------------
$($WGET -V)
------------------------------" > "$LOGFILE" 2>&1

# Location of cookie file
COOKIE_FILE=$(mktemp -t wget_sh_XXXXXX) >> "$LOGFILE" 2>&1
if [ $? -ne 0 ] || [ -z "$COOKIE_FILE" ]
then
 echo "Temporary cookie file creation failed. See $LOGFILE for more details." |  tee -a "$LOGFILE"
 exit 1
fi
echo "Created temporary cookie file $COOKIE_FILE" | tee -a "$LOGFILE"

#
# End of user configurable variable
#

# The following command to authenticate uses HTTPS. This will work only if the wget in the environment
# where this script will be executed was compiled with OpenSSL.
#

echo "Proceeding with downloads..." | tee -a "$LOGFILE"

# MySQL Server 5.7
echo "Downloading MySQL Server 5.7..." | tee -a "$LOGFILE"
$WGET  --load-cookies="$COOKIE_FILE" "$MOS_LINK_SRV57_TAR" -O "$MYSQL_DIR/57.tar"   >> "$LOGFILE" 2>&1

# MySQL Server 8.0
echo "Downloading MySQL Server 8.0..." | tee -a "$LOGFILE"
$WGET  --load-cookies="$COOKIE_FILE" "$MOS_LINK_SRV80_TAR" -O "$MYSQL_DIR/80.tar"   >> "$LOGFILE" 2>&1

# MySQL Server 8.4
echo "Downloading MySQL Server 8.4..." | tee -a "$LOGFILE"
$WGET  --load-cookies="$COOKIE_FILE" "$MOS_LINK_SRV84_TAR" -O "$MYSQL_DIR/84.tar"   >> "$LOGFILE" 2>&1

# MySQL Server 9.0
echo "Downloading MySQL Server 9.0..." | tee -a "$LOGFILE"
$WGET  --load-cookies="$COOKIE_FILE" "$MOS_LINK_SRV90_TAR" -O "$MYSQL_DIR/90.tar"   >> "$LOGFILE" 2>&1

# MySQL Shell 8.0
echo "Downloading MySQL Shell 8.0..." | tee -a "$LOGFILE"
$WGET  --load-cookies="$COOKIE_FILE" "$MOS_LINK_SHE80_TAR" -O "$MYSQL_DIR/80sh.tar.gz"   >> "$LOGFILE" 2>&1

# MySQL Shell 8.4
echo "Downloading MySQL Shell 8.4..." | tee -a "$LOGFILE"
$WGET  --load-cookies="$COOKIE_FILE" "$MOS_LINK_SHE84_TAR" -O "$MYSQL_DIR/84sh.tar.gz"   >> "$LOGFILE" 2>&1

# MySQL Shell 9.0
echo "Downloading MySQL Shell 9.0..." | tee -a "$LOGFILE"
$WGET  --load-cookies="$COOKIE_FILE" "$MOS_LINK_SHE90_TAR" -O "$MYSQL_DIR/90sh.tar.gz"   >> "$LOGFILE" 2>&1

cd "$MYSQL_DIR"

# Unzip files
echo "Extract file 57.tar..." | tee -a "$LOGFILE"
tar x -f 57.tar 2>&1 >> "$LOGFILE"
tar xz -f mysql-5*tar.gz 2>&1 >> "$LOGFILE"

echo "Extract file 80.tar..." | tee -a "$LOGFILE"
tar x -f 80.tar 2>&1 >> "$LOGFILE"
xzcat mysql-8.0*tar.xz | tar x 2>&1 >> "$LOGFILE"

echo "Extract file 84.tar..." | tee -a "$LOGFILE"
tar x -f 84.tar 2>&1 >> "$LOGFILE"
xzcat mysql-8.4*tar.xz | tar x 2>&1 >> "$LOGFILE"

echo "Extract file 90.tar..." | tee -a "$LOGFILE"
tar x -f 90.tar 2>&1 >> "$LOGFILE"
xzcat mysql-9*tar.xz | tar x 2>&1 >> "$LOGFILE"

echo "Extract file 80sh.tar.gz..." | tee -a "$LOGFILE"
tar xz -f 80sh.tar.gz 2>&1 >> "$LOGFILE"

echo "Extract file 84sh.tar.gz..." | tee -a "$LOGFILE"
tar xz -f 84sh.tar.gz 2>&1 >> "$LOGFILE"

echo "Extract file 90sh.tar.gz..." | tee -a "$LOGFILE"
tar xz -f 90sh.tar.gz 2>&1 >> "$LOGFILE"

# Renaming files
echo "Renaming files" | tee -a "$LOGFILE"
mv mysql-5.7*x86_64 57
mv mysql-8.0*x86_64 80
mv mysql-8.4*x86_64 84
mv mysql-9.0*x86_64 90

mv mysql-shell*8.0*x86-64bit 80sh
mv mysql-shell*8.4*x86-64bit 84sh
mv mysql-shell*9.0*x86-64bit 90sh

rm 57.tar
rm 80.tar
rm 84.tar
rm 90.tar

rm 80sh.tar.gz
rm 84sh.tar.gz
rm 90sh.tar.gz

rm mysql-*.tar.*z

cd "$PROJECT_DIR"

# Cleanup
rm -f "$COOKIE_FILE"
echo "Removed temporary cookie file $COOKIE_FILE" >> "$LOGFILE"
