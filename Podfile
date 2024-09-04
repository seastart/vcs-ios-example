# 指明依赖库的来源地址
source 'https://cdn.cocoapods.org'

# 说明平台和版本
platform :ios, '10.0'

# 忽略引入库的所有警告
inhibit_all_warnings!
use_frameworks!

workspace 'VCSModuleExample.xcworkspace'
project 'VCSModuleExample.xcodeproj'

def commonPods
    # 图片加载库
    pod 'SDWebImage'
    # 重置键盘
    pod 'IQKeyboardManager'
    # 动态响应链
    pod 'ReactiveObjC'
    # 内存泄漏监测
    pod 'MLeaksFinder'
    # 数据模型
    pod 'YYModel'
    # 界面布局组件
    pod 'MyLayout'
end

def vcsmodulePods
  # 流媒体组件
  pod 'VCSMediaKit', :git => "https://github.com/seastart/vcs-mediakit-ios-cocoapods.git"
  # 会控组件
  pod 'VCSMeetLink', :git => "https://github.com/seastart/vcs-meetlink-ios-cocoapods.git"
  # 电子画板组件
  pod 'VCSWhiteBoardKit', :git => "https://github.com/seastart/whiteboardkit-ios-cocoapods.git"
end

target 'VCSModuleExample' do
  commonPods
  vcsmodulePods
end

target 'VCSReplayBroadcastUpload' do
  vcsmodulePods
end

# 更改project配置
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
            config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'NO'
        end
    end
end

pre_install do |installer|
  # 声明文件所在目录
  xcode12_temp_dir = "Pods/FBRetainCycleDetector/FBRetainCycleDetector/Layout/Classes/FBClassStrongLayout.mm"
  # 需要被替换的字符串
  xcode12_temp_findstr = "layoutCache[currentClass] = ivars;"
  # 需要替换成的字符串
  xcode12_temp_replacestr = "layoutCache[(id<NSCopying>)currentClass] = ivars;"
  # Fix for XCode 12.5
  find_and_replace(xcode12_temp_dir, xcode12_temp_findstr, xcode12_temp_replacestr);
  
  # 声明文件所在目录
  xcode13_temp_dir = "Pods/FBRetainCycleDetector/fishhook/fishhook.c"
  # 需要被替换的字符串
  xcode13_temp_findstr = "indirect_symbol_bindings[i] = cur->rebindings[j].replacement;"
  # 需要替换成的字符串
  xcode13_temp_replacestr = "if (i < (sizeof(indirect_symbol_bindings) / sizeof(indirect_symbol_bindings[0]))) { \n indirect_symbol_bindings[i]=cur->rebindings[j].replacement; \n }"
  # Fix for XCode 13.0
  find_and_replace(xcode13_temp_dir, xcode13_temp_findstr, xcode13_temp_replacestr);
  
  # 隐藏传递依赖错误
  def installer.verify_no_static_framework_transitive_dependencies; end
end

# 改动FBRetainCycleDetector适配代码
def find_and_replace(dir, findstr, replacestr)
  Dir[dir].each do |name|
      FileUtils.chmod("+w", name)
      text = File.read(name)
      replace = text.gsub(findstr,replacestr)
      if text != replace
          puts "Fix: " + name
          File.open(name, "w") { |file| file.puts replace }
          STDOUT.flush
      end
  end
  Dir[dir + '*/'].each(&method(:find_and_replace))
end
