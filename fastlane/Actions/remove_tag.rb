module Fastlane
  module Actions
    module SharedValues
      REMOVE_TAG_CUSTOM_VALUE = :REMOVE_TAG_CUSTOM_VALUE
    end

    class RemoveTagAction < Action

# 1、运行action执行的动作
      def self.run(params)
      
        tagName = params[:tag]
        isRemoveLocalTag = params[:rL]
        isRemoveRemoteTag = params[:rR]
      
        # 1. 先定义一个数组, 用来存储所有需要执行的命令
        cmds = []

        # 2. 往数组里面, 添加相应的命令
        # 删除本地标签
        # git tag -d 标签名称
        if isRemoveLocalTag
        cmds << "git tag -d #{tagName} "
        end
        # 删除远程标签
        # git push origin :标签名称
        if isRemoveRemoteTag
            cmds << " git push origin :#{tagName}"
        end
  
  
        #3. 执行数组里面的所有命令（用&连接，类似git add . & git commit -m这样执行也是可以的）
        result = Actions.sh(cmds.join('&'));
        return result
        end


# 2、描述整个action有什么用
      def self.description
        "牛逼的action"
      end

# 3、详细的描述
      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "此牛逼action，可以删除本地和远程的某一个标签"
      end

# 4、可用选项，传参数
      def self.available_options
        # Define all options your action supports.
        
        # 对传进来的三个参数 tag、rL、rR 进行描述。

        [
            # key：参数名称，tag、rL、rR 。
            # description：描述key对应的是参数tag的是干嘛的。
            # optional：该参数是否可选，true表示该参数可选，可以不传；false表示一定要传。
            # is_string：是指传给key的值是否字符串。
            # default_value：缺省值
            FastlaneCore::ConfigItem.new(key: :tag,
                                         description: "需要被删除的标签名词",
                                         optional:false,
                                         is_string: true),

            FastlaneCore::ConfigItem.new(key: :rL,
                                         description: "是否需要删除本地标签",
                                         optional:true,
                                         is_string: false,
                                         default_value:true), # default_value 默认值，表示没值就默认rL为true

            FastlaneCore::ConfigItem.new(key: :rR,
                                         description: "是否需要删除远程标签",
                                         optional:true,
                                         is_string: false,
                                         default_value:true) # default_value 默认值，表示没值就默认rR为true
        ]
      end

#5、输出，暂时清空
      def self.output

      end

# 返回值，暂时写nil
      def self.return_value
        nil
      end

# 作者的名字
      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["luo feng"]
      end

#平台的描述
      def self.is_supported?(platform)
        # you can do things like
        #
        #  true
        #
        #  platform == :ios
        #
        #  [:ios, :mac].include?(platform)
        #

        platform == :ios
      end
    end
  end
end

