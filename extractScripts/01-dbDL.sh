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
    exit 1
  fi
fi

# SSO username
if [ ! $SSO_USERNAME ]; then
  printf 'SSO UserName:'
  read SSO_USERNAME
fi

#####################################################
# CONFIGURABLE VARIABLES
#####################################################
# Set these variables with the link available on https://support.oracle.com
# MySQL Server 5.7
# MySQL Database 5.7.44 TAR for Generic Linux (glibc2.12) x86 (64bit) (Patchset)
# https://updates.oracle.com/Orion/Services/download/p35942334_570_Linux-x86-64.zip?aru=25431377&patch_file=p35942334_570_Linux-x86-64.zip
export MOS_LINK_SRV57_TAR='https://updates.oracle.com/Orion/Services/download/p35942334_570_Linux-x86-64.zip?aru=25431377&patch_file=p35942334_570_Linux-x86-64.zip'

# MySQL Server 8.0
# MySQL Commercial Server 8.0.39 Minimal TAR for Generic Linux (glibc2.17) x86 (64bit) (Patchset)
# https://updates.oracle.com/Orion/Services/download/p36866489_580_Linux-x86-64.zip?aru=25759887&patch_file=p36866489_580_Linux-x86-64.zip
export MOS_LINK_SRV80_TAR='https://updates.oracle.com/Orion/Services/download/p36866489_580_Linux-x86-64.zip?aru=25759887&patch_file=p36866489_580_Linux-x86-64.zip'

# MySQL Server 8.4
# MySQL Commercial Server 8.4.2 Minimal TAR for Generic Linux (glibc2.17) x86 (64bit) (Patchset)
# https://updates.oracle.com/Orion/Services/download/p36869164_840_Linux-x86-64.zip?aru=25760707&patch_file=p36869164_840_Linux-x86-64.zip
export MOS_LINK_SRV84_TAR='https://updates.oracle.com/Orion/Services/download/p36869164_840_Linux-x86-64.zip?aru=25760707&patch_file=p36869164_840_Linux-x86-64.zip'

# MySQL Server 9.0
# MySQL Commercial Server 9.0.1 Minimal TAR for Generic Linux (glibc2.17) x86 (64bit) (Patchset)
# https://updates.oracle.com/Orion/Services/download/p36866262_100_Linux-x86-64.zip?aru=25759695&patch_file=p36866262_100_Linux-x86-64.zip
export MOS_LINK_SRV90_TAR='https://updates.oracle.com/Orion/Services/download/p36866262_100_Linux-x86-64.zip?aru=25759695&patch_file=p36866262_100_Linux-x86-64.zip'

# MySQL Shell 8.0
# MySQL Shell 8.0.38 TAR for Generic Linux (glibc2.17) x86 (64bit) (Patchset)
# https://updates.oracle.com/Orion/Services/download/p36790628_800_Linux-x86-64.zip?aru=25736701&patch_file=p36790628_800_Linux-x86-64.zip
export MOS_LINK_SHE80_TAR='https://updates.oracle.com/Orion/Services/download/p36790628_800_Linux-x86-64.zip?aru=25736701&patch_file=p36790628_800_Linux-x86-64.zip'

# MySQL Shell 8.4
# MySQL Shell 8.4.1 TAR for Generic Linux (glibc2.17) x86 (64bit) (Patchset)
export MOS_LINK_SHE84_TAR='https://updates.oracle.com/Orion/Services/download/p36789151_840_Linux-x86-64.zip?aru=25736073&patch_file=p36789151_840_Linux-x86-64.zip'

# MySQL Shell 9.0
# MySQL Shell 9.0.1 TAR for Generic Linux (glibc2.17) x86 (64bit) (Patchset)
# https://updates.oracle.com/Orion/Services/download/p36865757_100_Linux-x86-64.zip?aru=25759599&patch_file=p36865757_100_Linux-x86-64.zip
export MOS_LINK_SHE90_TAR='https://updates.oracle.com/Orion/Services/download/p36865757_100_Linux-x86-64.zip?aru=25759599&patch_file=p36865757_100_Linux-x86-64.zip'

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
echo "SSO UserName is $SSO_USERNAME" | tee -a "$LOGFILE"

 $WGET  --secure-protocol=auto --save-cookies="$COOKIE_FILE" --keep-session-cookies  --http-user "$SSO_USERNAME" --ask-password  "https://updates.oracle.com/Orion/Services/download" -O /dev/null 2>> "$LOGFILE"

