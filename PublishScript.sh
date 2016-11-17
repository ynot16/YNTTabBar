#!/bin/sh

#  Publish.sh
#  BROnlineLearning
#
#  Created by bori－applepc on 16/8/29.
#  Copyright © 2016年 Bori Information Technology Co., Ltd. All rights reserved.


# 工程名
APP_NAME="YNTTabbar"
# 证书
CODE_SIGN_DISTRIBUTION="iPhone Distribution: Guangzhou Bori Information Technology Co., Ltd."
# info.plist路径
project_infoplist_path="./${APP_NAME}/Info.plist"
# 取版本号
bundleShortVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" "${project_infoplist_path}")
# 取bulid值
budleVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" "${project_infoplist_path}")

DATE="$(date +%Y%m%d)"
IPANAME="${APP_NAME}_V${bundleShortVersion}_${DATE}.ipa"

# 要上传的ipa文件路径
IPA_PATH="$HOME/${IPANAME}"

# 提交信息
commit_msg="first automatic continue intergration test"

fir publish ${IPA_PATH} -T 53d3c02d8e8bea15af26f0c0b27b7100 -c "${commit_msg}"
