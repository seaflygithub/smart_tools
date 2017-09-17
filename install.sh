CUR_DIR="`pwd`"
source ${CUR_DIR}/global_sys.sh

chmod 755 ${CUR_DIR}/*.sh
${SUDO} cp ${CUR_DIR}/*.sh /usr/bin
cd ${CUR_DIR} ./translate/ ; make install

rm -rf ${CUR_DIR}/install