# Verify if authentication is successful
if [ $? -ne 0 ]
then
 echo "Authentication failed with the given credentials." | tee -a "$LOGFILE"
 echo "Please check logfile: $LOGFILE for more details."
else
 echo "Authentication is successful. Proceeding with downloads..." | tee -a "$LOGFILE"

# MySQL Server 5.7
echo "Downloading MySQL Server 5.7..." | tee -a "$LOGFILE"
$WGET  --load-cookies="$COOKIE_FILE" "$MOS_LINK_SRV57_TAR" -O "$MYSQL_DIR/57.zip"   >> "$LOGFILE" 2>&1

# MySQL Server 8.0
echo "Downloading MySQL Server 8.0..." | tee -a "$LOGFILE"
$WGET  --load-cookies="$COOKIE_FILE" "$MOS_LINK_SRV80_TAR" -O "$MYSQL_DIR/80.zip"   >> "$LOGFILE" 2>&1

# MySQL Server 8.4
echo "Downloading MySQL Server 8.4..." | tee -a "$LOGFILE"
$WGET  --load-cookies="$COOKIE_FILE" "$MOS_LINK_SRV84_TAR" -O "$MYSQL_DIR/84.zip"   >> "$LOGFILE" 2>&1

# MySQL Server 9.0
echo "Downloading MySQL Server 9.0..." | tee -a "$LOGFILE"
$WGET  --load-cookies="$COOKIE_FILE" "$MOS_LINK_SRV90_TAR" -O "$MYSQL_DIR/90.zip"   >> "$LOGFILE" 2>&1

# MySQL Shell 8.0
echo "Downloading MySQL Shell 8.0..." | tee -a "$LOGFILE"
$WGET  --load-cookies="$COOKIE_FILE" "$MOS_LINK_SHE80_TAR" -O "$MYSQL_DIR/80sh.zip"   >> "$LOGFILE" 2>&1

# MySQL Shell 8.4
echo "Downloading MySQL Shell 8.4..." | tee -a "$LOGFILE"
$WGET  --load-cookies="$COOKIE_FILE" "$MOS_LINK_SHE84_TAR" -O "$MYSQL_DIR/84sh.zip"   >> "$LOGFILE" 2>&1

# MySQL Shell 9.0
echo "Downloading MySQL Shell 9.0..." | tee -a "$LOGFILE"
$WGET  --load-cookies="$COOKIE_FILE" "$MOS_LINK_SHE90_TAR" -O "$MYSQL_DIR/90sh.zip"   >> "$LOGFILE" 2>&1

fi

cd "$MYSQL_DIR"

# Unzip files
echo "Unzip file 57.zip..." | tee -a "$LOGFILE"
unzip -p 57.zip "*tar.gz"|tar xz 2>&1 >> "$LOGFILE"

echo "Unzip file 80.zip..." | tee -a "$LOGFILE"
unzip -p 80.zip "*tar.xz"| xzcat |tar x 2>&1 >> "$LOGFILE"

echo "Unzip file 84.zip..." | tee -a "$LOGFILE"
unzip -p 84.zip "*tar.xz"| xzcat |tar x 2>&1 >> "$LOGFILE"

echo "Unzip file 90.zip..." | tee -a "$LOGFILE"
unzip -p 90.zip "*tar.xz"| xzcat |tar x 2>&1 >> "$LOGFILE"

echo "Unzip file 80sh.zip..." | tee -a "$LOGFILE"
unzip -p 80sh.zip "*tar.gz"|tar xz 2>&1 >> "$LOGFILE"

echo "Unzip file 84sh.zip..." | tee -a "$LOGFILE"
unzip -p 84sh.zip "*tar.gz"|tar xz 2>&1 >> "$LOGFILE"

echo "Unzip file 90sh.zip..." | tee -a "$LOGFILE"
unzip -p 90sh.zip "*tar.gz"|tar xz 2>&1 >> "$LOGFILE"

# Renaming files
echo "Renaming files" | tee -a "$LOGFILE"
mv mysql-advanced-5.7* 57
mv mysql-commercial-8.0* 80
mv mysql-commercial-8.4* 84
mv mysql-commercial-9.0* 90

mv mysql-shell*8.0* 80sh
mv mysql-shell*8.4* 84sh
mv mysql-shell*9.0* 90sh

rm 57.zip
rm 80.zip
rm 84.zip
rm 90.zip

rm 80sh.zip
rm 84sh.zip
rm 90sh.zip

cd "$PROJECT_DIR"

# Cleanup
rm -f "$COOKIE_FILE"
echo "Removed temporary cookie file $COOKIE_FILE" >> "$LOGFILE"
