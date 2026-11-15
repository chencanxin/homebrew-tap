class Voicekey < Formula
  desc "VoiceKey Mac receiver: phone types Chinese over LAN, paste at Mac cursor"
  homepage "https://gitee.com/chencanxin/voicekey"
  version "0.7.22"
  url "file:///Users/didi/voicekey-local-dist/voicekey-0.7.22.tar.gz"
  sha256 "e04353500b614925b5b66beede017c04a576c84b092b01923c5376bf795ef54f"
  license "MIT"

  depends_on "go" => :build

  def install
    # 国内网络：走 goproxy.cn 拉模块，校验库用国内镜像
    ENV["GOPROXY"] = "https://goproxy.cn,direct"
    ENV["GOSUMDB"] = "sum.golang.google.cn"
    cd "macrecv" do
      system "go", "build", "-trimpath", "-ldflags", "-s -w", "-o", bin/"voicekey", "."
    end
    # 自签名证书固定 TCC 辅助功能授权锚点（DR 锚定证书而非单次构建哈希），
    # 用户只需授权一次，后续发版不再要求重新勾选。
    # 证书不在本机时跳过——voicekey 自更新流程会在升级后自行补签兜底。
    keychain = "#{Dir.home}/Library/Keychains/login.keychain-db"
    if system("security", "find-certificate", "-c", "VoiceKey Dev", keychain, out: "/dev/null", err: "/dev/null")
      system "codesign", "--force", "--sign", "VoiceKey Dev",
             "--identifier", "com.chencanxin.voicekey", bin/"voicekey"
    end
  end

  def caveats
    <<~EOS
      启动：终端运行 voicekey（会自动打开浏览器仪表盘，数据端口 7979）。
      首次运行后需授权一次：系统设置 → 隐私与安全性 → 辅助功能 → 勾选 voicekey。
      自更新已内置：每 60 秒自动检查新版本，自动 brew upgrade 并自重启（辅助功能授权可能需重新勾选一次）。
    EOS
  end
end
