class Voicekey < Formula
  desc "VoiceKey Mac receiver: phone types Chinese over LAN, paste at Mac cursor"
  homepage "https://gitee.com/chencanxin/voicekey"
  version "0.7.21"
  url "file:///Users/didi/voicekey-local-dist/voicekey-0.7.21.tar.gz"
  sha256 "e36839d42d8bf5a18bb74aa4140bf4023ca617f01f060ee7ba1acf10c6af2270"
  license "MIT"

  depends_on "go" => :build

  def install
    # 国内网络：走 goproxy.cn 拉模块，校验库用国内镜像
    ENV["GOPROXY"] = "https://goproxy.cn,direct"
    ENV["GOSUMDB"] = "sum.golang.google.cn"
    cd "macrecv" do
      system "go", "build", "-trimpath", "-ldflags", "-s -w", "-o", bin/"voicekey", "."
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
