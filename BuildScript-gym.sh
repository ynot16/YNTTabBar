#计时

SECONDS=0

#假设脚本放置在与项目相同的路径下

project_path=$(pwd)
echo "=======project_path: ${project_path}========"

#取当前时间字符串添加到文件结尾

now=$(date +"%Y_%m_%d_%H_%M_%S")

#指定项目的scheme名称

scheme="YNTTabbar"

#指定要打包的配置名

configuration="Release"

#指定打包所使用的输出方式，目前支持app-store, package, ad-hoc, enterprise, development, 和developer-id，即xcodebuild的method参数

export_method="enterprise"

#指定项目地址

workspace_path="$project_path/YNTTabbar.xcworkspace"

#指定输出路径

output_path="/Users/bori-applepc/Documents"

#指定输出归档文件地址

archive_path="$project_path/YNTTabbar_${now}.xcarchive"

#指定输出ipa地址

ipa_path="$project_path/YNTTabbar_${now}.ipa"

#指定输出ipa名称

ipa_name="YNTTabbar_${now}.ipa"

#获取执行命令时的commit message

commit_msg="$1"

#输出设定的变量值

echo "===workspace path: ${workspace_path}==="

echo "===archive path: ${archive_path}==="

echo "===ipa path: ${ipa_path}==="

echo "===export method: ${export_method}==="

echo "===commit msg: $1==="

#先清空前一次build

gym --workspace ${workspace_path} --scheme ${scheme} --clean --configuration ${configuration} --archive_path ${archive_path} --export_method ${export_method} --output_directory ${project_path} --output_name ${ipa_name}
#gym

# 提交信息
commit_msg="first automatic continue intergration test"

# fir Token
fir_token="53d3c02d8e8bea15af26f0c0b27b7100"

fir publish ${IPA_PATH} -T fir_token -c "${commit_msg}"

#输出总用时

echo "===Finished. Total time: ${SECONDS}s==="
